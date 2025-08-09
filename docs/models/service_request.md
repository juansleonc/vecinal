# ServiceRequest

- Asociaciones: `belongs_to :user` (publisher), `belongs_to :responsible, polymorphic`, `has_many :comments`.
- Constantes: `CATEGORIES`, `STATUSES`, `REPORT_TYPE`.
- Validaciones: `user_id`, `title`, `content` (si no hay adjuntos), inclusión de `category`/`status`.
- Callbacks: `set_status`, `set_responsible`, `notify_receivers`.
- Scopes: `open`, `closed`, `search_by`, métricas (`open_count`, `closed_count`, `beetwen`).
- Exportación: `to_csv` con columnas predefinidas.
- Métodos: `classy_id`, traducciones de `category`/`status`, helpers de responsable.
- Notificaciones: `UserMailer.new_service_request` y cambio de responsable.
