# Branching and PR Workflow

- Branch per issue: `feature/<slug>`, `fix/<slug>`, `chore/<slug>`.
- Keep branches short-lived; rebase on latest `main` before PR.
- PRs use Conventional Commits in title and explain the WHY first.
- Require: passing CI, code owners review, ADR link if architecture change.
- Merge strategy: squash & merge. PR description becomes commit body.

Checklist for PRs
- [ ] Purpose (why?)
- [ ] Scope (what?)
- [ ] Tests added/updated
- [ ] Docs updated (`docs_next` where applies)
- [ ] Observability (logs/metrics/traces)
- [ ] Security (authz, inputs validated, secrets not leaked)
