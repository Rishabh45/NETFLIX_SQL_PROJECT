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
###2. Find the Most Common Rating for Movies and TV Shows?
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
