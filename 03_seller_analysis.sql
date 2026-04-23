
-- =========================================
-- 🟣 SELLER ANALYTICS
-- E-commerce SQL Project
-- Focus: Seller performance, revenue, delivery efficiency
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


						-- 	SELLER'S ANALYSIS 

--Q1. TOP SELLERS BY REVENUE 
--Purpose : Identify sellers generating highest revenue 

	SELECT oi.seller_id, SUM(op.payment_value) AS total_revenue 
	FROM order_items oi 
	JOIN order_payments op 
	ON oi.order_id = op.order_id 
	GROUP BY oi.seller_id 
	ORDER BY total_revenue DESC 
	LIMIT 10 ; 
			  
--Q2. SELLER RANKING ( REVENUE + VALUME )
--Purpose : Rank sellers based on revenue and order volume

	SELECT oi.seller_id , COUNT(oi.order_id) AS total_orders ,
	SUM(op.payment_value) AS total_revenue ,
	RANK() OVER( ORDER BY  SUM(op.payment_value) DESC ) AS ranking 
	FROM order_items oi 
	JOIN order_payments op 
	ON oi.order_id = op.order_id 
	GROUP BY oi.seller_id
	 ;

--Q3. AVG DELIVERY TIME PER SELLER 
--Purpose : Measure seller delivery efficiency 

	SELECT oi.seller_id , AVG(o.order_delivered_customer_date - o.order_purchase_timestamp) AS avg_delivery_time 
	FROM order_items oi 
	JOIN orders o 
	ON oi.order_id = o.order_id 
	GROUP by oi.seller_id ; 

--Q4. SELLERS WITH DELAYED DELIVERIES 
--Purpose : Identify sellers responsible for late deliveries 

	SELECT oi.seller_id , COUNT( CASE 
	WHEN  o.order_delivered_customer_date > o.order_estimated_delivery_date  THEN 1 ELSE 0 
	END  ) AS delay_deliveries 
	FROM order_items oi 
	JOIN orders o
	ON oi.order_id = o.order_id 
	GROUP BY oi.seller_id ; 

--Q5. SELLERS SATISFACTION RANKING 
--Purpose : Evaluate seller performance using customer ratings 

	WITH seller_reviews AS (
	SELECT oi.seller_id , AVG(r.review_score) AS avg_rating, COUNT(r.review_score) AS review_count
	FROM order_items oi 
	JOIn order_reviews r 
	ON oi.order_id = r.order_id 
	GROUP BY oi.seller_id 
	)
	SELECT *, 
	RANK() OVER( ORDER BY avg_rating DESC, review_count DESC ) AS seller_rank
	FROM seller_reviews
	ORDER BY seller_rank ; 
