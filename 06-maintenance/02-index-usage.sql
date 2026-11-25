/*
 SQL Server DBA Toolkit | Index Usage Statistics
 SQL Server 2016+ | Somente leitura | VIEW SERVER STATE (2016-2019),
 VIEW SERVER PERFORMANCE STATE (2022+) conforme permissao.
 Contadores podem resetar (reinicio/detach etc). Um indice com zero seeks
 NAO deve ser eliminado automaticamente; considere PK, unique e constraints.
*/
SET NOCOUNT ON;
SELECT
 DB_NAME() AS database_name,
 SCHEMA_NAME(o.schema_id) AS schema_name,
 o.name AS table_name,
 i.name AS index_name, i.type_desc,
 i.is_primary_key, i.is_unique_constraint,
 ISNULL(u.user_seeks,0) AS user_seeks,
 ISNULL(u.user_scans,0) AS user_scans,
 ISNULL(u.user_lookups,0) AS user_lookups,
 ISNULL(u.user_updates,0) AS user_updates,
 u.last_user_seek,u.last_user_scan,u.last_user_update
FROM sys.indexes AS i
JOIN sys.objects AS o ON o.object_id=i.object_id AND o.type='U'
LEFT JOIN sys.dm_db_index_usage_stats AS u
  ON u.database_id=DB_ID() AND u.object_id=i.object_id AND u.index_id=i.index_id
WHERE i.index_id > 0 AND i.is_hypothetical=0
ORDER BY ISNULL(u.user_updates,0) DESC, o.name, i.name;
