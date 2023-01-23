-- PIVOT: total sales per customer name. --
SELECT customerid, customername, round(sum(sales)) as total_sales, count(*) as records
FROM superstore
GROUP BY customername
order by customername


-- PIVOT: total sales per segment. --
select segment, round(sum(sales)) as total_sales, count(*) as records
from superstore
group by segment


-- Total sales
select round(sum(sales)) as total_sales
from superstore

-- PIVOT: total sales per city. --
select city, round(sum(sales)) as total_sales
from superstore
group by 1
order by total_sales desc

-- PIVOT: total sales per state. --
select state, round(sum(sales)) as total_sales
from superstore
group by 1
order by total_sales desc

-- PIVOT: total sales per category. --
select category, round(sum(sales)) as total_sales
from superstore
group by 1
order by total_sales desc

-- PIVOT: total sales per subcategory. --
select subcategory, round(sum(sales)) as total_sales
from superstore
group by 1
order by total_sales desc

-- PIVOT: total sales per productname. --
select productname, round(sum(sales)) as total_sales
from superstore
group by 1
order by total_sales desc
