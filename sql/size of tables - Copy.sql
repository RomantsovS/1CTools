use ERP_TEST_FOR_CI_Template

--declare some_cursor cursor for
SELECT top 100
	--(row_number() over(order by a3.name, a2.name))%2 as l1,
	--a3.name AS [schemaname],
	a1.rows as row_count,
	a2.name AS [tablename],
	(a1.reserved + ISNULL(a4.reserved,0))* 8 AS reserved, 
	a1.data * 8 AS data,
	(CASE WHEN (a1.used + ISNULL(a4.used,0)) > a1.data THEN (a1.used + ISNULL(a4.used,0)) - a1.data ELSE 0 END) * 8 AS index_size,
	(CASE WHEN (a1.reserved + ISNULL(a4.reserved,0)) > a1.used THEN (a1.reserved + ISNULL(a4.reserved,0)) - a1.used ELSE 0 END) * 8 AS unused
FROM
	(SELECT 
		ps.object_id,
		SUM (
			CASE
				WHEN (ps.index_id < 2) THEN row_count
				ELSE 0
			END
			) AS [rows],
		SUM (ps.reserved_page_count) AS reserved,
		SUM (
			CASE
				WHEN (ps.index_id < 2) THEN (ps.in_row_data_page_count + ps.lob_used_page_count + ps.row_overflow_used_page_count)
				ELSE (ps.lob_used_page_count + ps.row_overflow_used_page_count)
			END
			) AS data,
		SUM (ps.used_page_count) AS used
	FROM sys.dm_db_partition_stats ps
	WHERE ps.row_count > 1
	GROUP BY ps.object_id) AS a1
LEFT OUTER JOIN 
	(SELECT 
		it.parent_id,
		SUM(ps.reserved_page_count) AS reserved,
		SUM(ps.used_page_count) AS used
	 FROM sys.dm_db_partition_stats ps
	 INNER JOIN sys.internal_tables it ON (it.object_id = ps.object_id)
	 WHERE it.internal_type IN (202,204)
	 GROUP BY it.parent_id) AS a4 ON (a4.parent_id = a1.object_id)
INNER JOIN sys.all_objects a2  ON ( a1.object_id = a2.object_id ) 
INNER JOIN sys.schemas a3 ON (a2.schema_id = a3.schema_id)
WHERE a2.type <> N'S' and a2.type <> N'IT' --and a2.name LIKE '%doc%'
ORDER BY a1.data desc, a1.rows desc, a3.name, a2.name
/*
open some_cursor
-- курсор создан, обьявляем переменные и обходим набор строк в цикле
declare  @counter int
declare  @int_var int, @string_var varchar(100)
set @counter = 0

-- выборка первой  строки
fetch next from some_cursor INTO  @int_var, @string_var
-- цикл с логикой и выборкой всех последующих строк после первой
while @@FETCH_STATUS = 0
begin
--- логика внутри цикла
set @counter = @counter + 1
 if @counter >= 10 break  -- возможный код для проверки работы, прерываем после пятой итерации

 print @string_var
 print @int_var
 DECLARE @query nvarchar(250)
        SET @query = 'TRUNCATE TABLE ' + @string_var 
        EXECUTE (@query)

-- выборка следующей строки
fetch next from some_cursor INTO  @int_var, @string_var
-- завершение логики внутри цикла
end
-- закрываем курсор
close some_cursor
deallocate some_cursor
*/