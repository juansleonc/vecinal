# Performance Budgets

- API: P95 < 250ms, P99 < 600ms; error rate < 0.5%.
- Frontend: LCP < 2.5s, TTI < 3.5s, CLS < 0.1; bundle base < 180KB gzip.
- Reservas (hot path): creación concurrente 100 rps sostenidos sin colisiones corruptas.
