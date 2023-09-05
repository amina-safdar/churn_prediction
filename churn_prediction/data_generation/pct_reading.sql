WITH 
    num_metric AS (
	    SELECT 
            account_id, 
            metric_time, 
            metric_value as num_value
	    FROM churn.metric JOIN churn.metric_info
            ON metric.metric_id = metric_info.metric_id
	            AND metric_info.metric_name = 'ReadingOwnedBook_per_quarter' 
                AND metric_time BETWEEN '2020-02-22' and '2020-06-01'), 
    den_metric AS (
	    SELECT 
            account_id, 
            metric_time, 
            metric_value as den_value
        FROM churn.metric JOIN churn.metric_info 
            ON metric.metric_id = metric_info.metric_id
	            AND metric_info.metric_name = 'total_events_per_quarter'
	            AND metric_time BETWEEN '2020-02-22' AND '2020-06-01')

INSERT INTO churn.metric (account_id, metric_time, metric_id, metric_value)
SELECT 
    den_metric.account_id, 
    den_metric.metric_time, 
    13,
	CASE 
        WHEN den_value > 0 THEN COALESCE(num_value, 0.0)/den_value
	    ELSE 0
    END AS metric_value
FROM den_metric  LEFT OUTER JOIN num_metric
	ON num_metric.account_id = den_metric.account_id
	    AND num_metric.metric_time = den_metric.metric_time
ON CONFLICT DO NOTHING;
