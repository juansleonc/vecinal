# Attachment

- Asociaciones: `attachmentable` polimórfico, `created_by`.
- Validaciones: presencia y tamaño de archivo; validación propia de extensión permitida.
- Constantes: listas de extensiones permitidas, tamaño máximo, mapa de íconos.
- Scopes: `search_by` (por nombre), `by_adaptive`, `beetwen`.
- Métodos: `image?`, `file_extension`, `image_col_size(index)`.
