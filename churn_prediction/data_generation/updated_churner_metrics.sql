WITH observation_params AS (
	SELECT  
		interval '28 days' AS metric_period,
    		'2019-12-01'::timestamp AS obs_start,
    		'2020-06-01'::timestamp AS obs_end)

SELECT 
	metric.account_id, 
	churn_observation.observation_date, 
	is_churn,
    	SUM(CASE WHEN metric_id = 10 THEN metric_value ELSE 0 END) AS total_events,
	SUM(CASE WHEN metric_id = 11 THEN metric_value ELSE 0 END) AS uniq_prod_ct,
   	SUM(CASE WHEN metric_id = 12 THEN metric_value ELSE 0 END) AS total_freebies,
   	SUM(CASE WHEN metric_id = 13 THEN metric_value ELSE 0 END) AS pct_reading,
   	SUM(CASE WHEN metric_id = 14 THEN metric_value ELSE 0 END) AS pct_downloads_per_book,
	SUM(CASE WHEN metric_id = 9 THEN metric_value ELSE 0 END) AS ReadingOwnedBook,
	SUM(CASE WHEN metric_id = 6 THEN metric_value ELSE 0 END) AS EBookDownloaded,
	SUM(CASE WHEN metric_id = 5 THEN metric_value ELSE 0 END) AS ReadingFreePreview,
	SUM(CASE WHEN metric_id = 4 THEN metric_value ELSE 0 END) AS HighlightCreated,
	SUM(CASE WHEN metric_id = 3 THEN metric_value ELSE 0 END) AS FreeContentCheckout,
	SUM(CASE WHEN metric_id = 2 THEN metric_value ELSE 0 END) AS ReadingOpenChapter,
	SUM(CASE WHEN metric_id = 1 THEN metric_value ELSE 0 END) AS ProductTocLivebookLinkOpened,
	SUM(CASE WHEN metric_id = 0 THEN metric_value ELSE 0 END) AS LivebookLogin 
FROM churn.metric
JOIN observation_params ON 
	metric_time BETWEEN obs_start AND obs_end    
JOIN churn.churn_observation ON 
	metric.account_id = churn_observation.account_id
    	AND metric.metric_time > (churn_observation.observation_date - metric_period)::timestamp    
    	AND metric.metric_time <= churn_observation.observation_date::timestamp
GROUP BY metric.account_id, metric_time, observation_date, is_churn    
ORDER BY observation_date, metric.account_id;
