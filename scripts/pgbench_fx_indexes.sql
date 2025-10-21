-- adding indexes to support pgbench_fk relationships
CREATE INDEX ON pgbench_accounts (bid);
CREATE INDEX ON pgbench_tellers  (bid);
CREATE INDEX ON pgbench_history  (aid);
CREATE INDEX ON pgbench_history  (tid);
CREATE INDEX ON pgbench_history  (bid);

