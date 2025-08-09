# Datos y almacenamiento

- PostgreSQL con particionado por fecha para historiales (mensajes, comentarios, pagos, balances).
- ActiveRecord: migraciones seguras (gem `strong_migrations`), constraints en DB, validaciones en modelos; esquemas compartidos vía OpenAPI y Zod en clientes.
- Búsquedas: Meilisearch/Elastic para `search_by` actuales (mensajes, encuestas, clasificados, amenities, usuarios).
- Caché: Redis para sesiones/ACL/queries calientes.
- S3: assets; firma temporal; thumbnails en colas; AV scan.
