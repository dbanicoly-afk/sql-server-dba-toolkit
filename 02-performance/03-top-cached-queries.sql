/*
 SQL Server DBA Toolkit | Top Cached Queries by total CPU
 SQL Server 2016+ | Somente leitura. DMV: VIEW SERVER STATE (2016-2019),
 VIEW SERVER PERFORMANCE STATE (2022+).
 Medidas acumuladas desde entrada do plano no cache, nao janela de tempo.
 Planos ausentes do cache/execucoes recompiladas nao sao representados.
 SQL text pode conter informacoes sensiveis.
*/
SET NOCOUNT ON;
SELECT TOP (30)
    DB_NAME(t.dbid) AS database_name,
    qs.execution_count,
    qs.total_worker_time / 1000.0 AS total_cpu_ms,
    qs.total_worker_time / NULLIF(qs.execution_count, 0) / 1000.0 AS avg_cpu_ms,
    qs.total_elapsed_time / 1000.0 AS total_elapsed_ms,
    qs.total_logical_reads AS total_logical_reads,
    qs.total_logical_reads / NULLIF(qs.execution_count, 0) AS avg_logical_reads,
    qs.creation_time AS plan_creation_time,
    qs.last_execution_time,
    SUBSTRING(t.text, (qs.statement_start_offset / 2) + 1,
      ((CASE WHEN qs.statement_end_offset = -1 THEN DATALENGTH(t.text)
        ELSE qs.statement_end_offset END - qs.statement_start_offset) / 2) + 1)
      AS statement_text
FROM sys.dm_exec_query_stats AS qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) AS t
ORDER BY qs.total_worker_time DESC;
