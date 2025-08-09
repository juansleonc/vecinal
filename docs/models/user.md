# User

- Devise: autenticación, confirmable, omniauth (Facebook/LinkedIn/Google).
- Roles: `administrator`, `resident`, `board_member`, `tenant`, `agent`, `collaborator` (y `supplier` vía `Business`).
- Asociaciones: `accountable` polimórfico, `contact_details`, `events` (join), `messages` (join), `reservations`, `images`, `comments`, `payments`, `account_balances`, `user_balances`.
- Validaciones: `first_name`, `last_name`, `role` en `ROLES`, `locale` en `CM_LOCALES`; `accountable_exists`.
- Callbacks: seteo de accountable/rol, invitaciones pendientes, detalles, emails.
- Scopes/Búsqueda: `search_by` (nombre/email/apto), `by`, `find_by_apartments`.
- Métodos clave: `member?`, chequeos por rol, `leave_community`, `shared_with_me`, settings de visibilidad/acción, export CSV.
