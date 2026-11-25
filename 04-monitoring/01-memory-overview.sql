/*
 SQL Server DBA Toolkit | Memory Overview
 SQL Server 2016+ | Somente leitura | DMV: VIEW SERVER STATE (2016-2019),
 VIEW SERVER PERFORMANCE STATE (2022+).
 Nao confundir memoria do process SQL com memoria do buffer pool.
 PLE sozinho nao representa evidencia conclusiva de pressao.
*/
SET NOCOUNT ON;
SELECT
  GETDATE() AS collected_at,
  CAST(physical_memory_kb / 1024.0 AS decimal(18,1)) AS os_total_memory_mb,
  CAST(available_physical_memory_kb / 1024.0 AS decimal(18,1)) AS os_available_memory_mb,
  system_memory_state_desc
FROM sys.dm_os_sys_memory;
SELECT
  GETDATE() AS collected_at,
  CAST(physical_memory_in_use_kb / 1024.0 AS decimal(18,1)) AS sql_process_physical_memory_mb,
  CAST(locked_page_allocations_kb / 1024.0 AS decimal(18,1)) AS locked_page_allocations_mb,
  CAST(memory_utilization_percentage AS int) AS sql_process_memory_utilization_pct,
  process_physical_memory_low, process_virtual_memory_low
FROM sys.dm_os_process_memory;
SELECT name, value AS configured_value_mb, value_in_use AS in_use_value_mb
FROM sys.configurations
WHERE name IN ('min server memory (MB)', 'max server memory (MB)');
SELECT
  CAST(committed_kb / 1024.0 AS decimal(18,1)) AS sql_memory_manager_committed_mb,
  CAST(committed_target_kb / 1024.0 AS decimal(18,1)) AS sql_memory_manager_target_mb
FROM sys.dm_os_sys_info;
