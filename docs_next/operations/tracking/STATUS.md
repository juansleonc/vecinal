# Delivery Tracker

Conventions
- Each issue -> one branch (`feature/<slug>`, `fix/<slug>`, `chore/<slug>`).
- PR title: Conventional Commits style.
- DONE means merged to `main` and deployed (or ready for deploy if batch releases).

Board
- Backlog → In Progress → Review → Done

Template
```
## [ISSUE-KEY] Title

- Branch: feature/<slug>
- PR: link
- Owner: @user
- Scope: <1-3 bullets>
- Acceptance Criteria: <bullets>
- Status: Backlog | In Progress | Review | Done
- Notes: <decisions, risks>
```

Log
- 2025-08-09: Initialized tracker.
\n+## Estado actual (2025-08-09)

- API `apps/api-next-ruby` actualizado a **Rails 8.0.2** y **Ruby 3.3.9**.
- Configurado CORS, endpoints de salud, manejo global de excepciones, logging JSON y RSpec.
- `apps/legacy-rails` permanece sin cambios funcionales.
- Intento de push a `juansleonc/vecinal.git` falló inicialmente por archivo >100MB y luego por detección de claves Stripe de prueba.
- Acciones realizadas: eliminación de `.git` anidado en `apps/api-next-ruby`, creación de `.gitignore` raíz, limpieza de `log/`, `tmp/` y `dump.rdb` del índice, amend del commit.
- Bloqueo actual: GitHub Push Protection detecta claves Stripe en `apps/legacy-rails/config/secrets.yml`.

## Próximos pasos

- [ ] Sustituir claves Stripe hardcodeadas en `apps/legacy-rails/config/secrets.yml` por variables de entorno/credentials.
- [ ] Rotar las claves en Stripe (test y, si aplica, live).
- [ ] Purgar historia para eliminar secretos expuestos (git filter-repo/BFG) si estuvieron alguna vez commiteados.
- [ ] Confirmar `.gitignore` para evitar reintroducción de secretos y artefactos.
- [ ] Reintentar push a `juansleonc/vecinal.git`.

Notas
- En curso: localización exacta de las claves en `apps/legacy-rails/config/secrets.yml` para su reemplazo.
