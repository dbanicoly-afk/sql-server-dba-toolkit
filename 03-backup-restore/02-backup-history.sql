/*
 SQL Server DBA Toolkit | Backup History
 SQL Server 2016+ | Somente leitura
 Ajuste @Days e @Top; historico em msdb nao garante integridade do arquivo.
 Tamanhos do backupset (backup_size / compressed_backup_size) sao aproximados.
*/
USE msdb;
GO
SET NOCOUNT ON;
DECLARE @Days int = 7;
DECLARE @Top int = 100;
SELECT TOP (@Top)
 bs.database_name,
 CASE bs.type WHEN 'D' THEN 'FULL' WHEN 'I' THEN 'DIFF'
              WHEN 'L' THEN 'LOG' ELSE bs.type END AS backup_type,
 bs.is_copy_only, bs.backup_start_date, bs.backup_finish_date,
 DATEDIFF(SECOND, bs.backup_start_date, bs.backup_finish_date) AS duration_sec,
 CAST(bs.backup_size/1048576.0 AS decimal(18,2)) AS backup_size_mb,
 CAST(bs.compressed_backup_size/1048576.0 AS decimal(18,2)) AS compressed_size_mb,
 bs.server_name, bs.recovery_model
FROM dbo.backupset AS bs
WHERE bs.type IN ('D','I','L')
  AND bs.backup_start_date >= DATEADD(DAY,-@Days,GETDATE())
ORDER BY bs.backup_start_date DESC;
GO
