# Rutas principales

Resumen de rutas y módulos asociados. Ver `config/routes.rb` para detalle completo.

- Autenticación: `devise_for :users` con callbacks y confirmaciones personalizadas.
- Usuarios: perfil, ajustes, exportación, cambio de contraseña, dejar comunidad.
- Registro guiado: `finish_registration` (roles, crear comunidad, etc.).
- Residentes: contactos, comunidades, news feed.
- Mensajes: inbox/bandejas, marcas (read/unread/deleted/done), búsqueda.
- Solicitudes de servicio: index, crear, cerrar, asignar responsable, exportar.
- Eventos: index, crear, RSVP (ack/yes/no/maybe), calendario, receptores.
- Amenities/Reservas: CRUD amenidades, calendario, reglas de disponibilidad, reservas (cambiar estado/responsable).
- Encuestas: index, crear, guardar, públicos vs comunidad, votos.
- Clasificados: index, crear/editar, guardar, públicos vs comunidad.
- Pagos: `payment_accounts`, `payments`.
- Folders/Attachments: CRUD carpetas, añadir/actualizar/eliminar adjuntos.
- Balances: `account_balances`, `user_balances` (impresión/exportación).
- Páginas públicas por subdominio/namespace para `Company`, `Building`, `Business`.
