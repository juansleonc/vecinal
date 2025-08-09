# Amenities y reservas

- `Amenity`: configuración de disponibilidad (`AVAILABILITY_TYPES`, `Availability`), longitud de reserva, límites por usuario, auto-aprobación, imágenes.
- `Reservation`: reservas con validaciones de disponibilidad, colisiones, horarios, longitud y máximo por usuario; estados (`STATUSES`) y notificaciones.
- `Availability`: regla de horario por día de la semana, validada y ordenada.

Casos de uso:
- Crear amenidad: define tipo de disponibilidad, intervalos, límites y auto-aprobación; genera `Availability` por defecto.
- Reservar amenidad: verifica disponibilidad y colisión; si `auto_approval`, se aprueba automáticamente; notifica a responsable y reservante.
- Cambiar responsable/estado: rutas dedicadas y correos.
