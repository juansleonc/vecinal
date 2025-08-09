# Arquitectura general

Aplicación monolítica Ruby on Rails con dominios principales:
- Identidad y cuentas: `User`, `ContactDetails`, Devise (omniauth Facebook/LinkedIn/Google).
- Comunidades: `Company` (administradora), `Building` (comunidad), `Apartment`.
- Comunicación: `Message`, `Comment`, `Event`, `Poll`, `Classified`, `Like`.
- Facilidades: `Amenity`, `Availability`, `Reservation`, `Review`, `Image`, `Attachment`, `Folder`.
- Pagos: `PaymentAccount`, `Payment`, `Deal`, `Coupon`, `DealPurchase`, `CouponRedemption`.
- Soporte/operación: `ServiceRequest`, `AccountBalance`, `UserBalance`, `UserBalanceItem`, `Invite`.

Patrones y módulos transversales (concerns):
- Marcado/lectura/compartir/contabilización: `Markable`, `Unreadable`, `Shareable`, `Countable`.
- Medios y assets: `HasLogo`, `Attachmentable`, `Image` variants.
- Configuración: `Settingable`, `SettingableCommunity`, `Setting`.
- Geolocalización: `Geocodeable`.

Notificaciones: `UserMailer` + callbacks de modelos.
Autenticación/autorización: Devise + CanCanCan (`Ability`).
