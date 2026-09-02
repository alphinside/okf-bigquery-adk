# Benchmark questions

Ask these with `adk run agent`, once per bundle. Grounded is the correct answer,
and the agent must return it under `OKF_BUNDLE=bundles/marketplace`.

Naive is what a reasonable-looking wrong query returns: `status_code = 200` as
the success test, period cut on `order_ts`. It never raises a syntax error. That
is the whole problem.

Every query below runs as written. Paste one into
`bq --project_id=$PROJECT query --use_legacy_sql=false`, or run the whole file:

```bash
bq --project_id=$PROJECT query --use_legacy_sql=false < eval/ground_truth.sql
```

The seed is deterministic, so the figures are stable until you change it.

## Q1: the question the traces use

> What was total GMV for successful QRIS payments in Jabodetabek in July 2026?

| Query | GMV (IDR) | Orders |
|---|---|---|
| Grounded | 286,740,000 | 119 |
| Naive | 549,659,000 | 215 |

Naive is 92% high. A correct answer needs all four GMV conditions plus the
13-city Jabodetabek expansion.

```sql
-- grounded
SELECT SUM(o.gross_amount) AS gmv_idr, COUNT(DISTINCT o.order_id) AS orders
FROM marketplace.orders o
JOIN marketplace.payments p USING (order_id)
WHERE p.payment_method = 'qris'
  AND p.transaction_status = 'settlement'          -- not status_code = 200
  AND o.order_status = 'completed'                 -- drops returned but settled
  AND o.destination_city IN (
    'Kota Jakarta Pusat', 'Kota Jakarta Utara', 'Kota Jakarta Barat',
    'Kota Jakarta Selatan', 'Kota Jakarta Timur',
    'Kota Bogor', 'Kab. Bogor', 'Kota Depok',
    'Kota Tangerang', 'Kota Tangerang Selatan', 'Kab. Tangerang',
    'Kota Bekasi', 'Kab. Bekasi')
  AND p.settlement_ts >= TIMESTAMP('2026-07-01 00:00:00+07')   -- not order_ts
  AND p.settlement_ts <  TIMESTAMP('2026-08-01 00:00:00+07');  -- half-open
```

```sql
-- naive
SELECT SUM(o.gross_amount) AS gmv_idr, COUNT(DISTINCT o.order_id) AS orders
FROM marketplace.orders o
JOIN marketplace.payments p USING (order_id)
WHERE p.payment_method = 'qris'
  AND p.status_code = 200
  AND o.destination_city IN (
    'Kota Jakarta Pusat', 'Kota Jakarta Utara', 'Kota Jakarta Barat',
    'Kota Jakarta Selatan', 'Kota Jakarta Timur',
    'Kota Bogor', 'Kab. Bogor', 'Kota Depok',
    'Kota Tangerang', 'Kota Tangerang Selatan', 'Kab. Tangerang',
    'Kota Bekasi', 'Kab. Bekasi')
  AND o.order_ts >= TIMESTAMP('2026-07-01 00:00:00+07')
  AND o.order_ts <  TIMESTAMP('2026-08-01 00:00:00+07');
```

## Q2: no geography, so the metric definition carries it alone

> What was total GMV in July 2026?

| Query | GMV (IDR) | Orders |
|---|---|---|
| Grounded | 1,098,856,000 | 433 |
| Naive | 1,872,065,000 | 726 |

Same shape as Q1 without the city and `payment_method` filters. Use it to tell
whether a wrong answer came from the metric or the geography.

```sql
-- grounded
SELECT SUM(o.gross_amount) AS gmv_idr, COUNT(DISTINCT o.order_id) AS orders
FROM marketplace.orders o
JOIN marketplace.payments p USING (order_id)
WHERE p.transaction_status = 'settlement'
  AND o.order_status = 'completed'
  AND p.settlement_ts >= TIMESTAMP('2026-07-01 00:00:00+07')
  AND p.settlement_ts <  TIMESTAMP('2026-08-01 00:00:00+07');
```

```sql
-- naive
SELECT SUM(o.gross_amount) AS gmv_idr, COUNT(DISTINCT o.order_id) AS orders
FROM marketplace.orders o
JOIN marketplace.payments p USING (order_id)
WHERE p.status_code = 200
  AND o.order_ts >= TIMESTAMP('2026-07-01 00:00:00+07')
  AND o.order_ts <  TIMESTAMP('2026-08-01 00:00:00+07');
```

## Q3: the period cut on its own

> How much July 2026 GMV came from orders that were placed in June?

| Query | Value (IDR) | Orders |
|---|---|---|
| Grounded | 53,565,000 | 21 |

Answerable only if the agent knows the period cuts on `settlement_ts`. Cutting
on `order_ts` returns zero by construction, and the agent usually reports that as
"no such orders" rather than as a contradiction.

```sql
-- grounded
SELECT SUM(o.gross_amount) AS gmv_idr, COUNT(DISTINCT o.order_id) AS orders
FROM marketplace.orders o
JOIN marketplace.payments p USING (order_id)
WHERE p.transaction_status = 'settlement'
  AND o.order_status = 'completed'
  AND p.settlement_ts >= TIMESTAMP('2026-07-01 00:00:00+07')
  AND p.settlement_ts <  TIMESTAMP('2026-08-01 00:00:00+07')
  AND o.order_ts     <  TIMESTAMP('2026-07-01 00:00:00+07');
```

## How the answers differ by configuration

Recorded 2026-09-01, `gemini-3.7-flash`, `google-adk` 2.8.0. Traces in
[`../assets/`](../assets/).

| Configuration | Q1 answer | Error | What it got right | What it got wrong |
|---|---|---|---|---|
| No OKF (empty bundle directory) | IDR 371,251,000 | 29% high | the 13 Jabodetabek cities, and correct `+07` boundaries | counted `capture` as paid, cut on `order_ts`, no `order_status` filter |
| `bundles/generated` | IDR 329,590,000 | 15% high | `transaction_status = 'settlement'`, and the 13 cities | cut on `order_ts`, no `order_status` filter, bare date strings read as UTC |
| `bundles/marketplace` | IDR 286,740,000 | none | everything, and it named `metrics/gmv.md` and `references/jabodetabek.md` | — |

For the first row, point `OKF_BUNDLE` at any empty directory. `read_okf_concept`
then fails on every call and the agent falls back to the schema.

## Stability across runs

Q1, four times per configuration, same model and data.

| Configuration | Headline figures seen | Offered a second figure? |
|---|---|---|
| No OKF | 371,251,000 · 333,020,000 · 371,886,000 · 371,251,000 | no |
| `bundles/generated` | 329,590,000 in all four runs | yes, 2 runs of 4 also gave 328,612,000 |
| `bundles/marketplace` | 286,740,000 in all four runs | no |

Two different failures. With no knowledge layer the agent is unstable: four
identical questions, three different headline numbers. With the generated bundle
it is stable but uncertain, holding one figure and offering a second, because no
file decides which timestamp cuts the period. Only the hand-written concepts
remove the question.

An observation, not a benchmark. One question, one model, four runs each.
