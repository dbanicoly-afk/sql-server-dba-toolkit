/*
 SQL Server DBA Toolkit | Server Logins
 SQL Server 2016+ | Somente leitura
 Visibilidade de principals e propriedades depende das permissoes.
 Nao exporte nomes de contas e politicas de seguranca do ambiente.
*/
SET NOCOUNT ON;
SELECT
 sp.name AS login_name,
 sp.type_desc, sp.is_disabled,
 sp.create_date, sp.modify_date,
 sp.default_database_name,
 CASE WHEN sp.type='S' THEN sl.is_policy_checked END AS password_policy_checked,
 CASE WHEN sp.type='S' THEN sl.is_expiration_checked END AS password_expiration_checked
FROM sys.server_principals AS sp
LEFT JOIN sys.sql_logins AS sl ON sl.principal_id=sp.principal_id
WHERE sp.type IN ('S','U','G')
  AND sp.name NOT LIKE '##MS_%##'
ORDER BY sp.type_desc,sp.name;
