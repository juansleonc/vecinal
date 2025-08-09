# Amenity

- Asociaciones: `belongs_to :building`; `has_many :images`, `:availabilities`.
- Validaciones: presencia de `building`, `name`, `description`, `availability_type` en `AVAILABILITY_TYPES`, numéricas para valores y longitudes.
- Callbacks: `set_defaults` (create), `create_availabilities` (post-create), `check_max_reservation_length`.
- Scopes: `ordered`, `availability`, `search_by`, `beetwen`.
- Constantes: `AVAILABILITY_TYPES`, `INTERVAL`, `DEFAULT_TIME_FROM`, `DEFAULT_TIME_TO`, `MAX_*`.
- Métodos: `availability_hours`, `mylogo`, utilidades de conteo.
