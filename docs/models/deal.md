# Deal

- Hereda de `Promotion`.
- Asociaciones: `has_many :purchases` (`DealPurchase`).
- Validaciones: `price`, `discount`, `highlight_days`, `top_days`.
- Callbacks: `validate_purchases_related` en destroy.
- Cálculos: `payable_price`, `saving`, métricas (`acquisitions`, `redeemed`, `revenue`, `customers`).
- Cercanía: `near_by_business`.
