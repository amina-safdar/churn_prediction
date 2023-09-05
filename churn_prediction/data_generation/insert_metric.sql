WITH measurement_period AS (
	SELECT measurement_at::timestamp
	FROM generate_series(%(from_yyyy-mm-dd)s, %(to_yyyy-mm-dd)s, '28 days'::interval) AS measurement_at)

INSERT INTO churn.metric (account_id, metric_time, metric_id, metric_value)
	SELECT
		account_id, 
		measurement_at, 
		%(metric_id)s,  
		COUNT(*) AS event_count_per_quarter -- Informal quarter (12 wk)
	FROM churn.event 
	JOIN measurement_period ON 
        churn.event.event_time <= measurement_at
			AND churn.event.event_time >= measurement_at - interval '84 days'
	WHERE churn.event.event_type = %(event_type)s
	GROUP BY account_id, measurement_at
	ORDER BY account_id, measurement_at
	ON CONFLICT DO NOTHING;
