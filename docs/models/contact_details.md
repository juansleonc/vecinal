# ContactDetails

- Asociaciones: `belongs_to :user`.
- Atributos: `apartment_numbers` (Array) con helper `apartment_numbers_string` para parsing.
- Callbacks: `set_apartment_numbers`.
- OAuth helpers: sanitización de datos de Facebook/LinkedIn/Google.
