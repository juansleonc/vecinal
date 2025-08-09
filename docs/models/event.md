# Event

- Asociaciones: `events_users` (join), `users`, `images`, `comments`, `likes`.
- Validaciones: `title`, `date`, `time_from`, `time_to`.
- Callbacks: `notify_receivers` al guardar.
- Scopes: `with_user`, `by_month(date)`, `upcoming_and_past`, `upcoming`, `past`, `search_by`.
- Funciones: calendario expandiendo recurrencia; `upcoming?`; cuerpo de correo.
- Notificaciones: `UserMailer.new_event`.
