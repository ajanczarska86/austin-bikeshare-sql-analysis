# austin-bikeshare-sql-analysis
SQL practice - analyzing BigQuery public datasets (Austin Bikeshare).

# Austin Bikeshare Data Analysis (SQL / BigQuery)

## Overview
This repository contains a SQL analysis performed on Google BigQuery's public dataset: `bigquery-public-data.austin_bikeshare.bikeshare_trips`.

## Key Concepts Used
- **CTEs (Common Table Expressions)** for structuring multi-step logic
- **CASE Statements** for categorizing trip durations and custom metrics
- **Window Functions (`RANK()`, `DENSE_RANK()`)** to evaluate top performers
- **LEFT JOINs & Date Filtering** (`EXTRACT`, `DATE`)

## Sample Query
Here is the main SQL query analyzing long trips from 2023 for a specific station:

```sql
WITH trips_2023 AS(
  SELECT trip_id, stations.name AS station, subscriber_type, duration_minutes, DATE(start_time) AS date,
  CASE WHEN duration_minutes > 60 THEN 'Long'
        ELSE 'Standard' END AS trip_category,
    CASE WHEN duration_minutes >= 10000 THEN 1
        WHEN duration_minutes >= 5000 THEN 2
        WHEN duration_minutes >= 1000 THEN 3
        ELSE 4 END AS ranking
FROM `bigquery-public-data.austin_bikeshare.bikeshare_trips` 
LEFT JOIN `bigquery-public-data.austin_bikeshare.bikeshare_stations` AS stations ON start_station_id = stations.station_id
WHERE EXTRACT(YEAR FROM start_time) = 2023
AND start_station_id = 4057
)
SELECT 
trips_2023.trip_id, 
trips_2023.station,
trips_2023.subscriber_type, 
trips_2023.duration_minutes, 
trips_2023.trip_category,
trips_2023.date,
RANK() OVER(ORDER BY trips_2023.ranking ASC) AS duration_rank
FROM trips_2023
WHERE trips_2023.trip_category = 'Long'

##Sample Results

Row	trip_id	station	subscriber_type	duration_minutes	trip_category	date	duration_rank
1	28986781	6th & Chalmers	24 Hour Walk Up Pass	22964	Long	2023-03-03	1
2	29853642	6th & Chalmers	Local365	1134	Long	2023-06-08	2
3	29795104	6th & Chalmers	Local365	4012	Long	2023-06-02	2
4	28963440	6th & Chalmers	Pay-as-you-ride	1110	Long	2023-02-27	2
5	31416674	6th & Chalmers	Local365	110	Long	2023-10-08	5
6	28685898	6th & Chalmers	24 Hour Walk Up Pass	96	Long	2023-01-01	5
7	29495034	6th & Chalmers	Local31	72	Long	2023-05-01	5
8	31939002	6th & Chalmers	Local31	124	Long	2023-11-16	5
