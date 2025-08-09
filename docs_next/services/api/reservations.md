# Módulo API (Rails): Reservations

- Domain service: valida disponibilidad (reglas de `Amenity`), colisiones y límites por usuario/periodo.
- Repositorio (ActiveRecord): índices por amenity_id+date; transacciones para setear responsable y notificar.
- Controlador Rails: endpoints conforme OpenAPI; autenticación (Devise/JWT); políticas con Pundit/CanCanCan.
- Eventos: `ReservationCreated`, `ReservationUpdated` -> handlers de email/push (queue).
- Tests: unit (servicio), integración (repos/controller), contrato (OpenAPI), performance (k6) para creación concurrente (colisiones).
