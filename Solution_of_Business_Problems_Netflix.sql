-- Netflix Movies and TV Shows Project
-- Netflix Data Analysis via SQL.

-- 1. Find out the Number of Movies vs TV Shows Present on netflix?
SELECT 
      type, 
	  count(*) 
FROM netflix 
GROUP BY type;


-- 2. Find the Most Common Rating for Movies and TV Shows?
SELECT 
      type, 
	  rating 
FROM (
      SELECT 
	        type, 
			rating, 
			COUNT(*) as rating, 
			RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC ) Ranking
      FROM netflix 
	  GROUP BY type, rating 
) AS t1 
WHERE Ranking = 1;


-- 3. Find out Most Number of Movies Released in a Specific Year (e.g., 2018)?
SELECT * 
FROM netflix
WHERE release_year = 2018;


-- 4. Find Top 7 Countries with the Most Number of Movies and TV shows on Netflix?
WITH Most_Content AS (
     SELECT 
           Trim(UNNEST(STRING_TO_ARRAY(country,','))) AS country, 
	       count(*) AS contents  
     FROM netflix 
     GROUP BY 1
)
SELECT 
      country, 
	  contents 
FROM Most_Content 
ORDER BY 2 DESC 
LIMIT 7;


-- 5. Identify the Longest Movie Duration?
SELECT * 
FROM netflix
WHERE type = 'Movie' AND duration = ( 
                                     SELECT
                                            MAX(duration) 
									  FROM netflix
                                     );
									 
									 
-- 6. List All TV Shows with More Than  or Equal to 7 Seasons?
SELECT *
FROM netflix
WHERE type = 'TV Show'
   AND SPLIT_PART(duration, ' ', 1)::INT >= 7;


-- 7. Find Content Added in the Last 7 Years?
SELECT * 
FROM netflix 
WHERE date_added >= CURRENT_DATE - INTERVAL '7 year' AND date_added IS NOT NULL;


-- 8. Count the Number of Content in Each Genre?
SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
	COUNT (*) AS content_number 
FROM netflix 
GROUP BY genre 
ORDER BY 1;


-- 9.Find each year and the average numbers of content release in India on netflix?
SELECT 
    country,
    release_year,
    COUNT(show_id) AS total_release,
    ROUND(
        COUNT(show_id)::numeric /
        (SELECT COUNT(show_id) FROM netflix WHERE country ILIKE '%India%')::numeric * 100, 2
    ) AS avg_release
FROM netflix
WHERE country ILIKE '%India%'
GROUP BY country, release_year
ORDER BY avg_release DESC
LIMIT 5;


-- 10. Find Out all the Movies that are Documentaries?
SELECT * 
FROM netflix 
WHERE type = 'Movie' AND listed_in ILIKE '%Documentaries%';


-- 11. Find All Content Without a Director?
SELECT * 
FROM netflix
WHERE director IS NULL;


-- 12. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India?
SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;


-- 13. Find How Many Movies Actor 'Shah Rukh Khan' Appeared in the Netflix Last 5 Years?
SELECT * 
FROM netflix 
WHERE casts 
      ILIKE '%Shah Rukh Khan%' 
      AND date_added>= CURRENT_DATE - INTERVAL '5 year';


-- 14. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords.
WITH No_Of_Category AS (
                  SELECT *,
                         CASE 
                            When description ILIKE '%Kill%'
		                         OR 
		                         description ILIKE '%Violence%'
		                    THEN 'Bad Category'
		                    ELSE 'Good Category'
		                 END Category		   
                  FROM netflix
)
SELECT 
    Category,
	COUNT(*) 
FROM No_Of_Category 
GROUP BY Category 
ORDER BY 1 DESC;













	



