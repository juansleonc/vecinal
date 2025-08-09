# Comment

- Asociaciones: `belongs_to :user`/`publisher`, `belongs_to :commentable, polymorphic`, `has_many :comments` (replies), `has_many :likes`.
- Validaciones: `content` (si no hay adjuntos), `commentable_id`, `user_id`.
- Callbacks: `fire_events`, `notify_user`, `mark_as_personal` (si no puede postear en comunidad).
- Scopes: `search_by`, `by_shared`, `shared_public`, `by`, `by_adaptive`, `beetwen`, `marked_as_personal`, `not_personal`.
- Lógica: marca como leído en timelines; notifica a actores relevantes; tamaño de columna de adjuntos.
