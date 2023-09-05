WITH
    calculation_period AS (
        SELECT
            %(from_yyyy-mm-dd)s::timestamp AS start_at,
            %(to_yyyy-mm-dd)s::timestamp AS end_at), 
    account_count AS (
		-- Calculate total number of accounts active within the `calculation_period`
        SELECT
            COUNT(DISTINCT account_id) AS account_count
        FROM churn.event, calculation_period
        WHERE event_time BETWEEN start_at AND end_at)

SELECT
	metric_name, 
	COUNT(DISTINCT metric.account_id) as count_with_metric,
	account_count,    
	100 * COUNT(DISTINCT metric.account_id)::float/account_count
		AS pct_with_metric,
	AVG(metric_value) as avg_value,    
	MIN(metric_value) as min_value,    
	MAX(metric_value) as max_value,
	MIN(metric_time)  as first_value,
	MAX(metric_time) as last_value
FROM churn.metric
	CROSS JOIN account_count
	INNER JOIN calculation_period ON 
		metric_time BETWEEN start_at AND end_at
	INNER JOIN churn.metric_info
		ON metric.metric_id = metric_info.metric_id
GROUP BY metric_name, account_count
ORDER BY metric_name;
