# AccountBalance

- Asociaciones: `publisher` (`User`), `community` polimórfico, `user_balances`, `attachment`.
- Validaciones: `publisher`, `subject`, `publication_date`, `attachment`, `community_inclusion`.
- Importación: `create_user_balances_from_file(xls, account_balance)` con parseo de filas y creación de `UserBalance`/`UserBalanceItem`.
