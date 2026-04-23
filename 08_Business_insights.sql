

-- =========================================
-- 🧠 BUSINESS INSIGHTS
-- Project: SQL Business Analytics
-- =========================================

								--	CHECKING TABLES 
							
SELECT * FROM orders LIMIT 5;
SELECT * FROM order_items LIMIT 5;
SELECT * FROM order_payments LIMIT 5;
SELECT * FROM order_reviews LIMIT 5;
SELECT * FROM products LIMIT 5;
SELECT * FROM sellers LIMIT 5;
SELECT * FROM geolocation LIMIT 5;
SELECT * FROM product_category LIMIT 5;



								-- BUSINESS INSIGHTS 

--Q1. CUSTOMER LIFE TIME VALUE 
--- Purpose: Identify total revenue generated per customer

	SELECT c.customer_id , COUNT( DISTINCT o.order_id) AS total_orders , 
	SUM( oi.price + oi.freight_value) AS lifetime_value,
	AVG( oi.price + oi.freight_value) AS avg_order_value 
	FROM customers c 
	JOIN orders o 
	ON c.customer_id = o.customer_id 
	JOIN order_items oi
	ON o.order_id = oi.order_id 
	GROUP BY c.customer_id 
	ORDER BY lifetime_value desc ; 

	SELECT * from order_items ; 

--Q2. COHORT ANALYSIS  CUSTOMER RETENTION 
--Track how many customers return in subsequent months after first purchase 

	WITH first_purchase AS (
	SELECT c.customer_unique_id , 
	MIN(DATE_TRUNC( 'month' ,o.order_purchase_timestamp)) AS cohort_month 
	FROM customers c 
	JOIN orders o
	ON c.customer_id = o.customer_id 
	GROUP BY c.customer_unique_id
	),
	cohort_data AS (
	SELECT c.customer_unique_id, f.cohort_month,
	DATE_TRUNC('month', o.order_purchase_timestamp) AS order_month 
	FROM customers c 
	JOIN orders o
	ON c.customer_id = o.customer_id 
	JOIN first_purchase f 
	ON c.customer_unique_id = f.customer_unique_id 
	)
	
	SELECT cohort_month , order_month , COUNT(customer_unique_id) AS active_customers 
	FROM cohort_data 
	GROUP BY cohort_month , order_month 
	ORDER BY cohort_month , order_month ; 

--Q3. PARETO ( 80/20 REVENUE RULE ) 
--Purpose: Identify TOP  customers contributing majority revenue	

	WITH customers_revenue AS (
	SELECT c.customer_id , SUM(oi.price + oi.freight_value) AS Revenue 
	FROM customers c 
	JOIN orders o 
	ON c.customer_id = o.customer_id
	JOIN order_items oi 
	ON o.order_id = oi.order_id
	GROUP BY c.customer_id 
	ORDER BY Revenue DESC 
	),
	ranked AS (
	SELECT *,
	SUM(revenue) OVER( ORDER BY revenue DESC ) AS running_total,
	SUM(revenue) OVER() AS total_revenue
	FROM customers_revenue  
	)
	SELECT customer_id , running_total, total_revenue,
	ROUND((running_total / total_revenue) * 100,2 ) AS comulative_percentage
	FROM ranked 
	ORDER BY comulative_percentage desc;

--Q4. REVIEW VS REVENUE CORRELATON 
--- Purpose: Analyze relationship between spending and ratings

	WITH revenue_review AS (
	SELECT c.customer_id , r.review_score ,COUNT( o.order_id) AS total_orders ,
	SUM(oi.price + oi.freight_value) AS revenue 
	FROM customers c 
	JOIN orders o 
	ON c.customer_id = o.customer_id 
	JOIN order_reviews r
	ON o.order_id = r.order_id 
	JOIN order_items oi 
	ON o.order_id = oi.order_id 
	GROUP by c.customer_id , r.review_score
	)
	SELECT customer_id , total_orders , revenue ,
	AVG(revenue) AS avg_revenue
	FROM revenue_review 
	GROUP BY customer_id , total_orders , revenue 
	ORDER BY avg_revenue desc ;

