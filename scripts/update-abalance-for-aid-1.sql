\set aid random(1, 1)
UPDATE pgbench_accounts SET abalance=abalance+1  WHERE aid = :aid

