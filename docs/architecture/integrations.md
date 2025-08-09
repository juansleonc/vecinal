# Integraciones externas

- Devise: autenticación, confirmación por correo, OAuth (Facebook, LinkedIn, Google). Mailer personalizado `DeviseMailer`.
- CanCanCan: autorización por roles y condiciones (`Ability`).
- Paperclip: almacenamiento de `Image` y `Attachment` con validaciones de tamaño/tipo.
- Geocoder: geocodificación y búsquedas cercanas (`Building`, `Business`), `ipapi_com` para lookup por IP.
- Stripe: cargos y suscripciones (negocios/compañías), `DealPurchase` y planes `adm_*`, `sup_*`.
- Griddler/Sendgrid: procesamiento de respuestas por email (`EmailProcessor`, `mount_griddler`).
- Airbrake: notificación de errores en producción.
