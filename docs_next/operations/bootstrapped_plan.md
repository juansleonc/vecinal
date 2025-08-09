# Plan Bootstrapped (sin clientes)

Objetivo: lanzar MVP en producción con costos mínimos y foco en validación.

Infra mínima (free/low cost):
- Frontend: Vercel Hobby (si cabe) o Pro 1 seat.
- API/Workers: Fly.io free tier (1-2 VMs pequeñas) o Railway free.
- DB: Neon free tier (o Supabase free como alternativa).
- Redis: Upstash free.
- Storage: Cloudflare R2 + free egress a Cloudflare, o S3 con free tier.
- Observabilidad: Sentry/Grafana Cloud free.
- Email: Resend/Postmark free tier.

Prácticas para bajo costo:
- Auto‑scale a 0 donde posible (Cloud Run/Railway) o instancias únicas.
- Horarios de apagado de entornos de staging.
- Logs/métricas con retención mínima.

Despliegue y DX:
- 1 ambiente productivo y 1 staging limitado.
- Previews sólo en PRs críticos.

Hitos de validación:
- 10 comunidades registradas, 50 usuarios activos, 20 reservas y 10 tickets por semana.
- Feedback cualitativo de admins y residentes.

Escalamiento posterior: migrar a plan de presupuesto estándar en `infra_budget.md` cuando se alcancen los umbrales de uso.
