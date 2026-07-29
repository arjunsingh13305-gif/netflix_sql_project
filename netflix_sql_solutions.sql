-- netflix project 
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix 
	(
		show_id VARCHAR(6),
		type VARCHAR(10),
		title VARCHAR(150),
		director VARCHAR(208),
		casts VARCHAR(1000),
		country VARCHAR(150),
		date_added VARCHAR(50),
		release_year INT,
		rating	VARCHAR(10),
		duration	VARCHAR(15),
		listed_in	VARCHAR(100),
		description VARCHAR(250)
	)



select * from netflix;

SELECT
	COUNT(*) as total_content
from netflix;


SELECT
	DISTINCT type
from netflix;

select * from netflix;

--- Business problems 

--1. Count the number of Movies vs TV Shows

select 
	type,
	count(*) as total_content
from netflix
group by type


--2. Find the most common rating for movies and TV shows

select
	type,
	rating,
	count(*)
	--max(rating)
from netflix
group by 1,2
order by 3 desc


--3. List all movies released in a specific year (e.g., 2020)
SELECT * 
FROM netflix
WHERE release_year = 2020




--4. Find the top 5 countries with the most content on Netflix
SELECT * 
FROM
(
	SELECT 
		-- country,
		UNNEST(STRING_TO_ARRAY(country, ',')) as country,
		COUNT(*) as total_content
	FROM netflix
	GROUP BY 1
)as t1
WHERE country IS NOT NULL
ORDER BY total_content DESC
LIMIT 5



--5. Identify the longest movie
SELECT 
	*
FROM netflix
WHERE type = 'Movie'
ORDER BY SPLIT_PART(duration, ' ', 1)::INT DESC



--6. Find content added in the last 5 years
SELECT
*
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'



--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!
SELECT *
FROM
(

SELECT 
	*,
	UNNEST(STRING_TO_ARRAY(director, ',')) as director_name
FROM 
netflix
)
WHERE 
	director_name = 'Rajiv Chilaka'



--8. List all TV shows with more than 5 seasons
SELECT *
FROM netflix
WHERE 
	TYPE = 'TV Show'
	AND
	SPLIT_PART(duration, ' ', 1)::INT > 5




--9. Count the number of content items in each genre
SELECT 
	UNNEST(STRING_TO_ARRAY(listed_in, ',')) as genre,
	COUNT(*) as total_content
FROM netflix
GROUP BY 1



--10.Find each year and the average numbers of content release in India on netflix. return top 5 year with highest avg content release!
SELECT 
	country,
	release_year,
	COUNT(show_id) as total_release,
	ROUND(
		COUNT(show_id)::numeric/
								(SELECT COUNT(show_id) FROM netflix WHERE country = 'India')::numeric * 100 
		,2
		)
		as avg_release
FROM netflix
WHERE country = 'India' 
GROUP BY country, 2
ORDER BY avg_release DESC 
LIMIT 5

