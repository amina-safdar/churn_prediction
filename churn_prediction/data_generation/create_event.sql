CREATE TABLE IF NOT EXISTS  churn.event (
    account_id VARCHAR COLLATE pg_catalog."default" NOT NULL,
    event_time timestamp(6) without time zone NOT NULL,
    event_type VARCHAR COLLATE pg_catalog."default" NOT NULL,
    product_id integer,
    additional_data VARCHAR COLLATE pg_catalog."default")

TABLESPACE pg_default;

CREATE INDEX  IF NOT EXISTS  idx_account_id
    ON churn.event USING btree
    (account_id)
    TABLESPACE pg_default;

CREATE INDEX  IF NOT EXISTS  idx_account_time
    ON churn.event USING btree
    (account_id, event_time)
    TABLESPACE pg_default;

CREATE INDEX  IF NOT EXISTS  idx_event_time
    ON churn.event USING btree
    (event_time)
    TABLESPACE pg_default;

CREATE INDEX  IF NOT EXISTS  idx_event_type
    ON churn.event USING btree
    (event_type)
    TABLESPACE pg_default;
