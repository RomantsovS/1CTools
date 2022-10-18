--EXEC sp_updatestats;

DECLARE @DateNow DATETIME
SELECT @DateNow = DATEADD(dd, 0, DATEDIFF(dd, 0, GETDATE()))

select --top 100
o.name table_name,
ind.name index_name,
s.name stat_name,
STATS_DATE(s.[object_id], s.stats_id) stat_date
FROM sys.stats s WITH(NOLOCK)
	JOIN sys.objects o WITH(NOLOCK) ON s.[object_id] = o.[object_id]
	JOIN sys.indexes ind ON o.object_id = ind.object_id
	WHERE o.[type] IN ('U', 'V')
		AND o.is_ms_shipped = 0
		--AND o.name like '%2809%'
		--AND ISNULL(STATS_DATE(s.[object_id], s.stats_id), GETDATE()) <= @DateNow
	--group by o.name, ind.name
	ORDER BY STATS_DATE(s.[object_id], s.stats_id)


	
DECLARE @SQL NVARCHAR(MAX)
SELECT @SQL = (
    SELECT TOP 100'
	UPDATE STATISTICS [' + SCHEMA_NAME(o.[schema_id]) + '].[' + o.name + '] [' + s.name + ']
		WITH FULLSCAN' + CASE WHEN s.no_recompute = 1 THEN ', NORECOMPUTE' ELSE '' END + ';'
	FROM sys.stats s WITH(NOLOCK)
	JOIN sys.objects o WITH(NOLOCK) ON s.[object_id] = o.[object_id]
	WHERE o.[type] IN ('U', 'V')
		AND o.is_ms_shipped = 0
		AND o.name = '_AccRgED7575'
		--AND ISNULL(STATS_DATE(s.[object_id], s.stats_id), GETDATE()) <= @DateNow
	ORDER BY STATS_DATE(s.[object_id], s.stats_id) 
    FOR XML PATH(''), TYPE).value('.', 'NVARCHAR(MAX)')

PRINT @SQL

--EXEC sys.sp_executesql @SQL
