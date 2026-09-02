---
type: Reference
title: Jabodetabek
description: The Jakarta metropolitan area, expressed as the exact destination_city values that belong to it.
tags: [geography, region, indonesia]
generated: { by: human:analytics-lead@marketplace.example, at: 2026-09-01T09:00:00+07:00 }
verified:
  - { by: human:analytics-lead@marketplace.example, at: 2026-09-01T11:00:00+07:00 }
stale_after: 2027-09-01T00:00:00+07:00
---

# Definition

**Jabodetabek** is the Jakarta metropolitan area: **Ja**karta, **Bo**gor,
**De**pok, **Ta**ngerang, **Be**kasi. Each covers the city (`Kota`) and, where
one exists, the regency around it (`Kab.`).

There is no `region` column in the warehouse. Jabodetabek exists only in this
document, so a regional filter must expand into a list of
`orders.destination_city` values.

# Member cities

These are the exact strings stored in `orders.destination_city`. Match them
literally. The values are not normalized. `Kota` and `Kab.` are two different
places, not two spellings of one.

| `destination_city` | Part of |
| :--- | :--- |
| `Kota Jakarta Pusat` | Jakarta |
| `Kota Jakarta Utara` | Jakarta |
| `Kota Jakarta Barat` | Jakarta |
| `Kota Jakarta Selatan` | Jakarta |
| `Kota Jakarta Timur` | Jakarta |
| `Kota Bogor` | Bogor |
| `Kab. Bogor` | Bogor |
| `Kota Depok` | Depok |
| `Kota Tangerang` | Tangerang |
| `Kota Tangerang Selatan` | Tangerang |
| `Kab. Tangerang` | Tangerang |
| `Kota Bekasi` | Bekasi |
| `Kab. Bekasi` | Bekasi |

Every other value of `destination_city` is outside Jabodetabek. `Kota Bandung`
is the one most often assumed to be inside it. It is not. Bandung is in West Java,
about 150 km away.

# Common query patterns

```sql
SELECT SUM(o.gross_amount) AS gmv_idr
FROM `PROJECT_ID.marketplace.orders` o
JOIN `PROJECT_ID.marketplace.payments` p USING (order_id)
WHERE o.destination_city IN (
    'Kota Jakarta Pusat', 'Kota Jakarta Utara', 'Kota Jakarta Barat',
    'Kota Jakarta Selatan', 'Kota Jakarta Timur',
    'Kota Bogor', 'Kab. Bogor', 'Kota Depok',
    'Kota Tangerang', 'Kota Tangerang Selatan', 'Kab. Tangerang',
    'Kota Bekasi', 'Kab. Bekasi'
  )
  AND p.transaction_status = 'settlement'
  AND o.order_status = 'completed'
```

Do not filter with `LIKE '%Jakarta%'`. It returns the five Jakarta
municipalities and drops the other eight members, about half the region's
volume. See [GMV](../metrics/gmv.md) for the rest of the conditions this query
needs.

# Trust and freshness

- **Verified:** analytics lead sign-off on 2026-09-01.
- **Stale after 2027-09-01:** administrative boundaries and city names change
  rarely, but they do change. Re-check this list against the values actually in
  `orders.destination_city` before serving regional cuts after that date.
