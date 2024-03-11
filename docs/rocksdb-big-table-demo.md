

Simple big table script
```
create table big_table(id int,filler varchar(100) default '0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789');
create index big_table_id on big_table(id);
\d big_table
insert into big_table(id) SELECT generate_series(1,100000);
\timing on
analyze big_table;
explain analyze select filler from big_table where id = 80000;
insert into big_table(id) SELECT generate_series(1,100000);
insert into big_table(id) SELECT generate_series(1,100000);
insert into big_table(id) SELECT generate_series(1,100000);
analyze big_table;
explain analyze select filler from big_table where id = 80000;
```

Running this manualling
```
postgres=# create table big_table(id int,filler varchar(100) default '0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789');
CREATE TABLE
postgres=# create index big_table_id on big_table(id);
CREATE INDEX
postgres=# \d big_table
                                                                              Table "public.big_table"
 Column |          Type          | Collation | Nullable |                                                          Default

--------+------------------------+-----------+----------+--------------------------------------------------------------------------------------------------------------------------
-
 id     | integer                |           |          |
 filler | character varying(100) |           |          | '0123456789012345678901234567890123456789012345678901234567890123456789012345678901234567890123456789'::character varying
Indexes:
    "big_table_id" btree (id)

postgres=# insert into big_table(id) SELECT generate_series(1,100000);
INSERT 0 100000
postgres=# \timing on
Timing is on.
postgres=# analyze big_table;
ANALYZE
Time: 133.403 ms
postgres=# explain analyze select filler from big_table where id = 80000;
                                                        QUERY PLAN
--------------------------------------------------------------------------------------------------------------------------
 Index Scan using big_table_id on big_table  (cost=0.29..8.31 rows=1 width=101) (actual time=0.427..0.467 rows=1 loops=1)
   Index Cond: (id = 80000)
 Planning Time: 5.248 ms
 Execution Time: 0.889 ms
(4 rows)

Time: 23.246 ms
postgres=# insert into big_table(id) SELECT generate_series(1,100000);
INSERT 0 100000
Time: 1334.239 ms (00:01.334)
postgres=# insert into big_table(id) SELECT generate_series(1,100000);
INSERT 0 100000
Time: 1395.525 ms (00:01.396)
postgres=# insert into big_table(id) SELECT generate_series(1,100000);
\INSERT 0 100000
Time: 1510.484 ms (00:01.510)
postgres=# analyze big_table;
ANALYZE
Time: 423.556 ms
```

Execution Plan and Stats looks healthy

```
postgres=# explain analyze select filler from big_table where id = 80000;
                                                        QUERY PLAN
---------------------------------------------------------------------------------------------------------------------------
 Index Scan using big_table_id on big_table  (cost=0.42..19.76 rows=4 width=101) (actual time=0.316..0.488 rows=4 loops=1)
   Index Cond: (id = 80000)
 Planning Time: 4.271 ms
 Execution Time: 0.944 ms
(4 rows)

Time: 17.258 ms
```


