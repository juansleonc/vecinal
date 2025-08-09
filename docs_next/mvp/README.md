# MVP - Vecinal

Objetivo: validar valor principal para comunidades y residentes con una versión mínima usable, segura y observable.

- Problema a resolver: comunicación efectiva, reservas de amenities y tickets de servicio en un solo lugar.
- Usuarios/claves: administrador de compañía, residentes (edificio), colaboradores.

Alcance MVP (v1):
- Identidad/Acceso: login OIDC, registro por invitación, roles básicos (admin, resident), perfil y settings de privacidad básicos.
- Social básico: mensajes 1:N con inbox trivial, comentarios en timeline de comunidad.
- Amenities/Reservas: CRUD de amenities, disponibilidad simple, creación/cancelación de reservas (auto-aprobación opcional).
- ServiceDesk: crear/cerrar tickets, asignación simple, comentarios.
- Documentos: folders raíz y subida/descarga de adjuntos.
- Observabilidad: logs/trazas, métricas RED, dashboard básico; alertas SLO.
- Infra: CI/CD, entornos dev/stg/prod, backups y monitoreo.

No objetivos (v1):
- Pagos/Promos, encuestas avanzadas, búsqueda fulltext, moderación automática, workflows complejos.

Métricas de éxito:
- Adopción (usuarios activos/semana), N reservas/semana, N tickets/semana, tiempo medio de resolución (MTTR tickets), P95 API < 300ms.
