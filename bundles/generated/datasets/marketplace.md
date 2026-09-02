---
type: BigQuery Dataset
resource: https://bigquery.googleapis.com/v2/projects/alvin-exploratory-2/datasets/marketplace
title: Marketplace Dataset
description: Contains tables related to marketplace activity, including orders and
  payments.
tags:
- marketplace
- orders
- payments
- e-commerce
generated:
  by: reference_agent/gemini-flash-latest
  at: '2026-09-01T08:00:52+00:00'
sources:
- id: bigquery-dataset
  resource: https://bigquery.googleapis.com/v2/projects/alvin-exploratory-2/datasets/marketplace
  title: BigQuery Dataset marketplace metadata
---

The `marketplace` dataset is part of the `alvin-exploratory-2` BigQuery project and serves as the central repository for e-commerce transaction data. It hosts key tables that track customer orders and the associated payment processing. This dataset is physically located in the `US` multi-region[^bigquery-dataset].

The primary tables within this dataset are:

*   The [`orders`](tables/orders.md) table, which captures details about each customer order.
*   The [`payments`](tables/payments.md) table, which links order IDs to payment transaction records.

# Schema

As a BigQuery Dataset, the schema is defined by the tables it contains.

| Table Name | Description |
| :--- | :--- |
| [`orders`](tables/orders.md) | Details of customer orders. |
| [`payments`](tables/payments.md) | Records of payment transactions. |

# Common query patterns

```sql
-- Count the total number of orders in the dataset.
SELECT
    count(distinct order_id)
FROM
    `alvin-exploratory-2.marketplace.orders`;
```

```sql
-- Join orders and payments to find the amount of a specific order.
SELECT
    t1.order_id,
    t2.amount
FROM
    `alvin-exploratory-2.marketplace.orders` AS t1
JOIN
    `alvin-exploratory-2.marketplace.payments` AS t2 ON t1.order_id = t2.order_id
WHERE
    t1.order_date >= '2026-01-01';
```

[^bigquery-dataset]: BigQuery Dataset marketplace metadata
