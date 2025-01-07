# Netflix Movies and TV Shows Data Analytics using SQL
![Netflix Logo](https://github.com/GAYATRI-SIVANI-SUSARLA/Netflix_SQL_Project/blob/main/Netflix%20Logo.png)

## Overview
This project analyzes Netflix's Movies and TV shows using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, and conclusions.

## Objectives
- Analyze the distribution of content types (Movies vs TV shows)
- Identify the most common ratings for movies and TV shows
- List and analyze content based on release years, countries, and durations
- Explore and categorize content based on specific criteria and keywords

## Dataset
The data for this project is collected from the "Kaggle Dataset" 

- **Dataset Link:**  [Netflix Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)
## Schema

```SQL
 -- Netflix Project on TV Shows & Movies
  create a table Netflix (
  show_id varchar(6),
  type varchar(10),
  title varchar(150),
  director varchar(208),
  casts varchar(1000),
  country varchar(150),
  date_added varchar(50),
  release_year int,
  rating varchar(10),
  duration varchar(15),
  listed_in varchar(100),
  description varchar(250)
  )
--to see the entire table
select * from Netflix

--View total number of rows
select count(*) as total_content from Netflix

--to see how many types there are on Netflix
select a distinct type from Netflix
```

## Real-World Business Problems and Solutions 
### 1. Count the Number of Movies vs TV Shows
```SQL
###Real World problems for the analysis 
--problem 1-"Count the number of movies vs TV shows"
select type,
  count(*) as total_content 
 from Netflix 
 group by type
```
**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows
```SQL
 --problem 2-"Find the most common rating for Movies and TV shows"
 select type, rating 
 from 
 (
select type, rating,
count(*),
rank() over (partition by type order by count(*)desc)as ranking 
from Netflix
group by 1,2
 ) as tl
 where ranking =1
```
**Objective:**  Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)
```SQL
--problem 3 - "List all movies released in a specific year (e.g, 2020)"
select * from Netflix
where type = 'Movie'
and
release_year = 2020
```
**Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix
```SQL
--problem 4 - "Find the top 5 countries with the most content on Netflix"
select
unnest(string_to_array(country,',')) as new_country,
count(show_id) as total_count
from Netflix
group by 1
order by 2 desc
limit 5
```
**Objective:** Identify the top 5 countries with the highest number of content items.
### 5. Identify the Longest Movie
```SQL
--problem 5-"Identify the longest movies?"
select * from Netflix
where type = 'Movie'
and
duration = (select max(duration) from Netflix)
```
**Objective:** Find the movies that have the longest duration.
### 6.Find Content Added in the Last 5 Years
```SQL
--problem 6 - " Find content added in the last 5 years"
select * 
from Netflix
where 
to_date(date_added,'month dd, yyyy') >= current_date - interval '5 years'
```
**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
```SQL

--Problem 7 - "Find all the movies/TV shows directed by Rajiv Chilaka"

select * from netflix
where 
--"%" list all movies/TV shows where he can be another director for a TV/ movie
director Ilike '%Rajiv Chilaka%'
```
**Objective:**  List all content directed by 'Rajiv Chilaka'.
### 8. List All TV Shows with More Than 5 Seasons
```SQL
--problem 8 - "List all TV shows with more than 5 seasons"
select *
from netflix
where 
type = 'TV Show'
and
--split function to split between number and season in duration because it is a character
split_part(duration,' ',1)::numeric > 5 

--example for split function 
select
split_part('batman superman ironman',' ',3) --return ironman
```
**Objective:** Identify TV shows with more than 5 seasons.

### 9. Count the Number of Content Items in Each Genre
```SQL
--problem 9 -"Count the number of content items in each genre"
select
--the genre is clubbed into one so we keep them in one array and divided where delimited by ',' and "unnest" them into separate genre 
unnest(string_to_array(listed_in,',')) as genre,
count(show_id) 
from netflix
group by 1
```
**Objective:**  Count the number of content items in each genre.

### 10.Find each year and the average number of content releases in the India on Netflix.
```sql
--problem 10 - "Find each year and the average number of content released by India on Netflix.
--return to top 5 year with the highest average content release "
select 
extract(year from to_date(date_added,'month dd,yyyy')) as year,
count(*),
round(count(*)::numeric/(select count(*) from netflix where country = 'India')*100,2) as avg_content
from netflix
 where country  = 'India'
 group by 1
```
**Objective:** Calculate and rank years by the average number of content releases in India.

### 11. List All Movies that are Documentaries
```sql
 --problem 11- "List all the movies which are documentaries"
 select * from netflix
 where 
 listed_in ilike '%documentaries'
```
**Objective:** Retrieve all movies classified as documentaries.
### 12. Find All Content Without a Director
```sql
 --problem 12 - "Find all content without a director"
 select * from netflix
where 
director is null
```
**Objective:** List content of movies that do not have a director.
 ### 13. Find How Many Movies Actor 'Tom Cruise' Appeared in the Last 10 Years
 ```sql
--problem 13 - "Find how many movies actor 'Tom Cruise' appeared in last 10 years"

select * from netflix
where 
casts ilike '%Tom Cruise%'
and 
release_year > extract(year from current_date) - 10
```
**Objective:** Count the number of movies featuring 'Tom Cruise' in the last 10 years.
### 14. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in United States 
```sql
--problem 14 - " Find the top 10 actors who have appeared in the highest number of movies produced in the USA"
select 
unnest(string_to_array(casts,',')) as actors,
count(*) as total_count
from netflix
where 
country ilike '%united states'
group by 1
order by 2 desc
limit 10
```
**Objective:** Identify the top 10 actors with the most appearances in the United States-produced movies.

### 15. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords
```sql
--problem 15- Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. 
--Label content containing these keywords as 'Bad' and all other content as 'Good'.
--count how many items fall into each category

with new_table
as
(
select 
*,
    case
    when
        description ilike '%kill%' or
        description ilike ' %violence%' then 'Bad_Content'
        else 'Good_Content'
    end category
from netflix
)
select 
 category,
 count(*) as total
from new_table
group by 1
```
**Objective:**  Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Conclusion
- Content Distribution: The dataset contains a wide range of movies and TV shows with 
  varying ratings and genres.
- Common Ratings: Insights into the most common ratings provide an understanding of the 
  content's target audience.
- Geographical Insights: The top countries and the average content releases by the United 
  States highlight regional content distribution.
- Content Categorization: Categorizing content based on specific keywords helps in 
  understanding the nature of content available on Netflix.
  





















 

















