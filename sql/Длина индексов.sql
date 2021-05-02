use romantsov_s_admin1c

SELECT OBJECT_NAME(ic.object_id) AS “аблица, SUM(sys.columns.max_length) AS [ƒлина»ндекса], i.name AS »ндекс

FROM sys.indexes AS i INNER JOIN
    sys.index_columns AS ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id INNER JOIN
    sys.columns ON ic.column_id = sys.columns.column_id AND ic.object_id = sys.columns.object_id
--where OBJECT_NAME(ic.object_id)  like '%reference%'
GROUP BY OBJECT_NAME(ic.object_id), i.name, sys.columns.name
ORDER BY [ƒлина»ндекса] DESC