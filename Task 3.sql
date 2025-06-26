-- SQL Script for Elevate Labs - SQL Developer Internship - Task 3: Advanced SELECT Queries
-- Domain: E-commerce Platform

-- This script demonstrates advanced SELECT queries based on the E-commerce schema (from Task 1)
-- and assumes the database has been populated with data (from Task 2).

USE super_advanced_ecommerce_db;

-- -----------------------------------------------------
-- 1. Basic SELECT Statements (Projection)
-- -----------------------------------------------------

-- Select all columns from the 'users' table
SELECT * FROM `users`;

-- Select specific columns (username, email) from the 'users' table
SELECT `username`, `email` FROM `users`;

[cite_start]-- Select distinct roles from the 'users' table [cite: 5]
SELECT DISTINCT `role` FROM `users`;

[cite_start]-- Select product names and their base prices [cite: 1]
SELECT `product_name`, `base_price` FROM `products`;

-- -----------------------------------------------------
[cite_start]-- 2. Filtering Data with WHERE Clause [cite: 1]
-- -----------------------------------------------------

-- Select users with the role 'Customer'
SELECT * FROM `users` WHERE `role` = 'Customer';

-- Select products with a base price greater than 50.00
SELECT `product_name`, `base_price` FROM `products` WHERE `base_price` > 50.00;

[cite_start]-- Select orders that are 'Pending' or 'Processing' [cite: 1]
SELECT `order_id`, `order_status` FROM `orders` WHERE `order_status` = 'Pending' OR `order_status` = 'Processing';

[cite_start]-- Select products from category_id 1 AND with base price less than 100.00 [cite: 1]
SELECT `product_name`, `base_price`, `category_id` FROM `products` WHERE `category_id` = 1 AND `base_price` < 100.00;

[cite_start]-- Select products whose names start with 'Smart' using LIKE [cite: 1]
SELECT `product_name`, `description` FROM `products` WHERE `product_name` LIKE 'Smart%';

-- Select products whose names contain 'phone'
SELECT `product_name`, `description` FROM `products` WHERE `product_name` LIKE '%phone%';

-- Select users whose email addresses end with '.com'
SELECT `username`, `email` FROM `users` WHERE `email` LIKE '%.com';

[cite_start]-- Select products with base price between 20.00 and 200.00 (inclusive) [cite: 1]
SELECT `product_name`, `base_price` FROM `products` WHERE `base_price` BETWEEN 20.00 AND 200.00;

-- Select products created in 2024
SELECT `product_name`, `created_at` FROM `products` WHERE `created_at` BETWEEN '2024-01-01 00:00:00' AND '2024-12-31 23:59:59';

[cite_start]-- Select users whose `user_id` is 1, 3, or 5 using IN operator [cite: 4]
SELECT `username`, `email` FROM `users` WHERE `user_id` IN (1, 3, 5);

-- Select products that are NOT active
SELECT `product_name`, `is_active` FROM `products` WHERE `is_active` = 0;

[cite_start]-- Select customer profiles where phone number IS NULL [cite: 15, 16]
SELECT `first_name`, `last_name` FROM `customer_profiles` WHERE `phone_number` IS NULL;

-- -----------------------------------------------------
[cite_start]-- 3. Sorting Data with ORDER BY [cite: 1]
-- -----------------------------------------------------

[cite_start]-- Select all products, ordered by base price in ascending order (default) [cite: 5]
SELECT `product_name`, `base_price` FROM `products` ORDER BY `base_price`;

[cite_start]-- Select all products, ordered by base price in descending order [cite: 5]
SELECT `product_name`, `base_price` FROM `products` ORDER BY `base_price` DESC;

-- Select users, ordered by registration date in descending order, then by username in ascending order
SELECT `username`, `registration_date` FROM `users` ORDER BY `registration_date` DESC, `username` ASC;

-- Select product reviews, ordered by rating descending, then review date descending
SELECT `product_id`, `rating`, `review_date` FROM `product_reviews` ORDER BY `rating` DESC, `review_date` DESC;

-- -----------------------------------------------------
[cite_start]-- 4. Limiting Output Rows with LIMIT [cite: 1]
-- -----------------------------------------------------

-- Select the top 5 most expensive products
SELECT `product_name`, `base_price` FROM `products` ORDER BY `base_price` DESC LIMIT 5;

-- Select the 3 most recently registered users
SELECT `username`, `registration_date` FROM `users` ORDER BY `registration_date` DESC LIMIT 3;

-- Select 2 products starting from the 3rd one (offset 2)
SELECT `product_name`, `base_price` FROM `products` ORDER BY `product_id` LIMIT 2 OFFSET 2;

-- -----------------------------------------------------
[cite_start]-- 5. Aliasing Columns and Tables (Optional, but good practice) [cite: 5]
-- -----------------------------------------------------

-- Alias columns for readability
SELECT
    `product_name` AS `Product Name`,
    `base_price` AS `Unit Price`
FROM `products`;

-- Alias tables for shorter queries, especially in joins (though not explicitly required for basic SELECTs)
SELECT
    u.username,
    cp.first_name,
    cp.last_name
FROM
    `users` AS u
JOIN
    `customer_profiles` AS cp ON u.user_id = cp.user_id;

-- -----------------------------------------------------
-- 6. Combining Clauses
-- -----------------------------------------------------

-- Select active products from category 2, ordered by price descending, limit 10
SELECT `product_name`, `base_price`
FROM `products`
WHERE `is_active` = 1 AND `category_id` = 2
ORDER BY `base_price` DESC
LIMIT 10;

-- Select distinct cities from addresses, sorted alphabetically
SELECT DISTINCT `city` FROM `addresses` ORDER BY `city` ASC;