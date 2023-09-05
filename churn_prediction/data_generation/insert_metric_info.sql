INSERT INTO churn.metric_info VALUES (%(metric_id)s, %(metric_name)s)
ON CONFLICT DO NOTHING;
