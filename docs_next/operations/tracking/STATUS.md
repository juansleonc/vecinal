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

## Estado actual (2025-08-09)

- API `apps/api-next-ruby` actualizado a **Rails 8.0.2** y **Ruby 3.3.9**.
- Configurado CORS, endpoints de salud, manejo global de excepciones, logging JSON y RSpec.
- `apps/legacy-rails` permanece sin cambios funcionales.
- Repositorio publicado en GitHub (`origin/main`) tras limpiar la historia y retirar secretos de `secrets.yml`.
- Gestión de claves: en pausa por decisión (cuentas obsoletas).

## Próximos pasos

- [ ] CI/CD: pruebas y linters para `apps/api-next-ruby` y `apps/legacy-rails` (incl. Brakeman, RuboCop).
- [ ] API Next: completar CRUD de `reservations` con persistencia (en progreso) y endpoints de `users`.
- [ ] Auth: JWT con RS256 y JWKS (listo), añadir tests extra y rotación programada de llaves.
- [ ] Legacy Rails: smoke tests de rutas críticas de pagos y reservas.
- [ ] Devex: refinar `docker-compose` para stack completo y comandos en `Makefile`.
- [ ] Documentación: mantener este tracker al día y completar `.env.example` (actualizado con JWT/envs).

Notas
- Gestión de claves se pospone hasta nuevo aviso.
