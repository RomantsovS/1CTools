select current_database() as database,
       pg_size_pretty(total_database_size) as total_database_size,
       schema_name,
       table_name,
       pg_size_pretty(total_table_size) as total_table_size,
       pg_size_pretty(table_size) as table_size,
       pg_size_pretty(index_size) as index_size
       from ( select table_name,
                table_schema as schema_name,
                pg_database_size(current_database()) as total_database_size,
                pg_total_relation_size(quote_ident(table_name)) as total_table_size,
                pg_relation_size(quote_ident(table_name)) as table_size,
                pg_indexes_size(quote_ident(table_name)) as index_size
                from information_schema.tables
                where table_schema=current_schema() --and table_name like 'table_%'
                order by total_table_size desc 
                limit 20
            ) as sizes;