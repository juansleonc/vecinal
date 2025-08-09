# Business

- Módulos: `Accountable`, `HasLogo`, `StripeCalls`, `Reviewable`, `Geocodeable`.
- Asociaciones: `owner` (`User`), `images`, `promotions`, `deals`, `coupons`, `comments`.
- Validaciones: `name`, `phone`, `namespace` (único/formato), `email`, `country/region/city/address`, aceptación legal.
- Callbacks: suscripción Stripe inicial.
- Scopes: `near_reference`.
- Planes: límites de cupones activos; API de Stripe; métricas de promos; pagos (compras).
