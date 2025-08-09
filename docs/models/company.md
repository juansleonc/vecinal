# Company

- Módulos: `Accountable`, `HasLogo`, `StripeCalls`, `Folderable`, `Reviewable`, `Geocodeable`, `Settingable*`.
- Asociaciones: `buildings`, `apartments` (through), `images`, `comments`, `users` (through buildings), `amenities` (through).
- Validaciones: `owner`, `name`, `namespace` (formato/único), `email`, `country/region/city/address`, aceptación legal.
- Callbacks: suscripción Stripe inicial, email de creación.
- Scopes: `search_by`.
- Lógica de planes: máximos de edificios por plan, validación de upgrade/downgrade; enlaces; reservas agregadas.
