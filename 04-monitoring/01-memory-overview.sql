
/*
============================================================================
Projeto: SQL Server DBA Toolkit
Script: 01-memory-overview.sql
Autora: Nicoly Gavila
Versao: 1.1
Compatibilidade prevista: SQL Server 2016+
Objetivo: Diagnostico de memoria do SQL Server e sistema operacional
Tipo de operacao: Somente leitura

Permissoes:
SQL Server 2016-2019: VIEW SERVER STATE
SQL Server 2022+: VIEW SERVER PERFORMANCE STATE
============================================================================
*/

SET NOCOUNT ON;

-- 01. Memoria do sistema operacional

SELECT
    GETDATE() AS collected_at,
    CAST(total_physical_memory_kb / 1024.0
        AS decimal(18,1)) AS os_total_memory_mb,
    CAST(available_physical_memory_kb / 1024.0
        AS decimal(18,1)) AS os_available_memory_mb,
    system_memory_state_desc
FROM sys.dm_os_sys_memory;

-- 02. Memoria do processo SQL Server

SELECT
    GETDATE() AS collected_at,
    CAST(physical_memory_in_use_kb / 1024.0
        AS decimal(18,1)) AS sql_process_physical_memory_mb,
    CAST(locked_page_allocations_kb / 1024.0
        AS decimal(18,1)) AS locked_page_allocations_mb,
    memory_utilization_percentage
        AS sql_process_memory_utilization_pct,
    process_physical_memory_low,
    process_virtual_memory_low
FROM sys.dm_os_process_memory;

-- 03. Configuracoes de memoria

SELECT
    name,
    value AS configured_value_mb,
    value_in_use AS in_use_value_mb
FROM sys.configurations
WHERE name IN (
    'min server memory (MB)',
    'max server memory (MB)'
);

-- 04. Memoria comprometida e memoria alvo

SELECT
    CAST(committed_kb / 1024.0
        AS decimal(18,1)) AS sql_memory_manager_committed_mb,
    CAST(committed_target_kb / 1024.0
        AS decimal(18,1)) AS sql_memory_manager_target_mb
FROM sys.dm_os_sys_info;
