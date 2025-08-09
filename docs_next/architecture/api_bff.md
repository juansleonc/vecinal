# API y BFF

- REST v1 con OpenAPI (Rails API-only); GraphQL opcional para agregaciones complejas.
- Versionado semántico; compatibilidad hacia atrás; feature flags.
- BFF (Next.js Route Handlers opcional). En Ruby se puede añadir `graphql-ruby` como BFF cuando convenga; composición de endpoints, caché, fallbacks.
- Rate limiting por actor; protección CSRF en mutaciones; CORS estricto.
