# Pagos y promociones

Pagos:
- `PaymentAccount`: cuenta por `Building`, estados (`STATUSES`), validaciones según país, habilitación de pagos. `payments_enabled?` en `Building`.
- `Payment`: transacciones asociadas a `PaymentAccount`/`Building`, búsquedas y métricas.

Promociones:
- `Business`: proveedor con suscripción Stripe (`sup_*`), límites de cupones activos, métricas, distancia geográfica.
- `Deal`/`Coupon`: promociones con precios, descuentos, top/highlight, métricas y reportes. Relaciones con `DealPurchase`/`CouponRedemption`.
- `DealPurchase`: compra con cargo Stripe y estados; notifica compra/venta.
- `CouponRedemption`: canje con validación de disponibilidad/ventanas.
