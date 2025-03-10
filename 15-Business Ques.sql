select * from Netflix;

select count(*) from Netflix;

-- 										15 Bussiness Problems

-- 1. Count the number of movies vs TV Show

select 
	distinct type,
	count(type) total_Content
from Netflix group by type;

-- 2.  Find the most common rating for movies and TV shows

select 
	type,
	rating,
	rating_Count
from (
	select  
		type, 
		rating, 
		count(*)AS rating_Count,
		rank() over(partition by type ORDER BY  count(*) desc) as ranking
	from Netflix
group by 1,2
	)as t1
where 
	ranking = 1;

-- Find all the movies released in a specific year (e.g., 2020)

select 
	*
	from Netflix
	where 
	type = 'Movie' 
	AND
	release_year = 2020;

-- Find the top 5 Countries with the most content on netflix

select country, count(*) total_Content
from Netflix
	group by 1 ;

select 
	unnest(string_to_array(country, ',')) as new_country
	from Netflix;

select
	unnest(string_to_array(country, ',')) as new_country,
	count(*) total_content
	from Netflix
	group by 1
	order by 2 desc
	limit 5;

-- Q5. identify the longest Movie

select * from Netflix
	where 
		type = 'Movie'
		AND 
		duration = ( select MAX(duration) from Netflix);

-- Q6. Find the content added in the Last 5 Years 

select *
	from Netflix
	where
		TO_DATE( date_added, 'Month DD, YYYY') >= current_date - interval '5 years' ;

-- Q7. find all the movies/TV shows by Director 'Rajiv Chilaka'
select * from 
	Netflix
	where director like '%Rajiv Chilaka%';

select * from 
	Netflix
	where director ilike '%Rajiv Chilaka%';

select * from 
	Netflix
	where director = 'Rajiv Chilaka';

-- Q8. List of all TV Shows more than 5 Shows

select split_part('Apple  Mango Cherry', ' ' , 1) ; 


select * 
	from Netflix
	where type = 'TV Show'
	and 
	split_part(duration, ' ', 1) :: numeric > 5;

-- Q9 Count the number of content items in each genre

select * from Netflix;

select unnest(string_to_array( listed_in , ',')) as genre,
	count( show_id) as total_content
	from Netflix
	group by 1
	order by 2 desc;

-- Q10 Find each year and the average numbers of content release in  india on netflix,
--     return top 5 year wiht highest avg content release.

select 
	EXTRACT(YEAR from to_date(date_added,'Month DD, YYYY')) as Year,
	count(*) as Yearly_content,
	ROUND(count(*) :: numeric / (select count(*) from Netflix where country = 'India' ) :: numeric *100 ,2 ) as Avg_Content_per_Year
	from Netflix
	where country = 'India'
	group by 1;

-- Q11 List of all movies that are documentaries

select * from Netflix;

select  *
	from Netflix
	where
	listed_in ilike '%documentaries%'; 

-- Q12 Find all content without a director

select  *
	from Netflix
	where director is NULL;

-- Q13 How many movies actor 'Salman Khan' appeared in last 10 Years

select * from Netflix
	where casts ilike '%Salman Khan%'
	and
	release_year > Extract(Year from Current_Date) - 10;

-- Q14 Find the top 10 Actors who have appeared in the highest numbe of movies produced in india

select
	unnest(string_to_array(Casts, ',')) as Actors, 
	count(*) as Movies_count
	from Netflix
	where country ilike '%India%'
	group by 1
	order by 2 desc
	limit 10;

-- Q15 Categorize the Content based on the presence of the keywords 'Kill' and 'Violence' in the description field. Label Content 
--  Containing these keywords as 'Bad' and all other content as 'Good'. Count how many items fall into each category.

with new_table 
	as (
		select * ,
			CASE
			WHEN description ilike '%Kill%' OR
				 description ilike '%violence%' THEN 'Bad_Content'
				 else 'Good Content'
			END  Category
		from Netflix )
	select 
		Category,
		count(*) as total_content 
	from new_table
	group by 1;
























