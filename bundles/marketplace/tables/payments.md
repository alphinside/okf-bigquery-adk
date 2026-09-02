---
type: BigQuery Table
resource: bq://alvin-exploratory-2/marketplace/payments
title: Payments
description: One row per payment recorded by the payment gateway, one payment per
  order.
tags:
- payment
- transaction
- gateway
- finance
generated:
  by: reference_agent/gemini-flash-latest
  at: '2026-09-01T08:01:31+00:00'
sources:
- id: bq_table
  title: BigQuery Table Schema
  resource: bq://alvin-exploratory-2/marketplace/payments
---

The `payments` table records individual payment transactions processed through the marketplace's payment gateway. Each row represents a single payment attempt for an order, meaning the table grain is one payment per order. It is part of the [marketplace dataset](../datasets/marketplace.md) and provides crucial details about the payment method, the status of the transaction as reported by the gateway, and the timestamp of settlement. This data is essential for financial reconciliation and tracking order fulfillment status.

# Schema

The table contains 6 columns, providing identifiers, payment details, and status information.

| Field Name | Type | Description |
| :--- | :--- | :--- |
| `payment_id` | STRING (REQUIRED) | Unique payment identifier. |
| `order_id` | STRING (REQUIRED) | Order this payment belongs to. Joins to [`orders`](orders.md) using `order_id`. |
| `payment_method` | STRING (REQUIRED) | Payment method used. Supported methods include `qris`, `gopay`, `bank_transfer`, and `cod`. |
| `status_code` | INTEGER (REQUIRED) | Payment gateway API response code (e.g., `200`, `201`, `202`). |
| `transaction_status` | STRING (REQUIRED) | Payment gateway transaction status. Possible values include `settlement`, `pending`, `deny`, `cancel`, and `refund`. |
| `settlement_ts` | TIMESTAMP (NULLABLE) | When the gateway settled the payment. This field is null if the payment never settled. |

# Common query patterns

1. **Find all successful payments settled in the last 7 days:**
   ```sql
   SELECT
     payment_id,
     order_id,
     payment_method
   FROM
     `alvin-exploratory-2.marketplace.payments`
   WHERE
     transaction_status = 'settlement'
     AND settlement_ts >= TIMESTAMP_SUB(CURRENT_TIMESTAMP(), INTERVAL 7 DAY)
   ```

2. **Count the number of payments by method and current status:**
   ```sql
   SELECT
     payment_method,
     transaction_status,
     count(payment_id) as num_payments
   FROM
     `alvin-exploratory-2.marketplace.payments`
   GROUP BY 1, 2
   ORDER BY num_payments DESC
   ```

3. **Join payments data with the orders table to calculate the total value of cancelled transactions:**
   ```sql
   SELECT
     sum(t2.total_price) AS total_cancelled_value
   FROM
     `alvin-exploratory-2.marketplace.payments` AS t1
   INNER JOIN
     `alvin-exploratory-2.marketplace.orders` AS t2
     ON t1.order_id = t2.order_id
   WHERE
     t1.transaction_status = 'cancel'
   ```
