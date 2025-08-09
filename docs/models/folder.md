# Folder

- Asociaciones: `folderable` polimórfico, `created_by`, `father`/`sub_folders`, `attachments`.
- Validaciones: `folderable`, `name`, `created_by` (si no es raíz), `level` < `LIMIT_HEIGHT`, `not_father_self`.
- Callbacks: `set_defaults` (nivel/herencia `folderable`).
- Scopes: `search_by`.
- Utilidades: `roots_by_user(user)`, árbol completo, acumulación de tamaños.
