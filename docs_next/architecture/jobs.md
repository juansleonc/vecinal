# Background jobs y flujos

- Colas: Sidekiq (Redis) para emails, notificaciones push, procesado de imágenes, cálculos de métricas.
- Workflows: Sidekiq + orquestación con outbox/sagas; Temporal opcional si complejidad lo justifica.
- Outbox pattern para eventos de dominio; idempotencia, reintentos exponenciales, DLQ.
