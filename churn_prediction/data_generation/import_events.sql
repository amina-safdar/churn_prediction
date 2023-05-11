COPY 
    churn.event(account.id, event_time, event_type, product_id, additional_data)
FROM %(path_to_liveBook_data)s
DELIMITER ‘,’
CSV HEADER;
