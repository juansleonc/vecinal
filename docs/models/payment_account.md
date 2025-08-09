# PaymentAccount

- Asociaciones: `belongs_to :building`, `has_many :payments`.
- Validaciones: datos bancarios por país (`CO/CA/US`), `status` en `STATUSES`, `enable_payments` boolean, claves obligatorias en update.
- Callbacks: `set_status` por defecto.
- Métodos: `payment_fee`, `enabled?`.
