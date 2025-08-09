# Promotion (abstracta)

- Base para `Deal` y `Coupon`.
- Asociaciones: `business`, `images`.
- Validaciones: `business_id`, `type` en `TYPES`, `category` en `CATEGORIES`, `title`, `number >= 0`, `show_contact` en `CONTACT_OPTIONS`, contactos secundarios condicionales, fechas y aceptación.
- Callbacks: `validates_weeks_after_end`, `process_payment` (Stripe: highlight/top).
- Scopes: `valid`, `intop`, `outtop`, `scheduled`, `expired`.
- Utilidades: split de texto, cobros highlight/top, métricas de impresiones/clicks/estado.
