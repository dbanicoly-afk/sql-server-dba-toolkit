# Checklist de validação — SQL Server DBA Toolkit

**Status do pacote:** exemplos preparados para revisão e testes; **não validados em execução real** pela autora nesta entrega. O `01-health-check` é o único módulo anteriormente testado pela autora.

## Procedimento por script

1. Abra o script no SSMS e confirme o **contexto do banco** antes de executar (especialmente os scripts de arquivo, usuários e índices).
2. Confira versão/edição da instância e as permissões para DMVs.
3. Execute primeiro em **ambiente de laboratório** ou instância de testes; registre tempo e impacto.
4. Revise o esquema e os tipos das colunas retornadas; resultados vazios podem ser normais.
5. Compare com interface do SSMS ou uma segunda fonte (por exemplo, Job Activity Monitor, backup history, propriedades de banco).
6. Não compartilhe capturas/resultados com nomes de servidores, logins, hostnames, SQL text ou caminhos internos.
7. Registre `Versão`, `Data`, `Resultado`, `Observações`, `Ajustes` e `Status` (Pendente / Validado / Reprovado).

## Casos que merecem cuidado

| Script | Validação importante |
|---|---|
| `02-performance/01-active-requests.sql` | Comparar com Activity Monitor ou sp_WhoIsActive, respeitando diferenças de escopo. |
| `02-performance/02-blocking-sessions.sql` | Simular bloqueio no laboratório; `blocking_session_id` pode ser zero em ambiente tranquilo. |
| `02-performance/03-top-cached-queries.sql` | Os tempos são acumulados desde o plano entrar no cache; consultas recompiladas podem desaparecer. |
| `03-backup-restore/01-last-backups.sql` | Validar histórico de COPY_ONLY e casos sem backup; `msdb` pode ter retenção limitada. |
| `03-backup-restore/02-backup-history.sql` | Comparar duração e tamanho contra `msdb.dbo.backupset`. |
| `04-monitoring/01-memory-overview.sql` | Observar pressão de SO e SQL; nenhuma métrica isolada é diagnóstico conclusivo. |
| `04-monitoring/02-database-file-usage.sql` | Executar no banco correto; coluna `used_data_mb` é NULL para arquivos LOG. |
| `04-monitoring/03-disk-volumes.sql` | Comparar volume com Windows; exibe apenas volumes que hospedam arquivos SQL. |
| `04-monitoring/04-sql-agent-job-status.sql` | Comparar com Job History; não informa corretamente status de execução ao vivo. |
| `05-security/01-server-logins.sql` | Validar permissões de visibilidade, sem divulgar dados reais. |
| `05-security/02-database-users.sql` | Testar com usuários contidos e grupos; NULL no login não implica usuário órfão. |
| `06-maintenance/01-index-fragmentation-limited.sql` | Avaliar impacto, página mínima e `LIMITED`; não fazer rebuild automático. |
| `06-maintenance/02-index-usage.sql` | Contadores podem ter sido reiniciados; não gerar recomendações automáticas de DROP. |

## Registro sugerido

| Script | Versão SQL | Data | Resultado | Status |
|---|---|---|---|---|
| `01-health-check/01-instance-health-check.sql` | preencher | preencher | executado anteriormente em teste | A confirmar versão |
| Demais scripts | — | — | — | Pendente |

> Segurança: o pacote é **somente leitura**; mesmo assim, algumas consultas de DMV podem ter custo perceptível em instâncias grandes.
