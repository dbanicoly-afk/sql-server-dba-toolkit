# Índices e manutenção

Fragmentação limitada e histórico de uso de índices.

> **Status:** scripts pendentes de validação em laboratório.

## Scripts

| Arquivo | Operação |
|---|---|
| [01-index-fragmentation-limited.sql](./01-index-fragmentation-limited.sql) | Somente leitura |
| [02-index-usage.sql](./02-index-usage.sql) | Somente leitura |

## Cuidados
Nenhum script altera índices, estatísticas ou parâmetros. Não automatize DROP/REBUILD com base em métricas isoladas.

Consulte o cabeçalho de cada script para permissões e detalhes. Teste em ambiente não produtivo antes de qualquer uso mais amplo.

[Voltar ao Toolkit](../README.md)
