# Entregables MVP

- Arquitectura inicial desplegada (API, frontend, DB, observabilidad) en `staging` y `prod`.
  - Hosting MVP: Vercel (frontend), Fly.io (API/Workers), Neon (Postgres), Upstash (Redis), Cloudflare R2 (assets), Sentry/Grafana.
  - Criterios de aceptación: dominios + SSL activos, despliegue automático por rama, rollback vía releases, backups diarios DB.
- Módulos:
  - Identity/Acceso (OIDC, roles, perfiles)
  - Social básico (mensajes + comentarios)
  - Amenities/Reservas (crear/cancelar + disponibilidad simple)
  - ServiceDesk (tickets básicos)
  - Documentos (folders + uploads)
- Dashboards/Alertas y runbooks mínimos.
  - KPIs: reservas/día, tickets abiertos/cerrados, mensajes enviados; SLOs API (P95/errores) con alertas en Grafana.
- QA: pruebas unit/integración; E2E críticos; performance smoke (k6).
- Seguridad: MFA admins, CSP, escaneo dependencias, secretos seguros.
