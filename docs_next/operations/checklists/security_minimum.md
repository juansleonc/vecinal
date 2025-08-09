# Checklist de seguridad mínima (MVP)

Identidad/Acceso
- OIDC activo con rotación de tokens y expiración razonable
- MFA/WebAuthn obligatorio para admins
- Roles y permisos verificados (tests) en endpoints críticos

Aplicación
- Validación/sanitización en borde (Zod) y en DB (constraints)
- CSRF protegido en mutaciones; cookies secure/HttpOnly/SameSite
- Headers de seguridad (CSP, HSTS, X-Frame-Options, X-Content-Type)
- Uploads: límites de tamaño/tipo, AV scan opcional, URLs firmadas

Dependencias/Entorno
- SBOM generado; SCA/semgrep en CI pasan sin críticos
- Secretos en vault/CI secrets; rotación documentada; no hardcode
- Logging sin PII sensible; mascarado de datos

Infra
- HTTPS forzado; TLS 1.2+; certificados válidos y auto‑renovación
- Backups DB diarios y restauración probada (restore test)
- WAF/CDN con reglas básicas y rate limiting

Procedimientos
- Plan de respuesta a incidentes publicado; contactos y escalado
- Usuarios/privilegios revisados (principio de mínimo privilegio)
