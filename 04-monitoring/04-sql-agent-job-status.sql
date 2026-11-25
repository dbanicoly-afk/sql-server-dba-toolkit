/*
 SQL Server DBA Toolkit | SQL Agent Job Status
 SQL Server 2016+ | Somente leitura, consulta msdb.
 Exibe resultado da ULTIMA execucao registrada por job, nao necessariamente
 o estado atual de uma execucao em andamento. Sem historico => NULL.
 Visibilidade depende de roles SQLAgent* ou sysadmin.
*/
USE msdb;
GO
SET NOCOUNT ON;
;WITH last_job AS (
 SELECT h.job_id, h.run_date, h.run_time, h.run_duration,
        h.run_status, h.message,
        ROW_NUMBER() OVER (PARTITION BY h.job_id ORDER BY h.instance_id DESC) AS rn
 FROM dbo.sysjobhistory AS h
 WHERE h.step_id = 0
)
SELECT j.name AS job_name, j.enabled AS is_enabled,
 CASE h.run_status WHEN 0 THEN 'FAILED' WHEN 1 THEN 'SUCCEEDED'
      WHEN 2 THEN 'RETRY' WHEN 3 THEN 'CANCELED'
      WHEN 4 THEN 'IN_PROGRESS' ELSE 'NO_HISTORY' END AS last_outcome,
 CASE WHEN h.run_date > 0 THEN msdb.dbo.agent_datetime(h.run_date,h.run_time) END AS last_run_start,
 h.run_duration AS last_run_duration_hhmmss,
 h.message AS last_message
FROM dbo.sysjobs AS j
LEFT JOIN last_job AS h ON j.job_id=h.job_id AND h.rn=1
ORDER BY CASE WHEN h.run_status=0 THEN 0 WHEN h.run_status IS NULL THEN 1 ELSE 2 END,
         j.name;
GO
