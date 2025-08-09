# Roadmap - Vecinal

Fase 0: Fundaciones (2-3 semanas)
- Infra/base: monorepo, CI/CD, entornos, observabilidad, auth OIDC.
- Hosting MVP: Vercel (FE), Fly.io (API/Workers), Neon (DB), Upstash (Redis), Cloudflare R2 (assets), Sentry/Grafana.
- Entregables: despliegue base, pipelines, monitoreo inicial, cuentas/proyectos en proveedores y secretos configurados.

Fase 1: MVP Core (4-6 semanas)
- Social básico, Amenities/Reservas, ServiceDesk, Documentos.
- Infra: dominios, CDN, certificados, backups DB, alertas SLO en Grafana, Sentry release tracking.
- Entregables: módulos funcionales, E2E críticos, dashboards SLO, despliegues automatizados a prod con aprobación.

Fase 2: Mejores prácticas y UX (3-4 semanas)
- Búsquedas, i18n completa, accesibilidad, mejoras de permisos, moderación básica.
- Entregables: mejoras UX, accesibilidad AA, búsqueda simple.

Fase 3: Extensiones (4-6 semanas)
- Pagos/Promos, encuestas avanzadas, analytics, mobiles PWAs.
- Entregables: pagos Stripe Connect, cupones/deals, encuestas, KPIs negocio.

Fase 4: Ventas de Inmuebles (4-6 semanas)
- Listados de propiedades (crear/editar/publicar), filtros/búsqueda, leads y programación de visitas.
- Entregables: módulo de listings, formulario de interés, panel básico de leads y métricas.

Fase continua: Hardening y optimizaciones
- Seguridad, performance, costos, DX.
