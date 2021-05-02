use [BUH-TEST-RKK]

SELECT TOP 100
		 object_name(ps.OBJECT_ID) AS [ИмяТаблицыSQL],
		 Index_Description = CASE
						   WHEN ps.index_id = 1 THEN 'Clustered Index'
						   WHEN ps.index_id <> 1 THEN 'Non-Clustered Index'
							 END,
		  b.name AS [ИмяИндекса],
		 ROUND(ps.avg_fragmentation_in_percent,2,1) AS [ПроцентФрагментации],
	   SUM(page_count*8) AS [РазмерДанных],
		  ps.page_count
	FROM sys.dm_db_index_physical_stats (DB_ID(),NULL,NULL,NULL,NULL) AS ps
	INNER JOIN sys.indexes AS b ON ps.object_id = b.object_id AND ps.index_id = b.index_id AND b.index_id <> 0 
	INNER JOIN sys.objects AS O ON O.object_id=b.object_id AND O.type='U' AND O.is_ms_shipped=0 
	INNER JOIN sys.schemas AS S ON S.schema_Id=O.schema_id
	WHERE ps.database_id = DB_ID() and ps.avg_fragmentation_in_percent >= 0
	--and object_name(ps.OBJECT_ID) = '_AccRgED7575'
	GROUP BY db_name(ps.database_id),S.name,object_name(ps.OBJECT_ID),CASE WHEN ps.index_id = 1 THEN 'Clustered Index' WHEN ps.index_id <> 1 THEN 'Non-Clustered Index' END,b.name,ROUND(ps.avg_fragmentation_in_percent,0,1),ps.avg_fragmentation_in_percent,ps.page_count
	HAVING SUM(page_count*8) > 10000
	ORDER BY ps.avg_fragmentation_in_percent DESC
	
	/*
declare @table_name nvarchar(120);
declare tables_to_reindex cursor for SELECT TOP 100
		 object_name(ps.OBJECT_ID) AS [ИмяТаблицыSQL]
	FROM sys.dm_db_index_physical_stats (DB_ID(),NULL,NULL,NULL,NULL) AS ps
	INNER JOIN sys.indexes AS b ON ps.object_id = b.object_id AND ps.index_id = b.index_id AND b.index_id <> 0 
	INNER JOIN sys.objects AS O ON O.object_id=b.object_id AND O.type='U' AND O.is_ms_shipped=0 
	INNER JOIN sys.schemas AS S ON S.schema_Id=O.schema_id
	WHERE ps.database_id = DB_ID() and ps.avg_fragmentation_in_percent >= 10
	and object_name(ps.OBJECT_ID) = '_Reference71343'
	GROUP BY db_name(ps.database_id),S.name,object_name(ps.OBJECT_ID),CASE WHEN ps.index_id = 1 THEN 'Clustered Index' WHEN ps.index_id <> 1 THEN 'Non-Clustered Index' END,b.name,ROUND(ps.avg_fragmentation_in_percent,0,1),ps.avg_fragmentation_in_percent,ps.page_count
	--HAVING SUM(page_count*8) > 20000
	ORDER BY ps.avg_fragmentation_in_percent DESC


open tables_to_reindex

fetch next from tables_to_reindex into @table_name

while @@FETCH_STATUS = 0
begin
	DBCC INDEXDEFRAG(0, @table_name) WITH NO_INFOMSGS 
	SELECT @Command = 'ALTER INDEX [' + @IndexName + '] ON ' + '[' + @SchemaName + ']' + '.[' + @TableName + '] REBUILD';
	select @info = @info + ' REBUILD WITH (MAXDOP = 8)'
	
	ALTER INDEX ALL ON Production.Product
	REBUILD WITH (FILLFACTOR = 80, SORT_IN_TEMPDB = ON,
	STATISTICS_NORECOMPUTE = ON);

	print @info

	fetch next from tables_to_reindex into @table_name
end

close tables_to_reindex
deallocate tables_to_reindex
*/