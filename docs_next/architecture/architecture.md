# Arquitectura

- Módulos (contextos):
  - Identity & Access: usuarios, roles, settings, permisos.
  - Communities: companies/buildings/apartments.
  - Social: messages/events/comments/likes/polls/classifieds.
  - Amenities & Bookings: amenities/availability/reservations.
  - ServiceDesk: service_requests.
  - Payments & Promos: businesses/deals/coupons/purchases/redemptions.
  - Documents: folders/attachments/images.
  - Balances: account_balances/user_balances/items.
- Hexagonal: capas domain/app/infrastructure. Repositorios por agregado, servicios de dominio, casos de uso.
- API: REST v1 (Rails API-only) + opcional GraphQL para vistas compuestas; contratos OpenAPI.
- BFF: capa para frontend con agregación y cache.
- Mensajería: eventos de dominio (Outbox), colas para envíos de email/notifs y sincronizaciones.
