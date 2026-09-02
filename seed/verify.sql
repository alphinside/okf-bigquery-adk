-- Run after seed_data.sql. Every row must read PASS.
--
-- Lose one of these cases and the naive query starts agreeing with the correct
-- one. The demo breaks silently, with no error. This is the only guard.

WITH jabodetabek AS (
  SELECT [
    'Kota Jakarta Pusat', 'Kota Jakarta Utara', 'Kota Jakarta Barat',
    'Kota Jakarta Selatan', 'Kota Jakarta Timur',
    'Kota Bogor', 'Kab. Bogor', 'Kota Depok',
    'Kota Tangerang', 'Kota Tangerang Selatan', 'Kab. Tangerang',
    'Kota Bekasi', 'Kab. Bekasi'
  ] AS cities
),
naive AS (
  SELECT SUM(o.gross_amount) AS gmv, COUNT(DISTINCT o.order_id) AS orders
  FROM marketplace.orders o
  JOIN marketplace.payments p USING (order_id), jabodetabek
  WHERE p.payment_method = 'qris'
    AND p.status_code = 200
    AND o.destination_city IN UNNEST(jabodetabek.cities)
    AND o.order_ts >= TIMESTAMP('2026-07-01 00:00:00+07')
    AND o.order_ts <  TIMESTAMP('2026-08-01 00:00:00+07')
),
grounded AS (
  SELECT SUM(o.gross_amount) AS gmv, COUNT(DISTINCT o.order_id) AS orders
  FROM marketplace.orders o
  JOIN marketplace.payments p USING (order_id), jabodetabek
  WHERE p.payment_method = 'qris'
    AND p.transaction_status = 'settlement'
    AND o.order_status = 'completed'
    AND o.destination_city IN UNNEST(jabodetabek.cities)
    AND p.settlement_ts >= TIMESTAMP('2026-07-01 00:00:00+07')
    AND p.settlement_ts <  TIMESTAMP('2026-08-01 00:00:00+07')
),
checks AS (
  SELECT 'orders and payments both loaded' AS check_name,
         (SELECT COUNT(*) FROM marketplace.orders) = 2000
     AND (SELECT COUNT(*) FROM marketplace.payments) = 2000 AS ok
  UNION ALL
  SELECT 'case A: status_code 200 but cancelled',
         (SELECT COUNT(*) FROM marketplace.payments
          WHERE status_code = 200 AND transaction_status = 'cancel') > 50
  UNION ALL
  SELECT 'case B: reversed but order still completed',
         (SELECT COUNT(*) FROM marketplace.payments p
          JOIN marketplace.orders o USING (order_id)
          WHERE p.transaction_status IN ('refund', 'chargeback')
            AND o.order_status = 'completed') > 50
  UNION ALL
  SELECT 'case C: settled in a different month than ordered',
         (SELECT COUNT(*) FROM marketplace.payments p
          JOIN marketplace.orders o USING (order_id)
          WHERE FORMAT_TIMESTAMP('%Y-%m', p.settlement_ts, '+07')
             != FORMAT_TIMESTAMP('%Y-%m', o.order_ts, '+07')) > 50
  UNION ALL
  SELECT 'case D: settled payment on an order that was returned',
         (SELECT COUNT(*) FROM marketplace.payments p
          JOIN marketplace.orders o USING (order_id)
          WHERE p.transaction_status = 'settlement'
            AND o.order_status = 'returned') > 50
  UNION ALL
  SELECT 'naive answer overstates grounded answer by at least 25%',
         (SELECT gmv FROM naive) > (SELECT gmv FROM grounded) * 1.25
)
SELECT check_name, IF(ok, 'PASS', 'FAIL') AS result FROM checks;
