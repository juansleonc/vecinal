# CouponRedemption

- Asociaciones: `user`, `coupon`.
- Validaciones: `user_id`, `coupon_id`; `coupon_redeemable` (disponibilidad/ventanas).
- Callbacks: `update_coupons_number` (decrementa stock).
- Utilidades: `find_current_or_create`, `printable_id`, `batch_redeem`.
