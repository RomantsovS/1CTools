select
qs.session_id,
qs.blocking_session_id,
qs.status,
[IO] = reads + writes,
cpu_time,
wait_resource,
wait_time,
wait_type,
qt.text as Query,
DB_NAME(qs.database_id) as DatabaseName,
qp.query_plan,
qs.*
from sys.dm_exec_requests qs
OUTER APPLY sys.dm_exec_sql_text(qs.sql_handle) qt
OUTER APPLY sys.dm_exec_query_plan(qs.sql_handle) qp
where qs.status in ('running', 'suspended', 'runnable')
order by [IO] desc