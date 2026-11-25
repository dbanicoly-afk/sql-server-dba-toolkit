/*
 SQL Server DBA Toolkit | Index Fragmentation (LIMITED)
 SQL Server 2016+ | Somente leitura | VIEW DATABASE STATE (2016-2019);
 VIEW DATABASE PERFORMANCE STATE (SQL Server 2022+) conforme permissao.
 Execute no banco alvo. Faz leitura de metadados/alocacao e pode custar I/O;
 evite rodar em todos os bancos simultaneamente em horarios criticos.
 Filtra indexes com >= 1000 pages. Fragmentacao isolada NAO determina rebuild.
*/
SET NOCOUNT ON;
DECLARE @MinimumPages bigint = 1000;
SELECT TOP (100)
 DB_NAME() AS database_name,
 OBJECT_SCHEMA_NAME(ips.object_id) AS schema_name,
 OBJECT_NAME(ips.object_id) AS table_name,
 i.name AS index_name,
 ips.index_type_desc,
 ips.partition_number,
 ips.page_count,
 CAST(ips.avg_fragmentation_in_percent AS decimal(8,2)) AS avg_fragmentation_pct,
 CAST(ips.avg_page_space_used_in_percent AS decimal(8,2)) AS avg_page_space_used_pct
FROM sys.dm_db_index_physical_stats(DB_ID(),NULL,NULL,NULL,'LIMITED') AS ips
JOIN sys.indexes AS i ON i.object_id=ips.object_id AND i.index_id=ips.index_id
WHERE ips.index_id > 0
  AND ips.alloc_unit_type_desc='IN_ROW_DATA'
  AND ips.page_count >= @MinimumPages
ORDER BY ips.page_count DESC,ips.avg_fragmentation_in_percent DESC;
