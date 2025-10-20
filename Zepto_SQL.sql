select*from zepto_v2
use zepto

#add a column called serial numnbers
ALTER TABLE zepto_v2
ADD COLUMN sku_id INT AUTO_INCREMENT PRIMARY KEY FIRST;

--#data exploration 
 
#count of rows
select count(*) from zepto_v2

#sample data
select * from zepto_v2
limit 10;

#check for null values 
select*from zepto_v2 
where name is NULL
or 
Category is null
or 
MRP is null
or 
Discount_Percentage is null
or 
availability_quantity is null
or
discounted_selling_price is null
or
weight_in_grms is null
or 
Out_of_stock is null

--count how many null values you have per column
SELECT 
    SUM(category IS NULL) AS category_nulls,
    SUM(name IS NULL) AS name_nulls,
    SUM(MRP IS NULL) AS mrp_nulls,
    SUM(Discount_Percentage IS NULL) AS discount_nulls,
    SUM(availability_Quantity IS NULL) AS avail_qty_nulls,
    SUM(discounted_selling_price IS NULL) AS disc_price_nulls,
    SUM(weight_in_grms IS NULL) AS weight_nulls,
    SUM(Out_of_stock IS NULL) AS out_of_stock_nulls,
    SUM(quantity IS NULL) AS quantity_nulls
FROM zepto_v2;

--different product categories check
select distinct category 
from zepto_v2
order by category;

--different product categories with their count

SELECT 
    category,
    COUNT(*) AS category_count
FROM zepto_v2
GROUP BY category
ORDER BY category_count DESC;

--products in stock vs out of stock

select Out_of_stock, count(sku_id)
from zepto_v2
group by Out_of_stock;

--product names present mutiple time or placed more time
select name, count(sku_id) as "Number of SKUs"
from zepto_v2
group by name
having count(sku_id)>1
order by count(sku_id) desc;

--Data Cleaning

--product with price =0
select * from zepto_v2
where MRP=0 

#delete that row which has 0 mrp
delete from zepto_v2
where MRP=0;

SET SQL_SAFE_UPDATES = 0;
DELETE FROM zepto_v2
WHERE MRP = 0;

--convert mrp to paise to rupees
update zepto_v2
set MRP = MRP / 100.0;









SQL PROJECT ON ZEPTO INVENTORY DATA
-- Q1. Find the top 10 best-value products based on the discount percentage
SELECT name, category, MRP, Discount_Percentage
FROM zepto_v2
ORDER BY Discount_Percentage DESC
LIMIT 10;

-- Q2. What are the Products with High MRP but Out of Stock
SELECT name, category, MRP, Out_of_stock
FROM zepto_v2
WHERE Out_of_stock = TRUE;

-- Q3. Calculate Estimated Revenue for each category
-- (Estimated Revenue = discounted_selling_price * availability_Quantity)
SELECT category,
       SUM(discounted_selling_price * availability_Quantity) AS estimated_revenue
FROM zepto_v2
GROUP BY category
ORDER BY estimated_revenue DESC;

-- Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT name, category, MRP, Discount_Percentage
FROM zepto_v2
WHERE MRP > 500 AND Discount_Percentage < 10;

-- Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
       AVG(Discount_Percentage) AS avg_discount
FROM zepto_v2
GROUP BY category
ORDER BY avg_discount DESC
LIMIT 5;

-- Q6. Find the price per gram for products above 100g and sort by best value.
-- (price per gram = discounted_selling_price / weight_in_grms)
SELECT name, category, discounted_selling_price, weight_in_grms,
       (discounted_selling_price / weight_in_grms) AS price_per_gram
FROM zepto_v2
WHERE weight_in_grms > 100
ORDER BY price_per_gram ASC;

-- Q7. Group the products into categories like Low (<100g), Medium (100g–500g), Bulk (>500g).
SELECT name, category, weight_in_grms,
       CASE
         WHEN weight_in_grms < 100 THEN 'Low'
         WHEN weight_in_grms BETWEEN 100 AND 500 THEN 'Medium'
         ELSE 'Bulk'
       END AS weight_category
FROM zepto_v2;

-- Q8. What is the Total Inventory Weight Per Category
SELECT category,
       SUM(weight_in_grms * availability_Quantity) AS total_inventory_weight
FROM zepto_v2
GROUP BY category
ORDER BY total_inventory_weight DESC;





