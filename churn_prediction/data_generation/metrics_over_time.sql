WITH
    calculation_period AS (     
	    SELECT calc_at::timestamp
        FROM generate_series(%(from_yyyy-mm-dd)s, %(to_yyyy-mm-dd)s, '28 days'::interval) AS calc_at), 
    metric AS (  
        SELECT *
        FROM churn.metric  
        INNER JOIN churn.metric_info 
            ON metric.metric_id = metric_info.metric_id
        WHERE metric_info.metric_name = %(specified_metric)s)

SELECT
    calc_at,  
    AVG(metric_value), 
    COUNT(metric.*) AS count_with_metric,
    MIN(metric_value), 
    MAX(metric_value)    
FROM calculation_period
LEFT JOIN metric
    ON calc_at = metric_time     
GROUP BY calc_at    
ORDER BY calc_at;
