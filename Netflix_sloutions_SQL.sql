-- Netflix Project on Tv shows & Movies
drop table if exists netflix;
create table netflix(
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
--to see entire table
select * from netflix

--view total number of rows
select count(*) as total_content from netflix

--to see how many types are there in netflix
select distinct type from netflix

###Real World problems for the analysis 
--problem 1-"Count number of movies vs tv shows"
select type,
  count(*) as total_content 
 from netflix 
 group by type

 --problem 2-"Find the most common rating for Movies and TV shows"
 select type, rating 
 from 
 (
select type, rating,
count(*),
rank() over (partition by type order by count(*)desc)as ranking 
from netflix
group by 1,2
 ) as tl
 where ranking =1

--problem 3 - "List all movies released in a specific year (e.g, 2020)"
select * from netflix
where type = 'Movie'
and
release_year = 2020

--problem 4 - "Find the top 5 countries with the most content on netflix"
select  
unnest(string_to_array(country,',')) as new_country,
count(show_id) as total_count
from netflix
group by 1
order by 2 desc
limit 5

--problem 5-"Identify the longest movies?"
select * from netflix
where type = 'Movie'
and
duration = (select max(duration) from netflix)

--problem 6 - " Find content added in the last 5 years"
select * 
from netflix
where 
to_date(date_added,'month dd, yyyy') >= current_date - interval '5 years'

--Problem 7 - "Find all the movies/tv shows directed by Rajiv Chilaka"

select * from netflix
where 
--"%" list all movie/tv shows where he can be another director for tv show/ movie
director Ilike '%Rajiv Chilaka%'

--problem 8 - "List all TV shows with more than 5 seasons"
select *
from netflix
where 
type = 'TV Show'
and
--split function to split between number and season in duration because it is character
split_part(duration,' ',1)::numeric > 5 

--example for split function 
select
split_part('batman superman ironman',' ',3) --return ironman 

--problem 9 -"Count the number of conetnt items in each genre"
select
--genre is clubed into one so we keep them in one array and divided where delimted by ',' and "unnest" them into sperate genre 
unnest(string_to_array(listed_in,',')) as genre,
count(show_id) 
from netflix
group by 1

--problem 10 - "Find each year and the average numbers of content release by India on Netflix.
--return top 5 year with highest average content release "
select 
extract(year from to_date(date_added,'month dd,yyyy')) as year,
count(*),
round(count(*)::numeric/(select count(*) from netflix where country = 'India')*100,2) as avg_content
from netflix
 where country  = 'India'
 group by 1

 --problem 11- "List all the movies which are documentaries"
 select * from netflix
 where 
 listed_in ilike '%documentaries'

 --problem 12 - "Find all content without a director"
 select * from netflix
where 
director is null

--problem 14 - "Find how many movies actor 'Tom Cruise' appeared in last 10 years"

select * from netflix
where 
casts ilike '%Tom Cruise%'
and 
release_year > extract(year from current_date) - 10

--problem 14 - " Find top 10 actors who have appeared in the highest number of movies produced in USA"
select 
unnest(string_to_array(casts,',')) as actors,
count(*) as total_count
from netflix
where 
country ilike '%united states'
group by 1
order by 2 desc
limit 10

--problem 15- Categorize the content based on the presence of the keywords 'kill' and 'violence' in the description field. 
--Label content containg these keywords as 'Bad' and all other content as 'good'.
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






















 













