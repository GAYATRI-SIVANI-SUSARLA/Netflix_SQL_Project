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
- ** Dataset Link :**  [Netflix Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

  ## Schema
  ```SQL
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
--to see the entire table
select * from Netflix

--View total number of rows
select count(*) as total_content from Netflix

--to see how many types are there in netflix
select distinct type from netflix
```
  


