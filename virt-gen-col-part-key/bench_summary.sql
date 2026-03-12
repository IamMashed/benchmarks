-- Summarize the sizes properly adjusted per row count
SELECT
    'Physical Partitioning' AS method,
    (SELECT COUNT(*) FROM logs_physical) AS row_count,
    pg_size_pretty(SUM(pg_total_relation_size(inhrelid))) AS total_disk_size,
    (SUM(pg_total_relation_size(inhrelid)) / (SELECT NULLIF(COUNT(*), 0) FROM logs_physical)) AS bytes_per_row
FROM pg_inherits WHERE inhparent = 'logs_physical'::regclass
UNION ALL
SELECT
    'Virtual Partitioning' AS method,
    (SELECT COUNT(*) FROM logs_virtual) AS row_count,
    pg_size_pretty(SUM(pg_total_relation_size(inhrelid))) AS total_disk_size,
    (SUM(pg_total_relation_size(inhrelid)) / (SELECT NULLIF(COUNT(*), 0) FROM logs_virtual)) AS bytes_per_row
FROM pg_inherits WHERE inhparent = 'logs_virtual'::regclass;
