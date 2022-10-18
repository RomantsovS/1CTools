select top 100
p.dbid,
db_name(p.dbid) as db_name,
t.text,
p.query_plan,
s.*
from sys.dm_exec_query_stats s
OUTER APPLY sys.dm_exec_sql_text(s.sql_handle) t
OUTER APPLY sys.dm_exec_query_plan(s.plan_handle) p

--order by total_physical_reads desc
order by total_worker_time desc
