

-- =========================================
-- 🟠 DELIVERY & OPERATIONS ANALYTICS
-- E-commerce SQL Project
-- Focus: Delivery performance, delays, service quality
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


					
								-- DELIVERY & OPERATIONS Analysis 

--Q1. DELAY VS REVIEW_SCORE 
-- Purpose: Understand how delays affect customer ratings

	WITH delivery_status AS (
	SELECT o.order_id , r.review_score , 
	CASE 
		WHEN o.order_delivered_customer_date > o.order_estimated_delivery_date
		THEN 'delayed' ELSE 'On Time' 
		END AS delivery_details 
	FROM orders o 
	JOIN order_reviews  r 
	ON o.order_id = r.order_id 
	GROUP BY o.order_id , r.review_score 
	)
	SELECT	delivery_details , 
	AVG(review_score) AS avg_review_score ,
	COUNT(*) as total_orders
	FROM delivery_status 
	GROUP by delivery_details ; 

--Q2. TOP FASTEST DELIVERY ORDERS 
--Purpose : identify orders delivered in the shortest time 

	SELECT DISTINCT  order_id , ( order_delivered_customer_date - order_purchase_timestamp) AS delivery_time 
	FROM orders 
	GROUP by order_id 
	ORDER BY delivery_time
	LIMIT 10 ; 

--Q3. TOP SELLERS PER STATE 
--Purpose : Identify the highest performing seller in each state 

	WITH seller_state_revenue AS (
	SELECT DISTINCT s.seller_id , s.seller_state , SUM(op.payment_value) AS Revenue 
	FROM sellers s 
	JOIN order_items oi 
	ON s.seller_Id = oi.seller_id 
	JOIN order_payments op 
	ON oi.order_id = op.order_id 
	GROUP BY s.seller_id , s.seller_state  

	),
	ranked_sellers AS (
	SELECT *, 
	RANK() OVER( PARTITION BY seller_state ORDER by REVENUE DESC ) AS rank_sellers 
	FROM seller_state_revenue
	)
	SELECT seller_id , seller_state , revenue 
	FROM ranked_sellers 
	WHERE rank_sellers = 1 ; 
	
	

 