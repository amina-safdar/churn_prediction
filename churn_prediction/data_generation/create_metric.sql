CREATE TABLE IF NOT EXISTS  churn.metric (
    account_id VARCHAR COLLATE pg_catalog."default" NOT NULL,
    metric_time TIMESTAMP(6) NOT NULL,
    metric_id NUMERIC NOT NULL,
    metric_value DECIMAL)
 
TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS  idx_metric_account_id
    ON churn.metric USING btree
    (account_id)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX IF NOT EXISTS  idx_metric_account_id_time
    ON churn.metric USING btree
    (account_id, metric_id, metric_time)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS  idx_metric_time_name
    ON churn.metric USING btree
    (metric_time, metric_id)
    TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS  idx_metric_id
    ON churn.metric USING btree
    (metric_id)
    TABLESPACE pg_default;
