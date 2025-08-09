# Usuarios y comunidades

Entidades:
- `User`: Devise, roles, pertenencia a comunidad (`accountable`: `Company`/`Building`/`Business`).
- `Company` (administradora) y `Building` (comunidad): definen el alcance de relaciones, permisos y visibilidad.
- `ContactDetails`: datos de contacto y `apartment_numbers`.
- `Invite`: invitaciones para unirse a una comunidad (rol, email, apto).

Flujos clave:
- Alta/login/confirmación (Devise) y OAuth.
- Invitaciones: `InvitesBulkCreator` (individual o masivo), validaciones, envío de correo.
- Finalizar registro y selección de rol/comunidad (`finish_registration`).
- Cambio/abandono de comunidad: `User#leave_community` con validaciones.

Permisos: ver `docs/architecture/authorization.md`.

Notificaciones: `UserMailer` (invite, join request, cambios, problemas de software).
