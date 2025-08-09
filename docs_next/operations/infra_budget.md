# Presupuesto de Infraestructura y decisión de hosting

Este documento estima costos mensuales para el MVP y crecimiento, y propone el stack de hosting recomendado.

## Supuestos de carga (MVP)
- 5 comunidades activas, 500 usuarios totales, 100 DAU
- Tráfico API: ~30 rps pico, promedio 3 rps
- Almacenamiento: 50 GB en media (imágenes/adjuntos), 5 GB DB
- Correos: 5k/mes
- Logs/trazas: 5 GB/mes

## Criterios de decisión
- Coste y simplicidad operativa para MVP
- Escalabilidad progresiva sin rediseños grandes
- Latencia razonable en región Américas
- Observabilidad y seguridad integrables con bajo esfuerzo

## Opciones comparadas (estimaciones mensuales)

1) AWS (ECS/Fargate ó EC2 + RDS + ElastiCache + S3 + CloudFront)
- API (2×t3.small ó Fargate 0.5vCPU/1GB): $35–$60
- RDS Postgres (db.t4g.small + 20GB): $35–$55
- ElastiCache Redis (t4g.micro): $15–$25
- S3 (50GB) + CloudFront (bajo tráfico): $10–$20
- ALB + NAT + datos + CloudWatch: $40–$80
- Email (Postmark/Resend externo): $20
- Total: ~$155–$260/mes (riesgo de costos ocultos: NAT/egress)

2) GCP (Cloud Run + Cloud SQL + Memorystore + GCS + CDN)
- Cloud Run (pico bajo, 2 instancias): $20–$40
- Cloud SQL Postgres (db-f1-micro/small + 20GB): $25–$60
- Memorystore Redis basic: $30–$40
- GCS + CDN: $10–$20
- Logging/Monitoring: $10–$20
- Email (Postmark/Resend): $20
- Total: ~$115–$200/mes

3) Vercel (Frontend) + Fly.io (API/Workers) + Neon (Postgres) + Upstash (Redis) + Cloudflare R2 (assets)
- Vercel Pro (1 seat): $20
- Fly.io API (2×shared-cpu-1x, 512MB): $15–$25
- Fly Postgres o Neon serverless (starter): $0–$29 (asumir $29)
- Upstash Redis (starter): $0–$10 (asumir $7)
- Cloudflare R2 + CDN (50GB): $5–$10
- Sentry/Grafana Cloud (free tier / $0–$20)
- Email (Resend/Postmark): $20
- Total: ~$96–$131/mes

4) Azure (App Service + Flexible Server + Cache + Blob)
- Comparable a AWS/GCP: ~$130–$220/mes en MVP

Notas:
- Precios estimados a 2025, sin descuentos por reserva ni free tiers promocionales.
- Egresos de datos y NAT pueden elevar costo en nubes hyperscaler.

## Recomendación
Para MVP priorizamos coste/DX: Vercel + Fly.io + Neon + Upstash + R2.

- Frontend: Vercel Pro (App Router, edge cache)
- API/Workers: Fly.io (multi-región opcional, simple autoscaling)
- DB: Neon (serverless Postgres, branching para previews) o Fly Postgres si se prefiere colocalización
- Cache/Queues: Upstash Redis (serverless)
- Storage/CDN: Cloudflare R2 + CDN
- Observabilidad: Sentry (app), Grafana Cloud (prom+tempo+loki free tier)
- Email: Resend/Postmark

Rango de presupuesto MVP: **$100–$140/mes**

## Escalamiento a producción intensiva (12–18 meses)
- Migrar API a AWS ECS/Fargate o GCP Cloud Run si el tráfico y la gobernanza lo justifican
- Postgres administrado (RDS/Cloud SQL) con réplicas y backups gestionados
- Redis administrado (ElastiCache/Memorystore)
- CDN dedicado (CloudFront/Cloud CDN) y WAF
- Presupuesto previsto: **$350–$800/mes** según tráfico y SLAs

## Plan de costes por entorno
- Dev: usa free/starter tiers (coste marginal $0–$20)
- Staging: 1× instancia API, DB pequeña, R2 compartido ($30–$60)
- Prod: configuración recomendada arriba ($100–$140 MVP)

## Riesgos y mitigaciones
- Límite de free/starter tiers: monitorizar y escalar a planes pagos a tiempo
- Latencia regional: elegir regiones de baja latencia (iad/yyz/scl) según usuarios
- Vendor lock-in: definir puertos/adaptadores; IaC mínima para migrar a hyperscaler

## Siguientes pasos
- Crear cuentas y proyectos en Vercel, Fly, Neon, Upstash y Cloudflare
- Definir regiones (ej.: Vercel/IAD, Fly YUL/YYZ, Neon US-East, R2 auto)
- Automatizar despliegues en GitHub Actions con secretos por entorno
