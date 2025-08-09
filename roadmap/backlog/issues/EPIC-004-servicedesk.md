# EPIC-004 ServiceDesk Básico (P0)

## Issues

1) Modelo de tickets
- Descripción: Entidad Ticket con estados (open/closed), categoría y responsable.
- Prioridad: P0
- Criterios: migraciones aplicadas

2) Crear/asignar/cerrar
- Descripción: Endpoints CRUD + asignación simple (admin/responsable).
- Prioridad: P0
- Criterios: E2E abrir/cerrar

3) Comentarios en ticket
- Descripción: Añadir comentarios y adjuntos.
- Prioridad: P1
- Criterios: límites de tamaño/tipo

4) Filtros y exportación básica
- Descripción: Listados por estado/fecha; CSV simple.
- Prioridad: P2
- Criterios: P95 < 300ms
