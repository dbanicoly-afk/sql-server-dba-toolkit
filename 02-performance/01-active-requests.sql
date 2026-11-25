/*
 SQL Server DBA Toolkit | Active Requests
 SQL Server 2016+ | Somente leitura | Permissao: VIEW SERVER STATE (2016-2019),
 VIEW SERVER PERFORMANCE STATE (2022+).
 Objetivo: diagnosticar requisicoes ativas. Nao confundir sessao com requisicao.
 CUIDADO: sql_text pode conter dados sensiveis; nao compartilhe resultados reais.
*/
SET NOCOUNT ON;
SELECT TOP (100)
    GETDATE() AS collected_at,
    r.session_id, r.request_id, s.login_name, s.host_name, s.program_name,
    DB_NAME(r.database_id) AS database_name,
    r.status AS request_status, r.command,
    r.start_time, r.total_elapsed_time / 1000.0 AS elapsed_sec,
    r.cpu_time AS cpu_ms,
    r.reads, r.writes, r.logical_reads,
    r.wait_type, r.wait_time AS wait_ms, r.blocking_session_id,
    r.granted_query_memory * 8.0 / 1024 AS granted_query_memory_mb,
    SUBSTRING(t.text,
       (r.statement_start_offset / 2) + 1,
       ((CASE WHEN r.statement_end_offset = -1
          THEN DATALENGTH(t.text) ELSE r.statement_end_offset END
         - r.statement_start_offset) / 2) + 1) AS executing_statement
FROM sys.dm_exec_requests AS r
JOIN sys.dm_exec_sessions AS s ON r.session_id = s.session_id
OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) AS t
WHERE r.session_id <> @@SPID
  AND s.is_user_process = 1
ORDER BY r.total_elapsed_time DESC;
