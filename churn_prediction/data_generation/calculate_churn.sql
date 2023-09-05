 SELECT
    COUNT(*) AS total_customers, 
    SUM(is_churn::int) AS churned_customers,
    SUM(is_churn::int)/COUNT(*)::float AS pct_churned
 from churn.observation
