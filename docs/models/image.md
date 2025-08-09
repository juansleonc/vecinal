# Image (+ derivadas)

- Asociaciones: `imageable` polimórfico.
- Paperclip: estilos y compresión, default_url por clase (`ImageCompany`, `ImageBuilding`, `ImageBusiness`, `ImageAmenity`, `ImageUser`).
- Validaciones: tipo de contenido y tamaño.
- Callback: `set_home_unique` (una imagen `home` por entidad).
- Constantes: `ALLOWED_CONTENT_TYPES`, `ALLOWED_IMAGE_EXTENSIONS`, `MAX_SIZE`, `MAX_IN_TIMELINE`.
