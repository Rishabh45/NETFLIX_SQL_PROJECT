## Netflix Movies and TV Shows Project using SQL for Data Analysis.

![](https://github.com/Rishabh45/NETFLIX_SQL_PROJECT/blob/main/Netflix_Logo.png)

---
### Overview
This project entails an in-depth analysis of Netflix's movies and TV shows dataset through SQL. The aim is to derive meaningful insights and address several business-related queries using the data. This README offers a thorough overview of the project’s objectives, business challenges, solutions, findings, and conclusions.

---
### Objectives
- Examine the distribution of content types (movies versus TV shows).
- Determine the most frequent ratings for each content type.
- Organize and evaluate content by release year, country, and duration.
- Investigate and classify content based on particular criteria and keywords.

---
### Dataset
The dataset used in this project is obtained from Kaggle.
- ### Dataset Link: [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

---
### Schema
```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id    VARCHAR(5),
    type       VARCHAR(10),
    title      VARCHAR(250),
    director   VARCHAR(550),
    casts      VARCHAR(1050),
    country    VARCHAR(550),
    date_added date,
    release_year INT,
    rating     VARCHAR(15),
    duration   VARCHAR(15),
    listed_in  VARCHAR(250),
    description VARCHAR(550)
);

SELECT * FROM netflix;
```

## Business Problems and Solutions
### 1. Find out the Number of Movies vs TV Shows Present on netflix?
```sql

SELECT 
    type, 
    count(*) 
FROM netflix 
GROUP BY type;

```

---
### 2. Find the Most Common Rating for Movies and TV Shows?
```sql

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

```

---
### 3. Find out Most Number of Movies Released in a Specific Year (e.g., 2018)?
```sql

SELECT * 
FROM netflix
WHERE release_year = 2018;

```

---
### 4. Find Top 7 Countries with the Most Number of Movies and TV shows on Netflix?
```sql

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

```

---
### 5. Identify the Longest Movie Duration?
```sql

SELECT * 
FROM netflix
WHERE type = 'Movie' AND duration = ( 
                                     SELECT
                                            MAX(duration) 
                                     FROM netflix
                                     );

```
									 
---									 
### 6. List All TV Shows with More Than  or Equal to 7 Seasons?
```sql

SELECT *
FROM netflix
WHERE type = 'TV Show'
   AND SPLIT_PART(duration, ' ', 1)::INT >= 7;

```

---
### 7. Find Content Added in the Last 7 Years?
```sql

SELECT * 
FROM netflix 
WHERE date_added >= CURRENT_DATE - INTERVAL '7 year' AND date_added IS NOT NULL;

```

---
### 8. Count the Number of Content in Each Genre?
```sql

SELECT 
    UNNEST(STRING_TO_ARRAY(listed_in, ',')) AS genre,
    COUNT (*) AS content_number 
FROM netflix 
GROUP BY genre 
ORDER BY 1;

```

---
### 9.Find each year and the average numbers of content release in India on netflix?
```sql

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

```

---
### 10. Find Out all the Movies that are Documentaries?
```sql

SELECT * 
FROM netflix 
WHERE type = 'Movie' AND listed_in ILIKE '%Documentaries%';

```

---
### 11. Find All Content Without a Director?
```sql

SELECT * 
FROM netflix
WHERE director IS NULL;

```

---
### 12. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India?
```sql

SELECT 
    UNNEST(STRING_TO_ARRAY(casts, ',')) AS actor,
    COUNT(*)
FROM netflix
WHERE country = 'India'
GROUP BY actor
ORDER BY COUNT(*) DESC
LIMIT 10;

```

---
### 13. Find How Many Movies Actor 'Shah Rukh Khan' Appeared in the Netflix Last 5 Years?
```sql

SELECT * 
FROM netflix 
WHERE casts ILIKE '%Shah Rukh Khan%' 
  AND date_added>= CURRENT_DATE - INTERVAL '5 year';

```

---
### 14. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords.
```sql

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

```

---
## Findings and Conclusion

**1. Content Distribution:** The dataset features a variety of movies and TV shows across different ratings and genres.  
**2. Popular Ratings:** Analyzing common ratings offers insights into the intended audience for the content.  
**3. Geographical Trends:** Leading countries and average content releases, particularly in India, shed light on regional content trends.  
**4. Content Classification:** Sorting content by specific keywords aids in understanding the types of material available on Netflix.  

This analysis delivers an in-depth look at Netflix's offerings and supports strategic content planning and decision-making.



