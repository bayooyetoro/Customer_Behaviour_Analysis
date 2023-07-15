-- to know the numbers of each user_type and percentage
WITH t1 AS (SELECT user_type, COUNT(*) AS no_of_users
		   FROM full_year
		   GROUP BY user_type),
		   
	t2 AS (SELECT SUM(no_of_users) AS total_users
		  FROM t1)
		  
SELECT t1.*, ROUND((no_of_users/total_users)*100,2) AS User_Percentage
FROM t1,t2