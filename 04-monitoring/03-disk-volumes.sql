/*
 SQL Server DBA Toolkit | Disk Volumes Hosting SQL Files
 SQL Server 2016+ | Somente leitura | DMV: VIEW SERVER STATE (2016-2019),
 VIEW SERVER PERFORMANCE STATE (2022+).
 Mostra apenas volumes onde ha arquivos de banco acessiveis a instancia.
 Espaco em disco nao equivale a espaco livre dentro de MDF/LDF.
*/
SET NOCOUNT ON;
SELECT DISTINCT
 vs.volume_mount_point,
 vs.logical_volume_name,
 vs.file_system_type,
 CAST(vs.total_bytes/1073741824.0 AS decimal(18,2)) AS total_gb,
 CAST(vs.available_bytes/1073741824.0 AS decimal(18,2)) AS free_gb,
 CAST(100.0*vs.available_bytes/NULLIF(vs.total_bytes,0) AS decimal(6,2)) AS free_pct
FROM sys.master_files AS mf
CROSS APPLY sys.dm_os_volume_stats(mf.database_id,mf.file_id) AS vs
ORDER BY vs.volume_mount_point;
