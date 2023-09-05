WITH date_vals AS (
	SELECT i::timestamp AS metric_date
	FROM generate_series('2020-02-22', '2020-06-01', '28 day'::interval) i)

INSERT INTO churn.metric (account_id, metric_time, metric_id, metric_value)	
	SELECT 
		account_id, 
		metric_date, 
		10,  
		COUNT(*) AS metric_value
FROM churn.event JOIN date_vals
	ON event.event_time < metric_date 
		AND event.event_time >= metric_date - interval '84 days'
GROUP BY account_id, metric_date
ON CONFLICT DO NOTHING;
