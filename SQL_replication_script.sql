SELECT compatibility_level  
FROM sys.databases WHERE name = 'employee';  
GO  

ALTER DATABASE employee 
SET COMPATIBILITY_LEVEL = 110;  
GO  


EXEC master.dbo.sp_addlinkedserver @server = N'loopback', @srvproduct=N'',
 @provider=N'SQLNCLI', @datasrc=@@SERVERNAME

 EXEC master.dbo.sp_serveroption @server=N'loopback', 
@optname=N'data access', @optvalue=N'true'

select @@SERVERNAME

select SERVERPROPERTY(N'servername')

 sp_dropserver 'LDTECHDB01\MSSQLSERVER2' 
 go 

sp_addserver 'LDTECHDB01\MSSQLSERVER2', 'local'

USE master
GO
xp_readerrorlog 0, 1, N'Server is listening on' 
GO