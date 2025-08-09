# EPIC-001 Autenticación y Acceso (P0)

## Issues

1) Título: Integración OIDC (proveedor) 
- Descripción: Configurar proveedor OIDC (Auth0/Kratos) con flujos PKCE, callbacks y scopes.
- Prioridad: P0
- Criterios de aceptación:
  - Login/logout funcionando en staging y prod
  - Reclamaciones básicas en ID token (email, name, sub)

2) Título: Modelo de usuario y roles
- Descripción: Definir esquema de `User`, roles base (admin, resident, collaborator) y atributos de perfil.
- Prioridad: P0
- Criterios de aceptación: migraciones aplicadas; CRUD de perfil en API

3) Título: Registro por invitación
- Descripción: Flujo de invitaciones con token, expiración y asignación de rol/comunidad.
- Prioridad: P0
- Criterios: invitación usable una vez; email enviado; audit log

4) Título: Settings de privacidad básicos
- Descripción: Preferencias por usuario (visibilidad perfil, notificaciones).
- Prioridad: P1
- Criterios: endpoints GET/PUT; validados con Zod

5) Título: Autorización (políticas)
- Descripción: Definir y aplicar políticas por dominio (CASL/guards Nest).
- Prioridad: P0
- Criterios: pruebas unitarias de permisos claves

6) Título: Gestión de sesiones/tokens
- Descripción: Cookies secure/HttpOnly/SameSite; rotación/expiración
- Prioridad: P0
- Criterios: pruebas E2E pasando; sin mixed content

7) Título: MFA para admins
- Descripción: Enforce MFA/WebAuthn en cuentas admin.
- Prioridad: P1
- Criterios: política aplicada; bypass deshabilitado

8) Título: Auditoría de eventos de acceso
- Descripción: Registros de login/logout/role change con traceId.
- Prioridad: P1
- Criterios: dashboards con eventos
