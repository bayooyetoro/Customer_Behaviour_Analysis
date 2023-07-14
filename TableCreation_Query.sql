/* this query aims to merge divvy_bike 2022 ride details and answer the question:
how divvy user_type (member and casual) use bikes differently */

-- QUARTER TABLES CREATION

-- this is to create the tables Q1 to dec (just input table_name in the xxx) 

DROP TABLE IF EXISTS xxx;
CREATE TABLE xxx (ride_id VARCHAR(100),
				 bike_type VARCHAR(50),
				 started_at TIMESTAMP,
				 ended_at TIMESTAMP,
				 start_station_name VARCHAR(250),
				 end_station_name VARCHAR(250),
				user_type VARCHAR(50));
				
-- this is used to create other quarters
CREATE TABLE q* AS (SELECT * FROM <month_name> UNION ALL
					SELECT * FROM <month_name> UNION ALL
					SELECT * FROM <month_name>) 
					
-- drop months column since it's already in quarters
DROP TABLE IF EXISTS aug,apr,may,jun,jul,oct,sep,oct,nov,dec 

--merging all quarters to a single table
CREATE TABLE full_year AS (SELECT * FROM q1 UNION
						   SELECT * FROM q2 UNION
						   SELECT * FROM q3 UNION 
						   SELECT * FROM q4)

