truncate table _DataHistoryVersionsExtX1
truncate table _InfoRg1912
truncate table _Reference50
truncate table _Reference173
truncate table _Reference207X1
truncate table _InfoRg2216
truncate table _DataHistoryLatestVerExtX1

DECLARE @sql NVARCHAR(MAX)
set @sql='alter database '+quotename(db_name())+' SET RECOVERY SIMPLE';
exec(@sql)

DECLARE @dbName VARCHAR(50)

SELECT @dbName = DB_NAME()

DBCC SHRINKDATABASE(@dbName)