-- TRENDING THE DATA --
-- to "Technology" category.


-- SIMPLE TRENDS --

-- by day
select orderdate, sales
from superstore
where category="technology"
order by 1

-- by month
select date_format(orderdate,'%Y-%m') as month_date, round(sum(sales)) as sales 
from superstore
where category = 'technology'
group by 1
order by 1

--  by year
select year(orderdate) as year_date, round(sum(sales)) as sales 
from superstore
where category = 'technology'
group by 1
order by 1

-- COMPARING TRENDS --                 
-- Let’s compare the Yearly and Monthly sales trend for a few categories: technology, Furniture, and Office supplies.

-- by year
SELECT year(orderdate) as year, category, round(sum(sales)) as sales 
FROM superstore
WHERE category in ('technology','furniture','office supplies')
GROUP BY 1,2
order by 1,2

-- by month
-- Dense Rank
SELECT date_format(orderdate,'%Y-%m') as month_date, category, round(sum(sales)) as sales
    ,dense_rank() OVER (PARTITION BY date_format(orderdate,'%Y-%b') ORDER BY round(sum(sales)) DESC) AS dense_rank_num
FROM superstore
group by 1,2
order by 1,3 desc

/*
-- se tivesse 5 categorias, mas só quisesse as top 3.
WITH score_analysis
AS (
	SELECT date_format(orderdate,'%Y-%m') as month_date, category, round(sum(sales)) as sales
		,dense_rank() OVER (PARTITION BY date_format(orderdate,'%Y-%b') ORDER BY round(sum(sales)) DESC) AS dense_rank_num
	FROM superstore
	group by 1,2
	order by 1
    )
SELECT month_date, category, sales
FROM score_analysis
WHERE dense_rank_num <= 3;

-- Posso entar selecionar apenas a melhor Category de cada mês
WITH score_analysis
AS (
	SELECT date_format(orderdate,'%Y-%m') as month_date, category, round(sum(sales)) as sales
		,dense_rank() OVER (PARTITION BY date_format(orderdate,'%Y-%b') ORDER BY round(sum(sales)) DESC) AS dense_rank_num
	FROM superstore
	group by 1,2
	order by 1
    )
SELECT month_date, category, sales
FROM score_analysis
WHERE dense_rank_num <= 1
*/


-- calculate the GAP between two categories: Technology and Furniture

-- 1) Pivot
select year(orderdate) as sales_year
		,sum(case when category = 'technology' then round(sales) end) as technology_sales
		,sum(case when category = 'furniture' then round(sales) end) as furniture_sales
from superstore
where category in ('technology', 'furniture')
group by 1
order by 1

-- 2) Subtract
select sales_year
		,technology_sales
        ,furniture_sales
		,technology_sales - furniture_sales as tech_minus_furniture
		,furniture_sales - technology_sales as furniture_minus_tech 
from
(
	select year(orderdate) as sales_year
			,sum(case when category = 'technology' then round(sales) end) as technology_sales
			,sum(case when category = 'furniture' then round(sales)	end) as furniture_sales
	from superstore
	where category in ('technology', 'furniture')
	group by 1
    order by 1
) a

-- Calculate the RATIO between two categories: Technology and Furniture
select sales_year
		,round(technology_sales / furniture_sales, 2) as tech_times_of_furniture
from
(
	select year(orderdate) as sales_year
			,sum(case when category = 'technology' then round(sales) end) as technology_sales
			,sum(case when category = 'furniture' then round(sales)	end) as furniture_sales
	from superstore
	where category in ('technology', 'furniture')
	group by 1
    order by 1
) a

-- Calculate the PERCENTE DIFFERENCE between two categories: technology and furniture
select sales_year
		,round( (technology_sales / furniture_sales -1)*100, 2) as tech_pct_of_furniture
from
(
	select year(orderdate) as sales_year, sum(case when category = 'technology' then round(sales) end) as technology_sales
			,sum(case when category = 'furniture' then round(sales)	end) as furniture_sales
	from superstore
	where category in ('technology', 'furniture')
	group by 1
) a

-- Percent of Total Calculations
-- a) self join, nao deu
SELECT month(orderdate), category, sales * 100 / total_sales as pct_total_sales
FROM
(
	SELECT month(a.orderdate), a.category, month(a.sales), sum(b.sales) as total_sales
	FROM superstore a
		JOIN superstore b on month(a.orderdate) = month(b.orderdate)
		and b.category in ('technology','furniture',"office supplies")
	WHERE a.category in ('technology','furniture',"office supplies")
	GROUP BY 1,2,3
) aa


-- b) window, nao deu
SELECT year(orderdate) as year, month(orderdate) as month, category, sum(sales)
	, sum(sales) over (partition by month(orderdate)) as total_sales
	, sales * 100 / sum(sales) over (partition by month(orderdate)) as pct_total
FROM superstore
WHERE category in ('technology', 'furniture',"office supplies")
group by 1,2

-- pct_total não está certo
SELECT year(orderdate) as year, month(orderdate) as month, category
	, round(sum(sales)) as sales, sales * 100 / sum(sales) over (partition by month(orderdate)) as pct_total
FROM superstore
WHERE category in ('technology','furniture','office supplies')
GROUP BY 1,2,3
order by 1,2,3

-- Indexing to See Percent Change over Time --
SELECT year_date, round(sales) as sales, 
		round(first_value(sales) over (order by sales)) as index_sales
FROM
(
	SELECT year(orderdate) as year_date, sum(sales) as sales
	FROM superstore
	WHERE category = 'technology'
	GROUP BY 1
    order by 1
) a


SELECT year_date, round(sales) as sales
	, round((sales / first_value(sales) over (order by year_date) - 1) * 100, 2)
	as pct_from_index
FROM
(
	SELECT year(orderdate) as year_date, 
			sum(sales) as sales
	FROM superstore
	WHERE category = 'technology'
	GROUP BY 1
) a

SELECT year_date, category, round(sales) as sales
	,round((sales / first_value(sales) over (partition by category order by year_date)- 1) * 100, 2) as pct_from_index
FROM
(
	SELECT year(orderdate) as year_date, category, sum(sales) as sales
	FROM superstore
	WHERE category in ('technology'	,'furniture')
	GROUP BY 1,2
    order by 1
) a
