# churn_prediction
Predicting customer churn on reading platform from behaviour analysis to churn forecasting.

## About the data
The raw event data was collected from Manning's liveBook customers over six months from December 1, 2019 through June 1, 2020. Account IDs (`account_id` column) have been anonymized. 

## Project files master table

| Milestone                         | Action                             | SQL                                          | CSV                               | Notebook                          |
| --------------------------------- | ---------------------------------- | -------------------------------------------- | --------------------------------- | --------------------------------- |
| Load event data                   | Create liveBook database           | create_livebook_db.sql                       |                                   |                                   |
| Create project schema             | create_churn_schema.sql            |                                              |                                   |
| Create events table               | import_event.sql                   |                                              |                                   |
| EDA and QA                        | Determine popular events           | events_per_account.sql                       | events_per_account.csv            | 1_event_data_qa.ipynb             |
| Event quality assurance           | events_per_day.sql                 |                                              | 1_event_data_qa.ipynb             |
| Create customer behaviour metrics | Create customer behaviour metrics  | insert_metric.sql<br>insert_metric_info.sql  |                                   |                                   |
|                                   | Behaviour metric quality assurance | metrics_over_time.sql<br>metric_coverage.sql |                                   | 2_cust_behaviour_metrics_qa.ipynb |
|                                   | Create customer dataset            | active_customer_metrics.sql                  | curr_customer_metrics_summary.csv | 2_cust_behaviour_metrics_qa.ipynb |
|                                   | Create (churn) observations table  | create_observation.sql                       |                                   |                                   |
|                                   | Identify churned customers         | insert_observation.sql                       |                                   |                                   |
|                                   | Calculate churn rate               | calculate_churn.sql                          |                                   |                                   |
|                                   | Create churner dataset             |                                              | updated_churner_metrics.csv       |                                   |
|                                   | Cohort analysis                    |                                              |                                   | 3_churn_analysis.ipynb            |

Improvements:

Postgres for scale, seaborn for viz
