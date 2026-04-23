

-- =========================================
-- 🔴 PAYMENT ANALYTICS
-- E-commerce SQL Project
-- Focus: Payment behavior, revenue distribution
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


								-- PAYMENT ANALYTICS 

--Q1. MOST USED PAYMENT METHOD 
-- Purpose: Identify preferred payment methods
	SELECT DISTINCT payment_type , COUNT(order_id) AS totaL_transactions 
	FROM order_payments 
	GROUP BY payment_type
	ORDER BY total_orders desc 
	LIMIT 1 ; 

--Q2. REVENUE PER PAYMENT TYPE 
-- Purpose: Analyze revenue contribution per payment method

	SELECT DISTINCT payment_type , SUM(payment_value) AS revenue
	FROM order_payments 
	GROUP BY payment_type 
	ORDER BY revenue DESC ; 