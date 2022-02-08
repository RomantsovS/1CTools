SELECT pg_database.datname as "database_name",
pg_size_pretty(pg_database_size(pg_database.datname)) AS size
from
pg_database
ORDER by pg_database_size(pg_database.datname) DESC;
