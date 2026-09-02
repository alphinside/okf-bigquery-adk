---
type: BigQuery Table
resource: bq://alvin-exploratory-2/marketplace/orders
title: Orders
description: One row per customer order placed on the marketplace.
tags:
- orders
- transactions
- e-commerce
- marketplace
generated:
  by: reference_agent/gemini-flash-latest
  at: '2026-09-01T08:01:11+00:00'
sources:
- id: bigquery
  resource: bq://alvin-exploratory-2/marketplace/orders
  title: BigQuery Table Metadata
---

This table contains records of all customer orders placed on the marketplace. The grain of the table is one row per order, uniquely identified by `order_id`. It includes essential details such as the timestamp of the order, the customer who placed it, the total gross amount, and the current status in the order lifecycle. The data is part of the [marketplace](../datasets/marketplace.md) dataset and can be joined with the [payments](payments.md) table using the `order_id` field to reconstruct full transaction histories. The `order_ts` field indicates when the order was placed.

# Schema

| Field Name | Type | Description |
| :--- | :--- | :--- |
| `order_id` | STRING | Unique order identifier. |
| `order_ts` | TIMESTAMP | When the customer placed the order. |
| `customer_id` | STRING | Identifier of the customer who placed the order. |
| `gross_amount` | NUMERIC | Order total in IDR. |
| `order_status` | STRING | Order lifecycle status (created, completed, cancelled, returned). |
| `destination_city`| STRING | Shipping destination city or regency name, as captured at checkout. |

# Common query patterns

1.  **Calculate the total sales for completed orders:**

    ```sql
    SELECT
      DATE(order_ts) AS order_date,
      SUM(gross_amount) AS total_sales_idr
    FROM
      `alvin-exploratory-2.marketplace.orders`
    WHERE
      order_status = 'completed'
    GROUP BY 1
    ORDER BY 1 DESC
    ```

2.  **Find the distribution of order statuses:**

    ```sql
    SELECT
      order_status,
      COUNT(order_id) AS order_count
    FROM
      `alvin-exploratory-2.marketplace.orders`
    GROUP BY 1
    ORDER BY 2 DESC
    ```

3.  **Identify high-value customers by their order volume:**

    ```sql
    SELECT
      t1.customer_id,
      SUM(t1.gross_amount) AS total_spent,
      COUNT(t1.order_id) AS total_orders
    FROM
      `alvin-exploratory-2.marketplace.orders` AS t1
    GROUP BY 1
    ORDER BY 2 DESC
    LIMIT 10
    ```
