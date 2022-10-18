set nocount on;
declare @base_name nvarchar(128), @base_id int;
declare bases cursor for select name, database_id from sys.databases Y where state = 0 AND (
	database_id > 4
)
order by database_id

open bases

fetch next from bases into @base_name, @base_id

while @@FETCH_STATUS = 0
begin
	print @base_name
	DBCC SHRINKDATABASE(@base_name)

	fetch next from bases into @base_name, @base_id
end

close bases
deallocate bases