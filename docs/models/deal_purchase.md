# DealPurchase

- Asociaciones: `user`, `deal`.
- Validaciones: `status` en `STATUS`, `price`, `quantity`, dirección si requiere envío, aceptación de términos.
- Callbacks: `set_status`, `process_payment` (Stripe), `notify_users` (venta/compra).
- Utilidades: `printable_id`, `batch_purchase`, `redeemed?`, `full_address`.
