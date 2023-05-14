WITH
    measurement_period AS (
        SELECT
            '2019-12-01'::timestamp AS start_at,
            '2020-06-01'::timestamp AS end_at),
    -- account_count: number of accounts active in the measurement period
    account_count AS (
        SELECT
            COUNT(DISTINCT account_id) AS account_count
        FROM churn.event, measurement_period
        WHERE event_time BETWEEN start_at AND end_at)

SELECT 
    event_type,
    COUNT(*) AS event_count -- number of events logged in the measurement period,
    account_count,
    COUNT(*)::float/account_count AS events_per_account,
    -- 30.5 days/month average using months in the measurement period
    EXTRACT(DAYS FROM end_at - start_at)/30.5 AS month_count,
    COUNT(*)::float/account_count/
        (EXTRACT(DAYS FROM end_at - start_at)/30.5)
        AS events_per_account_per_month
FROM churn.event, measurement_period
    CROSS JOIN account_count
WHERE event_time BETWEEN start_at AND end_at
GROUP BY event_type, account_count, end_at, start_at
ORDER BY events_per_account_per_month DESC;
