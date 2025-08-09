# Checklist de control de costos (bootstrapped)

Semanal:
- Revisar uso de Vercel (build minutes, bandwidth)
- Fly.io: VMs activas por app/env, apagar staging fuera de horario
- Neon: almacenamiento y conexiones activas; pausar branch previews
- Upstash: throughput/latencia y límites; eliminar claves no usadas
- R2: tamaño y requests; habilitar cache público donde aplique
- Sentry/Grafana: retención de logs/trazas; silenciar ruidos

Mensual:
- Revisión de facturas y presupuesto objetivo (< $50–$80)
- Limpieza de assets huérfanos y snapshots DB
- Revisión de alerts por límites (pre‑alertas al 80%)

Automatizaciones sugeridas:
- Scripts/cron para apagar/encender staging (Fly scale 0/1)
- Etiquetado de recursos por entorno y fecha de creación
- Alertas de coste por proveedor (budgets/quotas)
