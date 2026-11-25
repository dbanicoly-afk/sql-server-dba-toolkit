/*
 SQL Server DBA Toolkit | Blocking Sessions
 SQL Server 2016+ | Somente leitura | Permissao: VIEW SERVER STATE (2016-2019),
 VIEW SERVER PERFORMANCE STATE (2022+).
 Captura solicitacoes bloqueadas e respectivos session_ids bloqueadores.
 Sessao bloqueadora pode estar 'sleeping' e por isso nao ter request ativa.
 NAO execute KILL automaticamente.
*/
SET NOCOUNT ON;
SELECT
    GETDATE() AS collected_at,
    r.session_id AS blocked_session_id,
    r.blocking_session_id,
    DB_NAME(r.database_id) AS database_name,
    r.wait_type, r.wait_time AS wait_ms,
    r.wait_resource, r.status, r.command,
    r.total_elapsed_time / 1000.0 AS elapsed_sec,
    s.login_name AS blocked_login,
    s.host_name AS blocked_host,
    blocker.login_name AS blocker_login,
    blocker.host_name AS blocker_host,
    blocker.status AS blocker_session_status,
    blocker.open_transaction_count AS blocker_open_transactions,
    tx.text AS blocked_batch
FROM sys.dm_exec_requests AS r
JOIN sys.dm_exec_sessions AS s ON s.session_id = r.session_id
LEFT JOIN sys.dm_exec_sessions AS blocker ON blocker.session_id = r.blocking_session_id
OUTER APPLY sys.dm_exec_sql_text(r.sql_handle) AS tx
WHERE r.blocking_session_id > 0
ORDER BY r.wait_time DESC;
