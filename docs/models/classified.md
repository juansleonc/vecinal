# Classified

- Asociaciones: `belongs_to :publisher`, `has_many :comments`, `has_many :likes`.
- Validaciones: `title`, `description`, `publisher`.
- Scopes: `most_recent`, `search_by`, `shared_public`.
- Callbacks: `notify_users` (create).
