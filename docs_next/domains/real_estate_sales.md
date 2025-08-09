# Dominio: Ventas de Inmuebles (next)

Objetivo: permitir publicar y gestionar la venta de propiedades (unidades/apartamentos) dentro de las comunidades.

Actores: administrador/colaborador (gestiona listados), agente, propietario, interesado.

MVP deseado (v1):
- Listados: crear/editar/publicar/unpublish, galería de imágenes, descripción, precio, disponibilidad.
- Contacto e interés: formulario de contacto/lead con tracking, programar visita.
- Visibilidad: filtros/búsqueda por ubicación/precio/habitaciones.

Incrementos posteriores:
- Ofertas/contraofertas, reservas de unidad y seña.
- KYC ligero y verificación de identidad.
- Contratos digitales y firma eID.
- Pasarela de pagos/escrow (Stripe Connect u otro PSP local) y desembolsos.
- Analytics de listings (impresiones/clics/contactos), CRM simple.
- Moderación de contenido, reporting, SLA de respuesta.

Relación con dominios existentes:
- Reutiliza `Apartment`/`Building` como referencia física, con un agregado `Listing` dedicado.
- Usa `Image/Attachment` para media, `Message/Comment` para comunicación y `Payments` para señas/escrow.
