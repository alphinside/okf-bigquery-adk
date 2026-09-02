-- 2,000 synthetic orders and payments. Every value derives from
-- FARM_FINGERPRINT of the order id, so reruns produce identical data.
--
-- The distribution is hostile on purpose: a naive query and a correct one must
-- return visibly different numbers. Cases A to D below are what make that true,
-- and seed/verify.sql fails if any of them disappears. status_code = 200 covers
-- 80% of payments while only 55% settled.
--
-- Synthetic names only. The transaction_status values match the public API of a
-- real payment gateway, unnamed here.

TRUNCATE TABLE marketplace.orders;
TRUNCATE TABLE marketplace.payments;

CREATE TEMP TABLE gen AS
WITH base AS (
  SELECT
    i,
    FORMAT('ORD-%05d', i) AS order_id,
    ABS(FARM_FINGERPRINT(FORMAT('okf-marketplace-seed-%05d', i))) AS h
  FROM UNNEST(GENERATE_ARRAY(1, 2000)) AS i
),
shaped AS (
  SELECT
    order_id,
    FORMAT('PAY-%05d', i) AS payment_id,
    FORMAT('CUST-%04d', MOD(DIV(h, 7), 900)) AS customer_id,
    CAST(50000 + MOD(DIV(h, 131), 4950) * 1000 AS NUMERIC) AS gross_amount,
    -- 70 days from 2026-06-25, so both month boundaries land inside the data.
    TIMESTAMP_ADD(
      TIMESTAMP '2026-06-25 00:00:00+07',
      INTERVAL MOD(i, 70) * 24 + MOD(DIV(h, 3), 24) HOUR
    ) AS order_ts,
    [
      -- Jabodetabek (13). No column marks them. Only the OKF bundle does.
      'Kota Jakarta Pusat', 'Kota Jakarta Utara', 'Kota Jakarta Barat',
      'Kota Jakarta Selatan', 'Kota Jakarta Timur',
      'Kota Bogor', 'Kab. Bogor', 'Kota Depok',
      'Kota Tangerang', 'Kota Tangerang Selatan', 'Kab. Tangerang',
      'Kota Bekasi', 'Kab. Bekasi',
      -- Elsewhere in Indonesia (7).
      'Kota Bandung', 'Kota Surabaya', 'Kota Semarang', 'Kota Medan',
      'Kota Makassar', 'Kota Denpasar', 'Kab. Sleman'
    ][OFFSET(MOD(h, 20))] AS destination_city,
    ['qris', 'qris', 'gopay', 'bank_transfer', 'cod'
    ][OFFSET(MOD(DIV(h, 23), 5))] AS payment_method,
    -- 6 to 95 hours, so month-end orders settle in the next month. Case C.
    6 + MOD(DIV(h, 17), 90) AS settlement_lag_hours,
    MOD(DIV(h, 1009), 100) AS bucket
  FROM base
)
SELECT
  * EXCEPT (bucket, settlement_lag_hours),
  CASE
    WHEN bucket < 55 THEN 'settlement'
    WHEN bucket < 60 THEN 'capture'
    WHEN bucket < 70 THEN 'cancel'       -- case A: still status_code 200
    WHEN bucket < 78 THEN 'refund'       -- case B
    WHEN bucket < 80 THEN 'chargeback'   -- case B
    WHEN bucket < 90 THEN 'pending'
    WHEN bucket < 96 THEN 'deny'
    ELSE 'expire'
  END AS transaction_status,
  CASE
    WHEN bucket < 80 THEN 200            -- also covers cancel and both reversals
    WHEN bucket < 90 THEN 201
    ELSE 202
  END AS status_code,
  CASE
    -- Case D: settled, returned, refund not issued yet. The payment still reads
    -- 'settlement', so only order_status drops these.
    WHEN bucket >= 50 AND bucket < 55 THEN 'returned'
    -- Reversed orders mostly stay 'completed': goods shipped, money came back later.
    WHEN bucket < 60 OR (bucket >= 74 AND bucket < 80) THEN 'completed'
    WHEN bucket < 70 THEN 'cancelled'
    WHEN bucket < 74 THEN 'returned'
    ELSE 'created'
  END AS order_status,
  -- Reversals settled first, so they keep a settlement timestamp.
  CASE
    WHEN bucket < 55 OR (bucket >= 70 AND bucket < 80)
      THEN TIMESTAMP_ADD(order_ts, INTERVAL settlement_lag_hours HOUR)
  END AS settlement_ts
FROM shaped;

INSERT marketplace.orders (order_id, order_ts, customer_id, gross_amount, order_status, destination_city)
SELECT order_id, order_ts, customer_id, gross_amount, order_status, destination_city
FROM gen;

INSERT marketplace.payments (payment_id, order_id, payment_method, status_code, transaction_status, settlement_ts)
SELECT payment_id, order_id, payment_method, status_code, transaction_status, settlement_ts
FROM gen;
