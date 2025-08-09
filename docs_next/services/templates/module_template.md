# Plantilla de módulo (Rails API)

- Controller: endpoints conforme OpenAPI, autenticación (Devise/JWT), policies (Pundit/CanCanCan), instrumentación.
- Service (casos de uso): orquesta repos y dominios, idempotencia.
- Repository (puerto/adaptador): ActiveRecord/queries; transacciones y mapeo entidades.
- Events: outbox, productores/consumidores.
- Tests: unit/integración/contrato.
- Checklist: logs estructurados, métricas, manejo de errores uniforme, tiempos de timeout y reintentos.
