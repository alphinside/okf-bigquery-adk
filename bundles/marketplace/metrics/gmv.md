---
type: Metric
title: Gross Merchandise Value (GMV)
description: Total settled transaction value for a period in IDR, excluding cancellations, reversals and returns.
tags: [metrics, finance, headline-metric]
generated: { by: human:analytics-lead@marketplace.example, at: 2026-09-01T09:00:00+07:00 }
verified:
  - { by: human:analytics-lead@marketplace.example, at: 2026-09-01T11:00:00+07:00 }
stale_after: 2027-01-31T00:00:00+07:00
sources:
  - id: payments-table
    resource: tables/payments.md
    title: Payments
    author: reference_agent/gemini-flash-latest
    last_modified: 2026-09-01T08:01:31+00:00
---

# Definition

GMV for a period is `SUM(orders.gross_amount)`, in IDR, over `orders` joined to
`payments` on `order_id`. All four conditions below must hold. None of them comes
from the schema. A person decided each one.

1. **The payment settled.** `payments.transaction_status = 'settlement'`. This is
   the only value that means the funds reached the merchant account. Do not use
   `payments.status_code = 200` instead. That code also covers `cancel`, so it
   counts money that never arrived. [^payments-table]
2. **The order completed.** `orders.order_status = 'completed'`. A settled payment
   on a `returned` order is money that goes back to the customer. The refund has
   not gone out yet, so the payment still reads `settlement`.
3. **Reversals are out.** `payments.transaction_status NOT IN ('refund',
   'partial_refund', 'chargeback', 'partial_chargeback')`. Condition 1 already
   covers this here, because `transaction_status` holds the payment's current
   state and not its history. The rule is written down anyway, because a
   warehouse that logs reversals as separate rows still needs it.
4. **Cut the period on `payments.settlement_ts`, not `orders.order_ts`.**
   Settlement runs hours to several days behind the order. An order placed on the
   last day of a month can belong to the GMV of the next month. The two cuts give
   different answers, and `order_ts` is the wrong one.

Use a half-open interval with an explicit UTC offset:
`>= TIMESTAMP('2026-07-01 00:00:00+07') AND < TIMESTAMP('2026-08-01 00:00:00+07')`.
`BETWEEN '2026-07-01' AND '2026-07-31'` silently drops the last day and reads the
timestamps as UTC, moving every boundary by seven hours.

GMV is not net revenue, and not "turnover" as the sales team uses the word.
Neither of those excludes returns or reversals. GMV subtracts nothing for
discounts, shipping, or gateway fees.

# Reporting cuts

Breaking GMV down by `payments.payment_method`, by `orders.destination_city`, or
by a city group such as [Jabodetabek](../references/jabodetabek.md) is a view of
this metric, not a new metric. All four conditions stay in the `WHERE` clause.

# Trust and freshness

- **Verified:** analytics lead sign-off on 2026-09-01.
- **Stale after 2027-01-31:** the revenue recognition rules are reissued each
  January. Re-check this definition before serving GMV for a later period, and
  say so in the answer if it is stale.

[^payments-table]: Payments. This is the generated table document. It lists the
status values, but it does not say which value means that the money arrived.
