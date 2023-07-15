-- to know the numbers of each user_type and percentage
WITH t1 AS (SELECT user_type, COUNT(*) AS no_of_users
		   FROM full_year
		   GROUP BY user_type),   
	t2 AS (SELECT SUM(no_of_users) AS total_users
		  FROM t1)	  
SELECT t1.*, ROUND((no_of_users/total_users)*100,2) AS User_Percentage
FROM t1,t2;
-- FINDINGS: casual riders has 2,318,611 making 40.97% of the total rides and member has 3,341,149 with 59.03%

-- to understand bike_type usuage among the two customer categories
SELECT bike_type, user_type, COUNT(*) no_of_bikes_used
FROM full_year
GROUP BY bike_type, user_type
ORDER BY user_type, no_of_bikes_used DESC;
-- FINDINGS: casual riders used all the 3 types of bikes with electric_bikes as most used WHILE members do not use docked_bikes at all. 

-- to undertand the pattern of rides per quarter for each category of customers
SELECT user_type, 'Q'||EXTRACT(QUARTER FROM started_at) AS quarter,
       COUNT(*) AS no_of_rides
FROM full_year
GROUP BY quarter, user_type
ORDER BY user_type, no_of_rides DESC;
-- FINDINGS: there is a same pattern in number of rides per quarter for both customer types; most rides in Q3, then Q2, Q4 and lowest in Q1;

---to understand the riding patterns per day for each caterory of customers 
SELECT CASE EXTRACT(dow FROM started_at)
	WHEN 0 THEN 'Sunday'   WHEN 1 THEN 'Monday'
	WHEN 2 THEN 'Tuesday'  WHEN 3 THEN 'Wednesday'
	WHEN 4 THEN 'Thursday' WHEN 5 THEN 'Friday'
	WHEN 6 THEN 'Saturday' END AS day_of_week,
	COUNT(*) AS no_of_rides,
	AVG(ended_at - started_at) AS avg_ride_length
FROM full_year
WHERE user_type = 'casual'
GROUP BY day_of_week
ORDER BY no_of_rides DESC; -- <same was done for WHERE user_type = 'member'>
--FINDINGS:
