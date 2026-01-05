use StudentsDB;
 select * from df_netflix_era;
 select * from  df2_netflix_subscribers
 select  * from df3_netflix_revenue

 --1 Pre-COVID vs Post-COVID Subscriber Growth

/* Compare subscriber growth before and after COVID.
  */
  
              with netflix_data  as(
  select t.title AS Title ,t.year,
  s.subscribers_million as netflix_sub from df_netflix_era  t left join df2_netflix_subscribers s
  on  t.year=s.year
 )

 select
        case   when year < 2020 then  'pre_covid' else  'POST COVID' end as era,
                 round(avg(netflix_sub),2) as avg_sub
                 from netflix_data
                 group by 
                 case   when year < 2020 then  'pre_covid' else  'POST COVID' end



                 WITH netflix_data AS (
    SELECT 
        t.title AS Title,
        t.year,
        s.subscribers_million AS netflix_sub
    FROM df_netflix_era t
    LEFT JOIN df2_netflix_subscribers s
        ON t.year = s.year
)

SELECT
    CASE 
        WHEN year < 2020 THEN 'PRE-COVID'
        ELSE 'POST-COVID'
    END AS era,
    ROUND(AVG(netflix_sub), 2) AS avg_sub
FROM netflix_data
GROUP BY
    CASE 
        WHEN year < 2020 THEN 'PRE-COVID'
        ELSE 'POST-COVID'
    END;

   -- 2.Revenue Growth year by year
   select year ,revenue_billion_usd from df3_netflix_revenue  
   where year > 2020 
   order by year
    --top movies in 2025
    select top 5 title,watch_hours_display from df_netflix_era
    where   year=2025   and content_type='Movie'
    order by watch_hours_display desc;
   -- convert into billion/million
   SELECT
    title,
    watch_hours,
    CASE
        WHEN watch_hours >= 1000000000 
            THEN ROUND(watch_hours / 1000000000.0, 2)
        ELSE ROUND(watch_hours / 1000000.0, 2)
    END AS watch_hours_value,
    CASE
        WHEN watch_hours >= 1000000000 
            THEN 'Billion'
        ELSE 'Million'
    END AS watch_hours_unit
FROM df_netflix_era;


with watch_hrs as (
  select 
  title,year,
  case when watch_hours >=1000000000 
      then concat(cast(round(watch_hours /1000000000.0,2) as decimal(10,2)), 'Billion')
      else 
           concat(cast(round(watch_hours /1000000000.0,2) as decimal(10,2)),'Million')
           end as converted_watch_hours from  df_netflix_era 

)
select title,converted_watch_hours,year from watch_hrs;
SELECT
    title,
    watch_hours,
    CASE
        WHEN watch_hours >= 1000000000 THEN 
            CONCAT(ROUND(watch_hours / 1000000000.0, 2), ' Billion')
        ELSE 
            CONCAT(ROUND(watch_hours / 1000000.0, 2), ' Million')
    END AS watch_hours_converted
FROM df_netflix_era;

--6  Most Watched Genre in 2025

--Question: Which genre dominates in 2025?

select top 1 genre ,round(sum(watch_hours_displays),0) as total_watch_hours from df_netflix_era
where year=2025
group by genre
order by total_watch_hours desc

--- movies vs web series which one has more demand

select content_type ,round(sum(watch_hours_displays),0) as total_watch_hours from df_netflix_era
group by content_type

update df_netflix_era set converted_watch_hrs=
   case when  watch_hours >=1000000000
    then CAST(round(watch_hours /1000000000.0,2) as decimal(10,2))
    else CAST(round(watch_hours/1000000.0,2) as decimal(10,2))
    end


alter table df_netflix_era
add   watch_hours_display  varchar(50);
alter table df_netflix_era
add   watch_hours_displays decimal(10,2)
alter table df_netflix_era
drop column  watch_hours_display_s;
select *  from df_netflix_era;
update df_netflix_era set watch_hours_displays=
    CASE
        WHEN watch_hours >= 1000000000 THEN
           
                CAST(ROUND(watch_hours / 1000000000.0, 2) AS DECIMAL(10,2))
        WHEN watch_hours >= 1000000 THEN
            
                CAST(ROUND(watch_hours / 1000000.0, 2) AS DECIMAL(10,2))
            
        ELSE
         
                CAST(ROUND(watch_hours / 1000.0, 2) AS DECIMAL(10,2))
            
    END ;


select * from df_netflix_era

--9 Movies vs Web Series – Average Rating

--Question: Compare quality perception.
select content_type ,round(avg(Rating),2) as avg_rating from df_netflix_era 
group by content_type;

--🔟 Low-Rated but Highly Watched Content

--Question: Find content with rating < 5 but high demand.

select top 10 title,rating,watch_hours_display from df_netflix_era
where rating < 5
order by watch_hours_display desc;

--11 Pre vs Post COVID Content Consumption

--Question: Did watch hours increase after COVID?
select 
case when year <2020 then 'pre_covid'
   else 'post_covid' end as era ,
   round(avg(watch_hours_displays),2) as avg_watch_hours from df_netflix_era 
   where content_type='Movie'
   group by case when year < 2020 then 'pre_covid'
   else 'post_covid' end 

   --1️2️ Top Genres Driving Revenue Years (JOIN)

--Question: Combine content + revenue.
 select e.genre ,e.year ,round(sum(e.watch_hours_displays ),2) as total_watch_hours,r.revenue_billion_usd 
 from df_netflix_era e  join df3_netflix_revenue r on e.year=r.year
 group by e.genre ,e.year , r.revenue_billion_usd 
 order by e.year , total_watch_hours desc

 --13 Subscriber vs Revenue Relationship

--Question: Show both metrics together.
select e.year,e.subscribers_million,r.revenue_billion_usd from df2_netflix_subscribers e left join 
df3_netflix_revenue r on e.year=r.year
order   by year                        
--14️ Top Content Types Driving Growth After 2020

--Question: What drove post-COVID growth?
 select content_type ,round(sum(watch_hours_displays),2) as total_watch_hours  from  df_netflix_era
 where year >2020
 group by content_type
 order by total_watch_hours desc;

-- 1️5️ Rank Top Genres Each Year (WINDOW)

--Question: Rank genres year-wise.
select  year,genre ,round(sum(watch_hours_displays),2) as total_watch_hours , 
rank() over(partition by year order by round(sum(watch_hours_displays),2)   desc) as genre_rnk  
 from  df_netflix_era

group by year , genre;

SELECT name 
FROM sys.sql_logins;




