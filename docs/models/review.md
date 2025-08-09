# Review

- Asociaciones: `reviewable` polimórfico, `user`/`publisher`, `comments`, `likes`.
- Validaciones: `reviewable`, `user`, `rank` (1..5).
- Callbacks: `notify_reviewable` al crear (envía correo a entidad reviewable).
