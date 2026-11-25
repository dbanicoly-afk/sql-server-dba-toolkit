
/*
============================================================================
Projeto: SQL Server DBA Toolkit
Script: 01-instance-health-check.sql
Autora: Nicoly Gavila
Versao: 1.0
Compatibilidade prevista: SQL Server 2016 ou superior
Objetivo: Diagnostico inicial da instancia SQL Server
Tipo de operacao: Somente leitura
============================================================================
*/

USE master;
GO

SET NOCOUNT ON;

-- 01. Informacoes da instancia

SELECT
    SERVERPROPERTY('ServerName') AS ServerName,
    SERVERPROPERTY('MachineName') AS MachineName,
    COALESCE(
        CONVERT(nvarchar(128), SERVERPROPERTY('InstanceName')),
        'MSSQLSERVER'
    ) AS InstanceName,
    SERVERPROPERTY('Edition') AS Edition,
    SERVERPROPERTY('ProductVersion') AS ProductVersion,
    SERVERPROPERTY('ProductLevel') AS ProductLevel,
    SERVERPROPERTY('ProductUpdateLevel') AS ProductUpdateLevel;

-- 02. Uptime e recursos do servidor

SELECT
    sqlserver_start_time AS SQLServerStartTime,
    DATEDIFF(HOUR, sqlserver_start_time, GETDATE()) / 24.0
        AS ApproximateUptimeDays,
    cpu_count AS LogicalCPUCount,
    scheduler_count AS SchedulerCount,
    physical_memory_kb / 1024.0 AS PhysicalMemoryMB,
    committed_kb / 1024.0 AS SQLCommittedMemoryMB,
    committed_target_kb / 1024.0 AS SQLTargetMemoryMB
FROM sys.dm_os_sys_info;

-- 03. Configuracoes de memoria

SELECT
    name AS ConfigurationName,
    value AS ConfiguredValueMB,
    value_in_use AS CurrentValueMB
FROM sys.configurations
WHERE name IN (
    'min server memory (MB)',
    'max server memory (MB)'
);

-- 04. Status dos bancos de dados

SELECT
    name AS DatabaseName,
    state_desc AS DatabaseStatus,
    recovery_model_desc AS RecoveryModel,
    compatibility_level AS CompatibilityLevel,
    user_access_desc AS UserAccess,
    page_verify_option_desc AS PageVerify,
    is_read_only AS IsReadOnly,
    is_auto_close_on AS AutoClose,
    is_auto_shrink_on AS AutoShrink,
    create_date AS CreationDate
FROM sys.databases
ORDER BY name;
