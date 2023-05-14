WITH
    measurement_period AS (
        SELECT measurement_at::timestamp
        FROM generate_series(%(from_yyyy-mm-dd)s, %(to_yyyy-mm-dd)s, '1 day'::interval) AS measurement_at),
    event_of_type AS (
        SELECT *
        FROM churn.event
        WHERE event_type = %(event_type)s)

SELECT 
    DATE(measurement_at) AS measurement_date,
    COUNT(*) AS event_count
FROM measurement_period
LEFT JOIN event_of_type ON 
    event_of_type.event_time::date = measurement_period.measurement_at
GROUP BY measurement_at
ORDER BY measurement_at;
