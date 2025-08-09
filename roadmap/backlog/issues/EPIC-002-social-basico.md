# EPIC-002 Social Básico (P0)

## Issues

1) Título: Modelo de mensajes y hilos
- Descripción: Definir entidades Message/Thread/Participant y estados básicos.
- Prioridad: P0
- Criterios: migraciones; CRUD básico
'tpl'

2) Título: Inbox simple
- Descripción: Listado de mensajes y bandejas por etiquetas (inbox/done/deleted).
- Prioridad: P0
- Criterios: paginación cursor; filtros

3) Título: Envío y recepción de mensajes
- Descripción: Endpoint POST con validaciones; notificación por email.
- Prioridad: P0
- Criterios: E2E OK

4) Título: Comentarios en timeline de comunidad
- Descripción: Publicar y listar comentarios en comunidad; visibilidad por permisos.
- Prioridad: P1
- Criterios: permisos probados

5) Título: Búsqueda simple
- Descripción: Filtros por texto/usuario; índices
- Prioridad: P1
- Criterios: tiempos P95 < 300ms
