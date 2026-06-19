

  Select * FROM Sales

--Q1: Retrieve all orders with a TotalPrice greater than $500
select * 
from
     sales
where
     totalprice > 500;

--Q2: Retrieve all orders where the OrderStatus is 'Cancelled'
select * 
from
     sales
where
     orderstatus = 'cancelled';


--Q3: Retrieve orders where PaymentMethod is 'Credit Card' and TotalPrice > $1000
select 
      * 
from
     sales
where
     totalprice > 1000 and paymentmethod = 'credit card';


--Q4: Calculate total revenue (SUM) and total orders (COUNT) for each Product
select 
      product,
      count(*) as total_orders,
      sum(totalprice) as revenue
from sales
group by product
order by revenue desc;
      
--Q5: Calculate average order value (AVG) for each OrderStatus
select 
      orderstatus,
      avg(totalprice) as avg_order_value
from sales
group by orderstatus
order by avg_order_value desc;

--Q6: Find the minimum, maximum, and average TotalPrice for each PaymentMethod
select 
      paymentmethod,
      min(totalprice) as min_order_value,
      max(totalprice) as max_order_value,
      avg(totalprice) as avg_order_value
from sales
group by paymentmethod
order by avg_order_value desc;

--Q7: Count the number of orders for each ReferralSource
select 
      referralsource,
      count(*) as total_orders
from sales
group by referralsource
order by total_orders desc;

--Q8: Calculate total revenue by Product AND OrderStatus
select 
      product,
      orderstatus,
      sum(totalprice) as total_revenue
from sales
group by Product, OrderStatus
order by total_revenue desc;
    
--Q9: Count orders by PaymentMethod AND OrderStatus
select 
    paymentmethod,
    orderstatus,
    count(*) as order_count
from sales
group by paymentmethod, orderstatus;

--Q10: Find products with total revenue greater than $10,000
select 
    product,
    sum(totalprice) as total_revenue
from sales
group by product
having sum(totalprice) > 10000;

--Q11: Find OrderStatuses that have more than 100 orders
select 
    orderstatus,
    count(*) as order_count
from sales
group by orderstatus
having count(*) > 100;

--Q12: Find ReferralSources with average order value greater than $800
select 
    referralsource,
    avg(totalprice) as avg_order_value
from sales
group by referralsource
having avg(totalprice) > 800;


--Q13: Find PaymentMethods that generated revenue greater than $50,000
select 
    paymentmethod,
    sum(totalprice) as total_revenue
from sales
group by paymentmethod
having sum(totalprice) > 50000;
--Q14: List all orders sorted by TotalPrice in descending order (highest first)
select *
from sales
order by totalprice desc;

--Q15: List products by total revenue in descending order (highest revenue first)
select
     product,
     sum(totalprice) as total_revenue
from sales
group by product
order by total_revenue desc;

--Q16: List OrderStatuses by count in descending order
select
     orderstatus,
     count(*) as total_count
from sales
group by orderstatus
order by total_count desc;

--Q17: For each Product, calculate total revenue, average order value, and order count. Only show products with more than 50 orders. Sort by total revenue descending.
select 
      product,
      sum(totalprice) as total_revenue,
      count(*) as order_count,
      avg(totalprice) as avg_order_value
from sales
group by product
having count(*) > 50
order by total_revenue desc;

--Q18: For each PaymentMethod, calculate total revenue and order count. Only show PaymentMethods with average order value greater than $500. Sort by total revenue descending.
select 
      paymentmethod,
      sum(totalprice) as total_revenue,
      count(*) as order_count
from sales
group by paymentmethod
having avg(totalprice) > 500
order by total_revenue desc;

--Q19: For each ReferralSource, calculate total revenue and average order value. Only show sources with more than 30 orders. Sort by average order value descending.
select 
      referralsource,
      sum(totalprice) as total_revenue,
      avg(totalprice) as avg_order_value
from sales
group by referralsource
having count(*) > 30
order by avg_order_value desc;

--Q20: Calculate monthly revenue (group by month). Only show months with revenue greater than $5,000. Sort by month.
select
    datename(month, date) as months,
    sum(totalprice) as total_revenue
from sales
group by datename(month, date), month(date)
having sum(totalprice) > 5000
order by month(date);

/*--Q21: For each Product, calculate total revenue and order count. Only include orders that are NOT Cancelled.
Only show products with total revenue > $5,000. Sort by total revenue descending.*/
select 
      product,
      sum(totalprice) as total_revenue,
      count(OrderID) as order_count
from sales
where orderstatus != 'cancelled'
group by product
having sum(totalprice) > 5000
order by total_revenue desc;


/* Q22: For each PaymentMethod, calculate total revenue and average order value. Only include orders that are Delivered.
Only show PaymentMethods with average order value > $600. Sort by total revenue descending.*/
select 
      paymentmethod,
      sum(totalprice) as revenue,
      avg(totalprice) as avg_order_value
from sales
where orderstatus = 'delivered'
group by paymentmethod
having avg(totalprice) > 600
order by revenue desc;

WITH Stats AS (
    SELECT 
        totalprice,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY totalprice) OVER() AS Q1,
        PERCENTILE_CONT(0.5) WITHIN GROUP (ORDER BY totalprice) OVER() AS Median,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY totalprice) OVER() AS Q3
    FROM sales
)
SELECT 
    MIN(totalprice) AS Minimum,
    MAX(Q1) AS Q1,
    MAX(Median) AS Median,
    MAX(Q3) AS Q3,
    MAX(totalprice) AS Maximum
FROM Stats;

SELECT 
    COUNT(*) AS Total_Orders,
    SUM(totalprice) AS Total_Revenue,
    AVG(totalprice) AS Average_Order_Value,
    (COUNT(CASE WHEN orderstatus IN ('Delivered', 'Shipped') THEN 1 END) * 100.0 / COUNT(*)) AS Fulfillment_Rate
FROM sales;


