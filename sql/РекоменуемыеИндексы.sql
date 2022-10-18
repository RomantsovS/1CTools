SELECT 
		DB_NAME(mid.database_id) as [�������],
		migs.unique_compiles as [�������������],
		migs.user_seeks as [�����������������],
		migs.user_scans as [��������������������],
		migs.last_user_seek as last_user_seek,
		round(migs.avg_total_user_cost, 2) as [����������������],
		CAST(migs.avg_user_impact AS int) as [����������������������],
		OBJECT_NAME(mid.object_id,mid.database_id) as [��������������],
		cast(migs.avg_user_impact*(migs.user_seeks+migs.user_scans) as int) as [����������������������������],
		round(migs.avg_user_impact*(migs.user_seeks+migs.user_scans) * migs.avg_total_user_cost, 0) as [����������������������������1],
		'CREATE INDEX [IX_' +OBJECT_NAME(mid.object_id,mid.database_id) + '_'
		+ REPLACE(REPLACE(REPLACE(ISNULL(mid.equality_columns,''),', ','_'),'[',''),']','') +
		CASE
		WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT NULL THEN '_'
		ELSE ''
		END
		+ REPLACE(REPLACE(REPLACE(ISNULL(mid.inequality_columns,''),', ','_'),'[',''),']','')
		+ ']'
		+ ' ON ' + mid.statement
		+ ' (' + ISNULL (mid.equality_columns,'')
		+ CASE WHEN mid.equality_columns IS NOT NULL AND mid.inequality_columns IS NOT NULL THEN ',' ELSE
		'' END
		+ ISNULL (mid.inequality_columns, '')
		+ ')'
		+ ISNULL (' INCLUDE (' + mid.included_columns + ')', '') AS [�������������������],
		mid.inequality_columns,
		mid.equality_columns,
		mid.included_columns
		FROM sys.dm_db_missing_index_groups mig
		JOIN sys.dm_db_missing_index_group_stats migs
		ON migs.group_handle = mig.index_group_handle
		JOIN sys.dm_db_missing_index_details mid
		ON mig.index_handle = mid.index_handle
		WHERE 
		 migs.avg_user_impact*(migs.user_seeks+migs.user_scans) > 1
		 --AND CAST(migs.avg_total_user_cost AS int) < 10
		 AND mid.database_id = DB_ID()
		--and OBJECT_NAME(mid.object_id,mid.database_id) like '%_Reference%'
		--and mid.equality_columns like '%878%'
		ORDER BY [����������������������������1] desc