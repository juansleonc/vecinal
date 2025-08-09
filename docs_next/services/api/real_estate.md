# Módulo API (Rails): Real Estate

- Casos de uso: crear/editar/publicar listados; búsqueda con filtros; registrar leads; notificar a admins/agentes.
- Policies: sólo admins/colaboradores publican; leads anónimos permitidos con rate limit y CAPTCHA.
- Repositorio: ActiveRecord; índices por `building_id,status` y búsqueda (Pg trigram/Meilisearch opcional).
- Eventos: `ListingPublished`, `LeadCreated` -> email/push y analítica.
- Seguridad: validación de contenido (XSS), límites de subida (imágenes), reCAPTCHA.
- Métricas: impresiones, clics, leads, tasa de respuesta, tiempo a primer contacto.
