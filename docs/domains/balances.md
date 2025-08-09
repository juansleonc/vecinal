# Balances y cobranzas

- `AccountBalance`: publicación de balances con archivo Excel; parseo a `UserBalance` y `UserBalanceItem` (filas por concepto). Validación de comunidad.
- `UserBalance`: saldos por apartamento, asociación a usuarios aceptados por `apartment_numbers`; filtros por fecha/año/comunidad.
- `UserBalanceItem`: items detallados del balance.

Flujos:
- Subir archivo de balances; parseo y creación de registros; impresión individual/global.
