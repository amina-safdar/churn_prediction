WITH last_measurement AS (
    SELECT MAX(metric_time) AS last_metric_at
    FROM churn.metric)

SELECT
	account_id,
	metric_time,
	SUM(CASE WHEN metric_id = 9 THEN metric_value ELSE 0 END) AS ReadingOwnedBook,
	SUM(CASE WHEN metric_id = 6 THEN metric_value ELSE 0 END) AS EBookDownloaded,
	SUM(CASE WHEN metric_id = 5 THEN metric_value ELSE 0 END) AS ReadingFreePreview,
	SUM(CASE WHEN metric_id = 4 THEN metric_value ELSE 0 END) AS HighlightCreated,
	SUM(CASE WHEN metric_id = 3 THEN metric_value ELSE 0 END) AS FreeContentCheckout,
	SUM(CASE WHEN metric_id = 2 THEN metric_value ELSE 0 END) AS ReadingOpenChapter,
	SUM(CASE WHEN metric_id = 1 THEN metric_value ELSE 0 END) AS ProductTocLivebookLinkOpened,
	SUM(CASE WHEN metric_id = 0 THEN metric_value ELSE 0 END) AS LivebookLogin
FROM churn.metric
JOIN last_measurement ON
    metric_time = last_metric_at
GROUP BY account_id, metric_time
ORDER BY account_id;
