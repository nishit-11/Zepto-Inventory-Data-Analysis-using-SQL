drop table if exists zepto;

create table zepto(
s_id serial primary key,
category varchar(120),
name varchar(150) not null,
mrp numeric(8,2),
discountPercent numeric(5,2),
availableQuantity integer,
discountedSellingPrice numeric(8,2),
weightInGms integer,
outOfStock boolean,
quantity integer
);
 -- Data Exploration 
select count(*) from zepto;
-- sample data 
select * from zepto
limit 10;
-- null values
select * from zepto
where category is NULL
or 
name is NULL
or 
mrp is NULL
or 
discountPercent is NULL
or 
availableQuantity is NULL
or 
discountedSellingPrice is NULL
or 
weightInGms is NULL
or 
outOfStock is NULL
or 
quantity is NULL;

--different product categories

select distinct category
from zepto
order by category;

-- no. of products inStock and outOfStock

select outOfStock, count(s_id)
from zepto
group by outOfStock;

--Products present multiple times

select name, count(s_id) as "Number of Products"
from zepto
group by name
having count(s_id) > 1
order by count(s_id) desc;

-- Data Cleaning

--Products with price "0"

select * from zepto
where mrp = 0
or
discountedSellingPrice = 0;

delete from zepto 
where mrp = 0;

-- convert paise to rupees

update zepto
set mrp = mrp/100.0,
discountedSellingPrice = discountedSellingPrice/100.0;

select mrp,discountedSellingPrice from zepto;

-- Top 10 Discounted Products 

select distinct name, mrp, discountPercent
from zepto
order by discountPercent desc
limit 10;

-- High MRP Products but Out of Stock

select distinct name, mrp 
from zepto 
where outOfStock = True and mrp>300
order by mrp desc;

-- Estimated Revenue for each category

select category,
sum (discountedSellingPrice * availablequantity) as Total_Revenue
from zepto
group by category
order by Total_Revenue;

-- Products where MRP>500 and Discount is less than 10%

select distinct name, mrp, discountPercent from zepto
where mrp > 500 and discountPercent < 10
order by mrp desc, discountPercent desc;

--Top 5 categories offering hghest average discount percentage

select category,
avg(discountPercent) as avg_discount
from zepto
group by category
order by avg_discount desc
limit 5;

-- Price per gram for products above 100g and sort by best value

select distinct name, weightInGms, discountedSellingPrice,
round(discountedSellingPrice/weightInGms,2) as price_per_gm
from zepto
where weightInGms >= 100
order by price_per_gm;

--Group products into categories of Low,Medium,Bulk

select distinct name, weightInGms, 
case when weightInGms < 1000 then 'low'
when weightInGms <5000 then 'Medium'
else 'Bulk'
end as weight_category
from zepto;

--Total Inventory Weight Per Category

select category,
sum(weightInGms * availableQuantity) as total_weight
from zepto
group by category
order by total_weight;