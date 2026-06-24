--1.Total Revnue
select 
round(sum(payment_value)::numeric,2) as total_revenue
from order_payments;

--2.Monthly Revenue Trend
select
to_char(o.order_purchase_timestamp, 'YYYY-MM') as month,
round(sum(op.payment_value)::numeric, 2) monthly_revenue
from orders o
join order_payments op on o.order_id=op.order_id
where o.order_status='delivered'
group by month
order by month;

--3.Top 10 Categories by Revenue
select
ct.product_category_name_english as category,
round(sum(oi.price)::numeric,2) as total_revenue
from order_items oi
join products p on oi.product_id=p.product_id
join category_translation ct on p.product_category_name=ct.product_category_name
where p.product_category_name is not null
group by category
order by total_revenue desc
limit 10;

--4.Average Order Value
select 
round(avg(payment_value)::numeric,2)
from order_payments where payment_value>0;

--5.Top 5 States Orders
select
c.customer_state as state,
count(o.order_id) as total_orders
from orders o
join customers c on o.customer_id=c.customer_id
group by state
order by total_orders desc
limit 5;

--6.Orders by Payment Method
select
payment_type,
count(*) as total_transactions,
round(sum(payment_value)::numeric,2) as total_revenue
from order_payments
group by payment_type
order by total_revenue desc;

--7.Average Delivery Days
SELECT 
ROUND(AVG(EXTRACT(EPOCH FROM (order_delivered_customer_date - order_purchase_timestamp)) / 86400
    )::numeric, 1) AS avg_delivery_days
FROM orders
WHERE order_status = 'delivered'
AND order_delivered_customer_date IS NOT NULL;

--8.Order Status Distribution
SELECT 
order_status,
COUNT(*) AS total_orders,
ROUND(COUNT(*) * 100.0 / SUM(COUNT(*)) OVER(), 2) AS percentage
FROM orders
GROUP BY order_status
ORDER BY total_orders DESC;

--9.Revenue by Year
SELECT 
EXTRACT(YEAR FROM order_purchase_timestamp) AS year,
ROUND(SUM(op.payment_value)::numeric, 2) AS yearly_revenue
FROM orders o
JOIN order_payments op ON o.order_id = op.order_id
WHERE o.order_status = 'delivered'
GROUP BY year
ORDER BY year;
