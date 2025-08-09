# Invite

- Asociaciones: `inviter` (`User`), `accountable` polimórfico.
- Validaciones: formato de email, ya miembro, `inviter_id`, `email`, `accountable_id/type`.
- Callbacks: `set_role` (valida pertenencia), `send_email`, `check_pendings`.
- Flujos: `accept_by_user(user)` actualiza usuario pendiente y limpia invitaciones.
- Búsqueda: `search_by`.
