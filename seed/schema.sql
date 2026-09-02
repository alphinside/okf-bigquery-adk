-- Column descriptions stay structural on purpose: names, types, allowed values.
-- They never say which status means the money arrived, which timestamp cuts a
-- period, or which cities are Jabodetabek. That gap is what Act 2 fills.
--
-- No `region` column on `orders`, deliberately.

CREATE SCHEMA IF NOT EXISTS marketplace
OPTIONS (location = 'US');

CREATE OR REPLACE TABLE marketplace.orders (
  order_id         STRING    NOT NULL OPTIONS (description = "Unique order identifier."),
  order_ts         TIMESTAMP NOT NULL OPTIONS (description = "When the customer placed the order."),
  customer_id      STRING    NOT NULL OPTIONS (description = "Identifier of the customer who placed the order."),
  gross_amount     NUMERIC   NOT NULL OPTIONS (description = "Order total in IDR."),
  order_status     STRING    NOT NULL OPTIONS (description = "Order lifecycle status. One of: created, completed, cancelled, returned."),
  destination_city STRING    NOT NULL OPTIONS (description = "Shipping destination city or regency name, as captured at checkout.")
)
OPTIONS (description = "One row per customer order placed on the marketplace.");

CREATE OR REPLACE TABLE marketplace.payments (
  payment_id         STRING    NOT NULL OPTIONS (description = "Unique payment identifier."),
  order_id           STRING    NOT NULL OPTIONS (description = "Order this payment belongs to. Joins to orders.order_id."),
  payment_method     STRING    NOT NULL OPTIONS (description = "Payment method used. One of: qris, gopay, bank_transfer, cod."),
  status_code        INT64     NOT NULL OPTIONS (description = "Payment gateway API response code. One of: 200, 201, 202."),
  transaction_status STRING    NOT NULL OPTIONS (description = "Payment gateway transaction status. One of: authorize, capture, settlement, pending, deny, cancel, expire, refund, partial_refund, chargeback, partial_chargeback, failure."),
  settlement_ts      TIMESTAMP          OPTIONS (description = "When the gateway settled the payment. Null if the payment never settled.")
)
OPTIONS (description = "One row per payment recorded by the payment gateway, one payment per order.");
