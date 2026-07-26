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
