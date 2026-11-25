/*
 SQL Server DBA Toolkit | Last Backups
 SQL Server 2016+ | Somente leitura
 Historico do MSDB pode ser limpo; vazio nao prova ausencia de backup.
 D=dados FULL; I=diferencial; L=log. COPY_ONLY aparece identificado.
 Verifique SLAs, recovery model e solucoes externas de backup.
*/
USE msdb;
GO
SET NOCOUNT ON;
;WITH last_backups AS (
 SELECT bs.database_name, bs.type,
        bs.backup_finish_date, bs.is_copy_only,
        bs.backup_size, bs.compressed_backup_size,
        ROW_NUMBER() OVER (
          PARTITION BY bs.database_name, bs.type
          ORDER BY bs.backup_finish_date DESC, bs.backup_set_id DESC) AS rn
 FROM dbo.backupset AS bs
 WHERE bs.type IN ('D','I','L') AND bs.backup_finish_date IS NOT NULL
)
SELECT d.name AS database_name, d.state_desc, d.recovery_model_desc,
 MAX(CASE WHEN b.type='D' THEN b.backup_finish_date END) AS last_full,
 MAX(CASE WHEN b.type='I' THEN b.backup_finish_date END) AS last_diff,
 MAX(CASE WHEN b.type='L' THEN b.backup_finish_date END) AS last_log,
 MAX(CASE WHEN b.type='D' THEN CONVERT(int,b.is_copy_only) END) AS last_full_is_copy_only,
 DATEDIFF(HOUR, MAX(CASE WHEN b.type='D' THEN b.backup_finish_date END), GETDATE()) AS hours_since_last_full
FROM sys.databases AS d
LEFT JOIN last_backups AS b ON b.database_name=d.name AND b.rn=1
WHERE d.name <> 'tempdb'
GROUP BY d.name, d.state_desc, d.recovery_model_desc
ORDER BY last_full, d.name;
GO
