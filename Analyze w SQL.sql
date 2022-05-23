CREATE DATABASE TED
USE TED
SELECT * FROM ted

--Rename column 'date' to 'up_date'
EXEC sp_rename 'dbo.ted.date', 'up_date', 'COLUMN';

--Check for duplicate entries first
SELECT title, COUNT(*)
FROM ted
GROUP BY title
HAVING COUNT(*) > 1;

--How many years of TED TALKS dataset
SELECT MAX(YEAR(up_date)) AS last_year,
	MIN(YEAR(up_date)) AS first_year,
	(CAST(MAX(YEAR(up_date)) AS int) - CAST(MIN(YEAR(up_date)) AS int)) AS num_year
FROM ted;

--The top 10 TED talks in terms of number of views and likes
SELECT TOP 10 title
FROM ted
ORDER BY views DESC, likes DESC;

--Most views on Ted Talk
SELECT title, views, up_date
FROM ted
WHERE views = (SELECT MAX(views) FROM ted);

--Most likes on Ted Talk
SELECT TOP 1 title, likes, up_date
FROM ted
ORDER BY likes DESC;

--The top 10 TED speaker in terms of number of talks
SELECT TOP 10 author, count(title) as num_speech
FROM ted
GROUP BY author 
ORDER BY COUNT(title) DESC;

--The top 5 TED speaker in terms of views
SELECT TOP 5 author, sum(views) as total_views
FROM ted
GROUP BY author 
ORDER BY SUM(views) DESC;

--The author has more than one talk. Count and rank
WITH cte AS (
	SELECT author, COUNT(title) AS num_speech
	FROM ted
	GROUP BY author
	HAVING count(title) > 1)
SELECT author, num_speech, DENSE_RANK() OVER (ORDER BY num_speech DESC) AS ranking
FROM cte;

--Month-wise Analysis of TED talk frequency
SELECT MONTH(up_date) AS month, COUNT(title) AS num_speech, AVG(views) AS avg_views, AVG(likes) AS avg_likes,
		IIF(COUNT(title) = 1, NULL, MAX(views)) AS max_view,
		IIF(COUNT(title) = 1, NULL, MIN(views)) AS min_view,
		IIF(COUNT(title) = 1, NULL, MAX(likes)) AS max_likes,
		IIF(COUNT(title) = 1, NULL, MIN(likes)) AS min_likes
FROM ted
GROUP BY MONTH(up_date)
ORDER BY month;

--Year-wise Analysis of TED talk frequency
SELECT YEAR(up_date) AS year, COUNT(title) AS num_speech, AVG(views) AS avg_views, AVG(likes) AS avg_likes,
		IIF(COUNT(title) = 1, NULL, MAX(views)) AS max_view,
		IIF(COUNT(title) = 1, NULL, MIN(views)) AS min_view,
		IIF(COUNT(title) = 1, NULL, MAX(likes)) AS max_likes,
		IIF(COUNT(title) = 1, NULL, MIN(likes)) AS min_likes
FROM ted
GROUP BY YEAR(up_date)
ORDER BY year;