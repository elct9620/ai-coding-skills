# Architecture

The shop has two contexts. Sales owns customers and orders. Shipping owns
recipients and shipments. Shipping learns about an order only from the
`Sales::OrderPlaced` event that Sales publishes when an order is placed.
