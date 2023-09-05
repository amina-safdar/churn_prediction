CREATE TABLE IF NOT EXISTS churn.metric_info (
    metric_id NUMERIC NOT NULL,
    metric_name VARCHAR COLLATE pg_catalog."default")
 
TABLESPACE pg_default;

CREATE UNIQUE INDEX IF NOT EXISTS idx_metric_info_id
    ON churn.metric_info USING btree
    (metric_id)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX IF NOT EXISTS idx_metric_info_name
    ON churn.metric_info USING btree
    (metric_name)
    TABLESPACE pg_default;
