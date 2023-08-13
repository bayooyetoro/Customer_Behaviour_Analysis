-- creating a cleaned table with a view
DROP VIEW IF EXISTS divyride;

CREATE VIEW divyride AS (SELECT *, (ended_at - started_at) AS ride_length
			 FROM full_year
			 WHERE end_station_name IS NOT NULL AND 
			 start_station_name IS NOT NULL AND 
			 (ended_at - started_at) >= '00:05:00')
										 
-- EDA (Exploratory Data Analysis)
SELECT user_type,
       MAX(ride_length),
       MIN(ride_length),
       AVG(ride_length),
       COUNT(*) AS no_of_rides
FROM divyride
GROUP BY user_type

-- to know the numbers of each user_type and percentage
WITH t1 AS (SELECT user_type, COUNT(*) AS no_of_users
	    FROM divy_ride
	    GROUP BY user_type), 
     t2 AS (SELECT SUM(no_of_users) AS total_users
	    FROM t1)	  

SELECT t1.*, 
       ROUND((no_of_users/total_users)*100,2) AS User_Percentage
FROM t1,t2;
/* FINDINGS: "casual"   1,595,566	 43.08%
             "member"	2,108,019	 56.92% */

-- to understand bike_type usage among the two customer categories
SELECT bike_type, 
       user_type, 
       COUNT(*) AS no_of_bikes_used
FROM divyride
GROUP BY bike_type, user_type
ORDER BY user_type, no_of_bikes_used DESC;
-- FINDINGS: For both category, classic_bikes are most used, followed by electric_bikes. But no member ever used docked_bike.

-- no_of_rides by quarter by user_type
SELECT user_type, 
       'Q'||EXTRACT(QUARTER FROM started_at) AS quarter,
       COUNT(*) AS no_of_rides
FROM divyride
GROUP BY quarter, user_type
ORDER BY user_type, no_of_rides DESC
--FINDINGS: There is a similar pattern in the no of rides by quarter with the highest in Q3 then Q2, Q4, and least in Q1 for both user_type

---to understand the riding patterns per day for each category of customers as well as avg ride_length
SELECT CASE EXTRACT(dow FROM started_at)
	WHEN 0 THEN 'Sunday'   WHEN 1 THEN 'Monday'
	WHEN 2 THEN 'Tuesday'  WHEN 3 THEN 'Wednesday'
	WHEN 4 THEN 'Thursday' WHEN 5 THEN 'Friday'
	WHEN 6 THEN 'Saturday' END AS day_of_week,
     COUNT(*) AS no_of_rides,
     AVG(ended_at - started_at) AS avg_ride_length
FROM divyride
WHERE user_type = 'member'
GROUP BY day_of_week
ORDER BY no_of_rides DESC; -- <same was done for WHERE user_type = 'member'>
-- FINDINGS: Casual customers ride more during weekends, and during weekdays for members

-- Top 5 stations where most rides are initiated by user_type
WITH starting AS  ( SELECT start_station_name, user_type,
        	    CASE WHEN user_type = 'member' THEN DENSE_RANK() OVER (PARTITION BY user_type ORDER BY COUNT(*) DESC)
                         WHEN user_type = 'casual' THEN DENSE_RANK() OVER (PARTITION BY user_type ORDER BY COUNT(*) DESC)
                         END AS ranking
                    FROM divyride
                    GROUP BY start_station_name, user_type
                    ORDER BY user_type, ranking )
SELECT * FROM starting
WHERE ranking <= 5

--Top 5 destinations by user_type
WITH destination AS (SELECT end_station_name, user_type,
                      CASE WHEN user_type = 'member' THEN DENSE_RANK() OVER (PARTITION BY user_type ORDER BY COUNT(*) DESC)
                           WHEN user_type = 'casual' THEN DENSE_RANK() OVER (PARTITION BY user_type ORDER BY COUNT(*) DESC)
                           END AS ranking
                     FROM divyride
                     GROUP BY end_station_name, user_type
                     ORDER BY user_type, ranking )
SELECT * FROM destination 
WHERE ranking <= 5 
