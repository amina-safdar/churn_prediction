WITH 
    book_purchases AS (
        SELECT DISTINCT
            account_id, 
            product_id,
            MIN(event_time) AS min_time
        FROM churn.event
        WHERE event_type IN ('ReadingOwnedBook', 'EbookDownloaded')
        GROUP BY account_id, product_id), 
    before_mar AS (
        SELECT DISTINCT account_id
        FROM book_purchases
        WHERE min_time BETWEEN '2019-12-01' AND '2020-02-29'),
    after_mar AS (
        SELECT DISTINCT account_id
        FROM book_purchases
        WHERE min_time BETWEEN '2020-03-01' AND '2020-05-31')

INSERT INTO churn.observation (account_id, observation_date, is_churn)
	SELECT
        before_mar.account_id,
        '2020-03-01',
        CASE 
            WHEN after_mar.account_id IS NULL THEN TRUE
            ELSE FALSE 
        END AS is_churn
    FROM before_mar
    LEFT JOIN after_mar ON
        before_mar.account_id = after_mar.account_id
