truncate table _Reference50620X1
truncate table _InfoRg19279
truncate table _DataHistoryQueue0

DECLARE @sql NVARCHAR(MAX)
set @sql='alter database '+quotename(db_name())+' SET RECOVERY SIMPLE';
exec(@sql)

DECLARE @dbName VARCHAR(50)

SELECT @dbName = DB_NAME()

DBCC SHRINKDATABASE(@dbName)