# Apartment

- Asociaciones: `belongs_to :building`, `has_many :images`.
- Validaciones: `building_id`, `category`, `available_at`/`show_price`/`price` según categoría, `bedrooms`, `bathrooms`, `show_contact`, `secondary_*` condicionales, `description`, `images`.
- Callbacks: `update_category_dependecies`.
- Helpers: traducciones de enums, `main_image`, precio final, contactos.
