# Performance e troubleshooting

Requisições ativas, bloqueios e consultas de maior CPU no cache.

> **Status:** scripts pendentes de validação em laboratório.

## Scripts

| Arquivo | Operação |
|---|---|
| [01-active-requests.sql](./01-active-requests.sql) | Somente leitura |
| [02-blocking-sessions.sql](./02-blocking-sessions.sql) | Somente leitura |
| [03-top-cached-queries.sql](./03-top-cached-queries.sql) | Somente leitura |

## Cuidados
Antes de concluir que existe lentidão, diferencie espera, bloqueio, consumo acumulado e execução atual.

Consulte o cabeçalho de cada script para permissões e detalhes. Teste em ambiente não produtivo antes de qualquer uso mais amplo.

[Voltar ao Toolkit](../README.md)
