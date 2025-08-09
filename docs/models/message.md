# Message

- Asociaciones: `has_many :messages_users`, `has_many :users, through: :messages_users`, `has_many :comments`.
- Validaciones: `title`, `content` (si no hay adjuntos).
- Callbacks: `notify_receivers` al guardar.
- Scopes: `with_user(user)`, `not_destroyed_for(user)`, `marked(user, labels)`, `not_marked_as`, `unread(user)`, `inbox_for(user)`, `search_by`.
- Marcas: usa `Markable` para carpetas y estados (deleted/done/destroyed/email_read).
- Notificaciones: `UserMailer.new_message` a receptores con setting habilitado.
