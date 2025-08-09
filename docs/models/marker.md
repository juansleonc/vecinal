# Marker

- Asociaciones: `user`, `markable` polimórfico.
- Validaciones: unicidad por `user`+`markable`.
- Callback: `trigger_mark_actions` (autodestruye contenido si supera reportes).
- Scope: `reported`.
