# Intro to B-Trees - part one

## setup sf1, sf2, sf4 and sf8

This only takes a few seconds to setup
```
~/projects/pgday-paris-btree-lsm-demo/scripts main $ ./setup_sf1_sf8.sh
CREATE DATABASE
CREATE DATABASE
CREATE DATABASE
CREATE DATABASE
dropping old tables...
NOTICE:  table "pgbench_accounts" does not exist, skipping
NOTICE:  table "pgbench_branches" does not exist, skipping
NOTICE:  table "pgbench_history" does not exist, skipping
NOTICE:  table "pgbench_tellers" does not exist, skipping
creating tables...
generating data (client-side)...
100000 of 100000 tuples (100%) done (elapsed 0.11 s, remaining 0.00 s)
vacuuming...
creating primary keys...
creating foreign keys...
done in 0.16 s (drop tables 0.00 s, create tables 0.00 s, client-side generate 0.11 s, vacuum 0.02 s, primary keys 0.02 s, foreign keys 0.01 s).
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
dropping old tables...
NOTICE:  table "pgbench_accounts" does not exist, skipping
NOTICE:  table "pgbench_branches" does not exist, skipping
NOTICE:  table "pgbench_history" does not exist, skipping
NOTICE:  table "pgbench_tellers" does not exist, skipping
creating tables...
generating data (client-side)...
200000 of 200000 tuples (100%) done (elapsed 0.28 s, remaining 0.00 s)
vacuuming...
creating primary keys...
creating foreign keys...
done in 0.38 s (drop tables 0.00 s, create tables 0.00 s, client-side generate 0.29 s, vacuum 0.03 s, primary keys 0.04 s, foreign keys 0.01 s).
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
dropping old tables...
NOTICE:  table "pgbench_accounts" does not exist, skipping
NOTICE:  table "pgbench_branches" does not exist, skipping
NOTICE:  table "pgbench_history" does not exist, skipping
NOTICE:  table "pgbench_tellers" does not exist, skipping
creating tables...
generating data (client-side)...
400000 of 400000 tuples (100%) done (elapsed 0.48 s, remaining 0.00 s)
vacuuming...
creating primary keys...
creating foreign keys...
done in 0.70 s (drop tables 0.00 s, create tables 0.00 s, client-side generate 0.48 s, vacuum 0.07 s, primary keys 0.13 s, foreign keys 0.03 s).
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
dropping old tables...
NOTICE:  table "pgbench_accounts" does not exist, skipping
NOTICE:  table "pgbench_branches" does not exist, skipping
NOTICE:  table "pgbench_history" does not exist, skipping
NOTICE:  table "pgbench_tellers" does not exist, skipping
creating tables...
generating data (client-side)...
800000 of 800000 tuples (100%) done (elapsed 1.12 s, remaining 0.00 s)
vacuuming...
creating primary keys...
creating foreign keys...
done in 1.52 s (drop tables 0.00 s, create tables 0.00 s, client-side generate 1.12 s, vacuum 0.09 s, primary keys 0.26 s, foreign keys 0.05 s).
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
CREATE INDEX
```

and uses about 265Mb in total (plus some WAL files) 
```
davidpitts=# SELECT
    datname AS database_name,
    pg_size_pretty(pg_database_size(datname)) AS size
FROM pg_database
WHERE datname LIKE 'sf%'
ORDER BY pg_database_size(datname) ASC;
 database_name |  size
---------------+--------
 sf1           | 23 MB
 sf2           | 39 MB
 sf4           | 70 MB
 sf8           | 133 MB
(4 rows)
```

## Lookup by PK costs are pretty flat


* sf1 -  3 buffer reads ( 1 data page and 2 index pages - implicit )

``` 
sf1=# explain (analyze,buffers) select * from pgbench_accounts where aid=4242;
                                                               QUERY PLAN
-----------------------------------------------------------------------------------------------------------------------------------------
 Index Scan using pgbench_accounts_pkey on pgbench_accounts  (cost=0.29..8.31 rows=1 width=97) (actual time=0.067..0.069 rows=1 loops=1)
   Index Cond: (aid = 4242)
   Buffers: shared hit=3
 Planning Time: 0.162 ms
 Execution Time: 0.169 ms
(5 rows)
```

* sf2 -  4 buffer reads ( 1 data page and 3 index pages - implicit )

```
sf2=# explain (analyze,buffers) select * from pgbench_accounts where aid=4242;
                                                               QUERY PLAN
-----------------------------------------------------------------------------------------------------------------------------------------
 Index Scan using pgbench_accounts_pkey on pgbench_accounts  (cost=0.42..8.44 rows=1 width=97) (actual time=0.031..0.033 rows=1 loops=1)
   Index Cond: (aid = 4242)
   Buffers: shared hit=4
 Planning Time: 0.147 ms
 Execution Time: 0.054 ms
(5 rows)
```

* sf4 -  3 buffer reads ( 1 data page and 2 index pages - implicit )

```
sf4=# explain (analyze,buffers) select * from pgbench_accounts where aid=4242;
                                                               QUERY PLAN
-----------------------------------------------------------------------------------------------------------------------------------------
 Index Scan using pgbench_accounts_pkey on pgbench_accounts  (cost=0.42..8.44 rows=1 width=97) (actual time=0.029..0.030 rows=1 loops=1)
   Index Cond: (aid = 4242)
   Buffers: shared hit=4
 Planning:
   Buffers: shared hit=83
 Planning Time: 1.590 ms
 Execution Time: 0.090 ms
(7 rows)
```

* sf8 -  3 buffer reads ( 1 data page and 2 index pages - implicit )

```
sf8=# explain (analyze,buffers) select * from pgbench_accounts where aid=4242;
                                                               QUERY PLAN
-----------------------------------------------------------------------------------------------------------------------------------------
 Index Scan using pgbench_accounts_pkey on pgbench_accounts  (cost=0.42..8.44 rows=1 width=97) (actual time=0.046..0.048 rows=1 loops=1)
   Index Cond: (aid = 4242)
   Buffers: shared hit=4
 Planning Time: 0.225 ms
 Execution Time: 0.083 ms
(5 rows)
```
