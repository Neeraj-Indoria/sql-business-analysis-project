


-- =========================================
-- 🟢 BUSINESS OVERVIEW ANALYSIS
-- Project: E-commerce SQL Analytics
-- File: 01_business_overview.sql
-- Description: Revenue, orders, delivery KPIs analysis
-- =========================================
			
		
			
							-- CHECKING AVAILABLE TABLES 

SELECT * FROM customers LIMIT 5;
SELECT * FROM orders LIMIT 5;
SELECT * FROM order_items LIMIT 5;									
SELECT * FROM order_payments LIMIT 5;
SELECT * FROM order_reviews LIMIT 5;
SELECT * FROM products LIMIT 5;
SELECT * FROM sellers LIMIT 5;
SELECT * FROM geolocation LIMIT 5;
SELECT * FROM product_category LIMIT 5;


			

						-- BUSINESS OVERVIEW ANALYSIS

--Q1. TOTAL ORDERS 
--Purpose : Count total number of orders placed

	SELECT COUNT(*) AS total_orders 
	FROM orders ; 
	
--Q2. TOTAL REVENUE 
--Purpose : Calculate overall revenue generated 

	SELECT SUM(payment_value) AS total_revenue 
	FROM order_payments ; 
	
--Q3. MONTHLY REVENUE TREND 
--Purpose : Track revenue growth over time 

	SELECT EXTRACT( MONTH FROM o.order_purchase_timestamp) AS month,
	SUM(op.payment_value) AS revenue 
	FROM orders o
	JOIN order_payments op 
	ON o.order_id = op.order_id 
	GROUP BY month 
	ORDER BY month ; 
			  
	SELECT TO_CHAR(o.order_purchase_timestamp, 'Month YYYY') AS month, 
	SUM(op.payment_value) AS revenue 
	FROM orders o 
	JOIN order_payments op
	ON o.order_id = op.order_id 
	GROUP BY month 
	ORDER BY month ; 

--Q4. PEAK ORDER MONTHS 
--Purpose : Identify months with highest order volume

	SELECT TO_CHAR(order_purchase_timestamp , 'Month YYYY') AS month,
	COUNT(order_id) AS total_orders 
	FROM orders 
	GROUP BY month 
	ORDER BY total_orders DESC ; 

--Q5. AVERAGE DELIVERY TIME 
--Purpose : Calculate average delivery time taken to deliver orders 

	SELECT AVG(EXTRACT ( DAY FROM order_delivered_customer_date - order_purchase_timestamp)) AS avg_delivery_time
	FROM  orders 
	WHERE order_delivered_customer_date IS NOT NULL; 

--Q6. LATE DELIVERY PERCENTAGE 
--Purpose : Measure percentage of late deliveries 

	SELECT (SUM(Case 
	WHEN order_delivered_customer_date > order_estimated_delivery_date THEN 1 ELSE 0
	END 
	) * 100.0) / COUNT (*) AS late_delivery_percentage 
	FROM orders 
	WHERE order_estimated_delivery_date IS NOT NULL ; 

--Q7. REVENUE LOST DUE TO CANCELLATION 
--Purpose : Estimate revenue loss from cancelled orders 

	SELECT SUM(op.payment_value) AS lost_revenue 
	FROM orders o 
	JOIN order_payments op 
	ON o.order_id = op.order_id 
	WHERE o.order_status = 'canceled' ;


	