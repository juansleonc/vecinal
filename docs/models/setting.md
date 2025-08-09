# Setting

- Asociaciones: `belongs_to :settingable` polimórfico.
- Constantes: `NAMES` (todas las llaves de configuración), `VALUES`.
- Validaciones: presencia de `settingable` y `name` en `NAMES`; `allowed_value` (no `public` en ciertos settings de comunidad).
