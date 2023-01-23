-- PIVOT: Total sales per customer name --
SELECT customerid
      ,customername
      ,round(sum(sales)) as total_sales
      ,count(*) as records
FROM superstore
GROUP BY customername
order by customername


-- PIVOT: Total sales per segment --
SELECT segment
      ,round(sum(sales)) as total_sales
      ,count(*) as records
FROM superstore
GROUP BY segment


-- Total sales
SELECT round(sum(sales)) as total_sales
FROM superstore

-- PIVOT: Total sales per city --
SELECT city
      ,round(sum(sales)) as total_sales
FROM superstore
GROUP BY 1
ORDER BY total_sales desc

-- PIVOT: Total sales per state --
SELECT state
       ,round(sum(sales)) as total_sales
FROM superstore
GROUP BY 1
ORDER BY total_sales desc

-- PIVOT: Total sales per category --
SELECT category
      ,round(sum(sales)) as total_sales
FROM superstore
GROUP BY 1
ORDER BY total_sales desc

-- PIVOT: Total sales per subcategory --
SELECT subcategory, round(sum(sales)) as total_sales
FROM superstore
GROUP BY 1
ORDER BY total_sales desc

-- PIVOT: Total sales per productname --
SELECT productname, round(sum(sales)) as total_sales
FROM superstore
GROUP BY 1
ORDER BY total_sales desc
