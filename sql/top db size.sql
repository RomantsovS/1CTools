select SUM(size * 8.0 / 1024) as [Size, Mb]
from sys.master_files

select DB_Name(database_id) as [Database Name], SUM(size * 8.0 / 1024) as [Size, Mb]
from sys.master_files
GROUP BY database_id
order by [Size, Mb] desc