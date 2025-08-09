# Poll

- Asociaciones: `belongs_to :publisher`, `has_many :poll_answers`, `has_many :poll_votes`.
- Validaciones: `publisher`, `question`, `end_date`, `days_or_date` (create), `duration`/`end_date_date` condicionales, número de respuestas.
- Callbacks: `set_end_date` (create), `notify_users` (create).
- Scopes: `most_recent`, `search_by`, `shared_public`.
- Constantes: `LIMIT_TYPE`, `MIN_NUMBER_ANSWERS`, `MAX_NUMBER_ANSWERS`, `PER_PAGE`, `DISTANCE_FOR_PUBLICS`.
- Métodos: `closed?`, `mark_as_read_for_sender`, métricas.
