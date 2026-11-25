/*
 SQL Server DBA Toolkit | Database Users and Roles
 SQL Server 2016+ | Somente leitura. Executar no banco de interesse.
 NAO conclua 'usuario orfao' apenas com este resultado: contained users,
 grupos e external users podem nao mapear para server_principals.
*/
SET NOCOUNT ON;
SELECT
 DB_NAME() AS database_name,
 dp.name AS database_principal,
 dp.type_desc AS principal_type,
 dp.authentication_type_desc,
 SUSER_SNAME(dp.sid) AS mapped_server_principal,
 rolep.name AS database_role
FROM sys.database_principals AS dp
LEFT JOIN sys.database_role_members AS drm ON drm.member_principal_id=dp.principal_id
LEFT JOIN sys.database_principals AS rolep ON rolep.principal_id=drm.role_principal_id
WHERE dp.principal_id > 4
  AND dp.type IN ('S','U','G','E','X')
ORDER BY dp.name,rolep.name;
