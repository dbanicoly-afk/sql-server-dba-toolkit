# Histórico de backup

Últimos backups e histórico de execução em `msdb`.

> **Status:** scripts pendentes de validação em laboratório.

## Scripts

| Arquivo | Operação |
|---|---|
| [01-last-backups.sql](./01-last-backups.sql) | Somente leitura |
| [02-backup-history.sql](./02-backup-history.sql) | Somente leitura |

## Cuidados
Histórico não equivale a backup recuperável. Sempre valide política, retenção e restauração.

Consulte o cabeçalho de cada script para permissões e detalhes. Teste em ambiente não produtivo antes de qualquer uso mais amplo.

[Voltar ao Toolkit](../README.md)
