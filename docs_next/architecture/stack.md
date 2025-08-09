# Stack propuesto (2025)

- Backend: Ruby on Rails 7 API-only (REST), ActiveRecord (PostgreSQL), validación en modelos y constraints en DB; validación de requests contra OpenAPI (gems `openapi_first` o `committee`); contratos OpenAPI versionados.
- Frontend: React 18/Next.js 14 (App Router), TypeScript, TanStack Query, TailwindCSS, Shadcn/UI, i18next.
- Auth: Devise + devise-jwt (inicio); OIDC con Doorkeeper si aplica. Permisos con Pundit o CanCanCan; MFA/WebAuthn.
- Storage: PostgreSQL 15, Redis (cache/colas), S3 (assets), Meilisearch/Elastic (búsquedas), ClickHouse (analítica opcional).
- Jobs: Sidekiq + Redis; workflows opcionales (Temporal/GoodJob) donde aplique.
- Payments: Stripe Connect; alternativamente Adyen/PayPal si expansión.
- Emails/Comms: Postmark/Resend; inbound con Cloudflare Email Workers o Mailgun (webhooks).
- Observabilidad: OpenTelemetry (otlp-ruby) + Grafana (Tempo/Loki/Prometheus), Sentry.
- Infra: Docker, Kubernetes (GKE/EKS), Terraform, GitHub Actions, ArgoCD.
