# Comunicación social

- `Message`: mensajes con receptores múltiples, estados por marcas (deleted/done/destroyed/email_read), búsqueda por texto/contactos. Notifica por email a receptores.
- `Event`: eventos con receptores, RSVP (ack/yes/no/maybe), vistas por calendario. Notifica por email.
- `Comment`: posts en timelines de `User`/`Company`/`Building` y comentarios en `Message`/`Event`/`ServiceRequest`/`Reservation`/`Comment`.
- `Poll`/`PollAnswer`/`PollVote`: encuestas con límite por días/fecha, validación de opciones, visibilidad pública o por comunidad.
- `Classified`: ofertas clasificados con adjuntos, visibilidad pública o comunidad.

Visibilidad y marcas: `Shareable`, `Markable`, `Unreadable`.

Búsquedas: `search_by` en modelos, uniendo por contactos/detalles.
