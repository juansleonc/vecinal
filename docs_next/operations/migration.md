# Plan de migración

- Fase 0: Inventario (completo en `docs/`), KPIs, riesgos, pilotos.
- Fase 1: Datos: esquemas ActiveRecord equivalentes, migraciones seguras (`strong_migrations`), verificación en staging; doble escritura/sincronización si coexistencia.
- Fase 2: Servicios: Identity/Access, Social, Bookings, ServiceDesk, Documents, Payments, Balances (por orden de impacto).
- Fase 3: Frontend Next: rutas por dominio; BFF/Proxy puente entre Rails legacy y API Rails nueva durante transición.
- Fase 4: Cortes y desactivación: feature flags, routing progresivo, DR.
- Fase 5: Post-mortem y hardening.
