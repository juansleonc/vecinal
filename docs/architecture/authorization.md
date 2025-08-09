# Autorización y roles

Autorización con CanCanCan (`app/models/ability.rb`). Roles: administrator, collaborator, resident, board_member, tenant, agent, supplier.

- Company admins/collaborators: gestión de `Company`, `Building`, `Amenity`, `Reservation`, `Folder`, `ServiceRequest`; CRUD sobre recursos de su compañía/edificios; gestionar usuarios/contactos; ver y operar balances.
- Residents/board_members/tenants/agents: crear/ver `ServiceRequest`, `Reservation`, `Event` según settings; participar en `Poll`, `Classified`; acceder a folders del `Building`.
- Supplier: gestión de `Business`, `Deal`, `Coupon` y redenciones.

Marcadores/visibilidad:
- `Markable` y `markers` permiten labels: deleted/destroyed/done/email_read/personal/reported, con lógicas como autodestrucción por reportes (>3).
- `Shared` define visibilidad pública vs compartida con comunidad.

Ajustes por entidad (`Setting`/`Settingable*`): controlan quién puede ver/crear/accionar en timeline, eventos, encuestas, mensajes, ofertas, reseñas y notificaciones por correo.
