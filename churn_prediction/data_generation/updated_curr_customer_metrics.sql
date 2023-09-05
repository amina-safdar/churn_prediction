WITH last_measurement AS (
    SELECT MAX(metric_time) AS last_metric_at
    FROM churn.metric)

SELECT
	account_id,
	metric_time,
	SUM(CASE WHEN metric_id = 10 THEN metric_value ELSE 0 END) AS total_events_per_quarter,
	SUM(CASE WHEN metric_id = 11 THEN metric_value ELSE 0 END) AS uniq_prod_ct_per_quarter,
    SUM(CASE WHEN metric_id = 12 THEN metric_value ELSE 0 END) AS total_freebies_per_quarter,
    SUM(CASE WHEN metric_id = 13 THEN metric_value ELSE 0 END) AS pct_reading_per_quarter,
    SUM(CASE WHEN metric_id = 14 THEN metric_value ELSE 0 END) AS pct_downloads_per_quarter
FROM churn.metric
JOIN last_measurement ON
    metric_time = last_metric_at
GROUP BY account_id, metric_time
ORDER BY account_id;
