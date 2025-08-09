# Building

- Asociaciones: `belongs_to :company`, `has_many :images`, `apartments`, `comments`, `users` (como `accountable`), `amenities`, `polls`, `classifieds`, `payment_account`/`payments`.
- Validaciones: `name`, `subdomain` (formato/único/exclusiones), `country/region/city/address`.
- Callbacks: `set_code`, `set_country_code`, `set_admin_default_requests`, email de creación.
- Scopes: `payments_enabled`, `search_by`.
- Utilidades: direcciones, imágenes, noticias, pagos, admins relacionados, admin/reservations por defecto, enlaces públicos.
