# API Governance

- Estilo REST: recursos en plural, `snake_case` en DB y `camelCase` en API.
- Versionado: `/v1`; compatibilidad hacia atrás; deprecación con headers `Sunset` y `Deprecation`.
- Paginación: cursor-based (`?cursor=...&limit=`), metadatos `{ nextCursor }`.
- Filtrado/orden: `?filter[field]=...&sort=field:asc`.
- Errores: formato uniforme `{ code, message, details, traceId }` + RFC7807 opcional.
- Idempotencia: header `Idempotency-Key` en POST/PUT con almacenamiento Redis.
- Seguridad: OAuth2/OIDC, scopes por recurso, rate limiting por actor, HSTS/CORS mínimos.
- Observabilidad: `traceparent` propagado; `X-Request-Id`.
