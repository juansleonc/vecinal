# Nuevo Proyecto: Guía de Arquitectura y Migración

Objetivo: modernizar Vecinal con tecnologías y prácticas actuales, manteniendo los dominios y flujos de negocio, mejorando calidad, seguridad, rendimiento y DX.

Decisiones actuales:
- Backend: Rails 7 API-only (REST con OpenAPI).
- Mobile: React Native (Expo) con TypeScript.
- Web: Next.js 14.
- GraphQL: opcional como BFF más adelante.

Índice:
- Visión y principios (`architecture/vision.md`)
- Stack propuesto (`architecture/stack.md`)
- Arquitectura (`architecture/architecture.md`)
- Seguridad y cumplimiento (`architecture/security.md`)
- Observabilidad (`architecture/observability.md`)
- Datos y almacenamiento (`architecture/data.md`)
- Frontend (`architecture/frontend.md`)
- API y BFF (`architecture/api_bff.md`)
- Background jobs y colas (`architecture/jobs.md`)
- Infraestructura y DevOps (`operations/infra_devops.md`)
- Estándares de código y calidad (`operations/quality.md`)
- Dominios (`domains/*.md`)
- Modelos/Esquemas (`models/*.md`)
- Servicios (`services/*.md`)
- Mailers/Notificaciones (`mailers/*.md`)
- ADRs (`adr/*.md`)
- Plan de migración (`operations/migration.md`)
