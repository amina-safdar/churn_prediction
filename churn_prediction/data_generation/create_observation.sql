CREATE TABLE IF NOT EXISTS churn.observation (
    account_id VARCHAR COLLATE pg_catalog."default" NOT NULL,
    observation_date DATE NOT NULL,
    is_churn BOOLEAN NULL)

TABLESPACE pg_default;

CREATE INDEX IF NOT EXISTS observation_date_idx
    ON churn.observation USING btree
    (observation_date)
    TABLESPACE pg_default;

CREATE UNIQUE INDEX IF NOT EXISTS account_id_observation_date_idx
    ON churn.observation USING btree
    (account_id, observation_date)
    TABLESPACE pg_default;
