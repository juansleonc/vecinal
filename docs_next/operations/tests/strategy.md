# Estrategia de pruebas

- Pirámide: unit (70%), integración (20%), E2E (10%).
- Contratos: OpenAPI validado en server (Rails con `openapi_first`/`committee`) y verificado en CI; Pact opcional para inter-servicios.
- Ruby: RSpec (model, request), FactoryBot, Faker; System tests opcionales para flujos críticos.
- TypeScript: Vitest/Jest para unidades; testing library para UI; Playwright para E2E.
- Seeds/datos: factories deterministas; data builders.
- Cobertura: líneas/branches >= 80%; mutación opcional (Stryker en TS).
- E2E: Playwright con escenarios críticos (login, reservas, tickets, pagos) por entorno preview.
