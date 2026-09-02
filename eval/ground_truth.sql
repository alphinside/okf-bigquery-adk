-- Every figure quoted in eval/questions.md, in one table.
--   bq --project_id=$PROJECT query --use_legacy_sql=false < eval/ground_truth.sql
--
-- Grounded rows apply the GMV definition from bundles/marketplace/metrics/gmv.md.
-- Naive rows use status_code = 200 and cut the period on order_ts, which is the
-- wrong answer an agent reaches without those concepts.

WITH jabodetabek AS (
  SELECT [
    'Kota Jakarta Pusat', 'Kota Jakarta Utara', 'Kota Jakarta Barat',
    'Kota Jakarta Selatan', 'Kota Jakarta Timur',
    'Kota Bogor', 'Kab. Bogor', 'Kota Depok',
    'Kota Tangerang', 'Kota Tangerang Selatan', 'Kab. Tangerang',
    'Kota Bekasi', 'Kab. Bekasi'
  ] AS cities
),
joined AS (
  SELECT
    o.order_id, o.gross_amount, o.order_ts, o.order_status, o.destination_city,
    p.payment_method, p.status_code, p.transaction_status, p.settlement_ts
  FROM marketplace.orders o
  JOIN marketplace.payments p USING (order_id)
),
july_settled AS (          -- the four GMV conditions, period cut on settlement_ts
  SELECT * FROM joined
  WHERE transaction_status = 'settlement'
    AND order_status = 'completed'
    AND settlement_ts >= TIMESTAMP('2026-07-01 00:00:00+07')
    AND settlement_ts <  TIMESTAMP('2026-08-01 00:00:00+07')
),
july_naive AS (            -- status_code = 200, period cut on order_ts
  SELECT * FROM joined
  WHERE status_code = 200
    AND order_ts >= TIMESTAMP('2026-07-01 00:00:00+07')
    AND order_ts <  TIMESTAMP('2026-08-01 00:00:00+07')
)

SELECT 'Q1 grounded' AS figure, SUM(gross_amount) AS gmv_idr, COUNT(DISTINCT order_id) AS orders
FROM july_settled, jabodetabek
WHERE payment_method = 'qris' AND destination_city IN UNNEST(jabodetabek.cities)

UNION ALL
SELECT 'Q1 naive', SUM(gross_amount), COUNT(DISTINCT order_id)
FROM july_naive, jabodetabek
WHERE payment_method = 'qris' AND destination_city IN UNNEST(jabodetabek.cities)

UNION ALL
SELECT 'Q2 grounded', SUM(gross_amount), COUNT(DISTINCT order_id) FROM july_settled

UNION ALL
SELECT 'Q2 naive', SUM(gross_amount), COUNT(DISTINCT order_id) FROM july_naive

UNION ALL
SELECT 'Q3 grounded', SUM(gross_amount), COUNT(DISTINCT order_id)
FROM july_settled
WHERE order_ts < TIMESTAMP('2026-07-01 00:00:00+07')

ORDER BY figure;
