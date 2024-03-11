\set aid random(1, 100)
UPDATE pgbench_accounts SET abalance=abalance+1  WHERE aid = :aid

