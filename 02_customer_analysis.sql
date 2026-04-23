
-- =========================================
-- 🔵 CUSTOMER ANALYTICS
-- E-commerce SQL Project
-- Focus: Customer behavior, retention, revenue contribution
-- =========================================				
				
				
				
				-- CHECKING TABLES 

SELECT * FROM customers LIMIT 5;
SELECT * FROM orders LIMIT 5;
SELECT * FROM order_items LIMIT 5;									
SELECT * FROM order_payments LIMIT 5;
SELECT * FROM order_reviews LIMIT 5;
SELECT * FROM products LIMIT 5;
SELECT * FROM sellers LIMIT 5;
SELECT * FROM geolocation LIMIT 5;
SELECT * FROM product_category LIMIT 5;


						-- 	CUSTOMER ANALYSIS 

--Q1.TOP CUSTOMERS BY REVENUE 
--Purpose : Identify highest spending customers 

	SELECT o.customer_id , SUM(p.payment_value) AS revenue 
	FROM orders o 
	JOIN order_payments p
	ON o.order_id = p.order_id 
	GROUP BY o.customer_id
	ORDER BY revenue DESC 
	LIMIT 10 ; 

--Q2. AVERAGE ORDER VALUE PER CUSTOMER + RANKING 
--Purpose : Measure average spending per order for each customer 

	SELECT o.customer_id , AVG(p.payment_value) AS avg_order_value,
	RANK() OVER( ORDER BY AVG(p.payment_value) desc ) AS rank_order_value 
	FROM orders o 
	JOIN order_payments p
	ON o.order_id = p.order_id 
	GROUP BY o.customer_id ; 
	
--Q3. ONE TIME BUYER'S 
--Purpose : Identify customers who placed only one order 

	SELECT customer_id , COUNT(order_id) AS Total_orders 
	FROM orders 
	GROUP BY customer_id 
	HAVING COUNT(order_id) = 1 ; 

--Q4. REPEAT CUSTOMERS + REVENUE CONTRIBUTION 
--Purpose : Identify customers who placed more than one order 

	SELECT o.customer_id , SUM(p.payment_value) AS revenue 
	FROM orders o 
	JOIN order_payments p 
	ON o.order_id = p.order_id 
	GROUP BY o.customer_id 
	HAVING COUNT(o.order_id) > 1 
	ORDER BY revenue DESC ; 
			  
--Q5. CUSTOMERS SEGMENTION ( LOW / MEDIUM / HIGH ) BASED ON REVENUE 
--Purpose : Group customers based on total revenue 

	SELECT o.customer_id , SUM(p.payment_value) AS revenue, 
	CASE
		WHEN  SUM(p.payment_value) > 1000 THEN 'HIGH VALUE'
		WHEN  SUM(p.payment_value) BETWEEN 500 AND 1000 THEN 'MEDIUM VALYE '
		ELSE 'LOW VALUE' 
	END AS segment 
	FROM orders o 
	JOIN order_payments p 
	ON o.order_id = p.order_Id 
	GROUP BY o.customer_id ; 



	