# Reservation

- Asociaciones: `belongs_to :amenity`, `:reserver` (`User`), `:responsible` (`User`), `has_many :comments`.
- Validaciones: presencia de `reserver`, `amenity`, `date`, `time_from`, `time_to`, `status` en `STATUSES`, `message`.
- Callbacks: `set_defaults`, `check_reservation_length`, `check_max_reservations_per_user`, `working_hours`, `check_auto_approve`, `validate_availability`, `set_responsible`, `notify_users`.
- Scopes: `collides_with`, `search_by`.
- Reglas de disponibilidad: tipo de `Amenity`, horarios del día (`Availability`), colisión temporal, longitud máxima, pasado vs ahora.
- Notificaciones: `UserMailer.new_reservation` a responsables y reservante según settings.
