# EPIC-003 Amenities y Reservas (P0)

## Issues

1) Motor de disponibilidad simple
- Descripción: Reglas por día y franja; intervalos; colisión básica.
- Prioridad: P0
- Criterios: creación rechaza colisiones; tests concurrentes

2) CRUD de amenities
- Descripción: Crear/editar/eliminar con imágenes y parámetros.
- Prioridad: P0
- Criterios: validaciones Zod/DB

3) Crear/cancelar reservas
- Descripción: Endpoints POST/DELETE; estados pending/approved/cancelled (auto aprobación opcional).
- Prioridad: P0
- Criterios: E2E creación/cancelación

4) Calendario y listados
- Descripción: Endpoints para listar por rango y calendario mensual.
- Prioridad: P1
- Criterios: P95 < 300ms

5) Notificaciones y emails
- Descripción: Correo/push en creación/cambio de estado.
- Prioridad: P1
- Criterios: plantillas listas
