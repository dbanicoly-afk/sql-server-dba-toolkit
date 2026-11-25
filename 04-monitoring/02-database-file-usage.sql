/*
 SQL Server DBA Toolkit | Database File Usage
 SQL Server 2016+ | Somente leitura. Execute no database alvo; altera apenas
 contexto da sessao. FILEPROPERTY SpaceUsed retorna NULL para log files:
 calculo de espaco usado aplica-se somente aos data files (ROWS).
*/
SET NOCOUNT ON;
SELECT DB_NAME() AS database_name,
 name AS logical_name, type_desc, state_desc,
 physical_name,
 CAST(size * 8.0 / 1024 AS decimal(18,2)) AS allocated_mb,
 CASE WHEN type = 0 THEN CAST(FILEPROPERTY(name,'SpaceUsed') * 8.0 / 1024 AS decimal(18,2)) END AS used_data_mb,
 CASE WHEN type = 0 THEN CAST((size-FILEPROPERTY(name,'SpaceUsed')) * 8.0 / 1024 AS decimal(18,2)) END AS free_inside_data_mb,
 CASE WHEN is_percent_growth=1 THEN CONCAT(growth,'%')
      ELSE CONCAT(CAST(growth * 8.0 / 1024 AS decimal(18,2)),' MB') END AS filegrowth,
 CASE WHEN max_size = -1 THEN 'UNLIMITED'
      WHEN max_size = 0 THEN 'NO_GROWTH'
      ELSE CONCAT(CAST(max_size*8.0/1024 AS decimal(18,2)),' MB') END AS max_size
FROM sys.database_files
ORDER BY type, name;
