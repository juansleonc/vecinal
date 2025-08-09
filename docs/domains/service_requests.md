# Solicitudes de servicio (Tickets)

- `ServiceRequest`: categorías (`CATEGORIES`), estados (`STATUSES`), responsable (`User` o `Company`), adjuntos y comentarios. Exportación CSV.
- Flujos: crear, asignar responsable por defecto, cambiar estado, cerrar y calificar (`rank`). Notifica a responsable y solicitante.
- Vistas: abiertas/cerradas; filtros por fechas; búsqueda por texto/contactos.
- Métricas: conteos abiertos/cerrados, `UserNotificationsManager`.
