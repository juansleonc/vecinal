# Checklist de readiness (lanzamiento MVP)

Funcional
- Flujo de registro/invitaciones/login validado
- Social básico, reservas y tickets con E2E verdes
- Documentos: subir/descargar probado

Calidad
- Lint/format sin errores; cobertura unit/integración >= 80%
- E2E críticos verdes en staging; performance smoke (k6) OK

Observabilidad
- Dashboards API y negocio; alertas SLO configuradas
- Sentry integrado con releases y sourcemaps

Infra
- Dominios y SSL activos; CD automatizado con rollback
- Backups DB diarios; restauración probada
- CDN/cache configurados; políticas de retención en logs

Seguridad
- Checklist de seguridad mínima cumplida
- Usuarios admin con MFA; secretos rotados

Operación
- Runbooks publicados; on‑call calendario definido (si aplica)
