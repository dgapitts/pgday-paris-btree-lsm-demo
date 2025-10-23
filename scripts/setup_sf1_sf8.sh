# create empty DBs
psql -f create_database_sf1_s8.sql

# sf1 setup pgbench with foreign-keys and supporting indexes
pgbench -i -s 1 --foreign-keys -d sf1
psql -d sf1 -f pgbench_secondary_indexes.sql

# sf2 setup pgbench with foreign-keys and supporting indexes
pgbench -i -s 2 --foreign-keys -d sf2
psql -d sf2 -f pgbench_secondary_indexes.sql

# sf4 setup pgbench with foreign-keys and supporting indexes
pgbench -i -s 4 --foreign-keys -d sf4
psql -d sf4 -f pgbench_secondary_indexes.sql

# sf8 setup pgbench with foreign-keys and supporting indexes
pgbench -i -s 8 --foreign-keys -d sf8
psql -d sf8 -f pgbench_secondary_indexes.sql
