# Coupon

- Hereda de `Promotion`.
- Asociaciones: `has_many :redemptions` (`CouponRedemption`).
- Validaciones: `highlight_days`, `top_days`; `can_create_coupon?`/`can_update_coupon?` por plan y expiración.
- Scopes: `unexpired`.
- Métricas/reportes: `acquisitions`, `redeemed`, `customers`, `report`.
