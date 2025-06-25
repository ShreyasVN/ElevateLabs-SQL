-- Create Database
CREATE DATABASE IF NOT EXISTS super_advanced_ecommerce_db;
USE super_advanced_ecommerce_db;

-- 1. Create Users Table (for authentication and general user data)
CREATE TABLE Users (
    user_id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) UNIQUE NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL, -- Store hashed passwords
    role ENUM('Customer', 'Admin', 'Guest') DEFAULT 'Customer',
    registration_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    last_login TIMESTAMP
);

-- Index for faster user lookups
CREATE INDEX idx_users_email ON Users(email);
CREATE INDEX idx_users_username ON Users(username);


-- 2. Create Customer_Profiles Table (Specific customer details, linked to Users)
CREATE TABLE Customer_Profiles (
    customer_profile_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE NOT NULL, -- One-to-One relationship with Users
    first_name VARCHAR(50) NOT NULL,
    last_name VARCHAR(50) NOT NULL,
    phone_number VARCHAR(20),
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 3. Create Addresses Table (Reusable addresses for users)
CREATE TABLE Addresses (
    address_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    address_line1 VARCHAR(255) NOT NULL,
    address_line2 VARCHAR(255),
    city VARCHAR(100) NOT NULL,
    state VARCHAR(100) NOT NULL,
    zip_code VARCHAR(10) NOT NULL,
    country VARCHAR(100) NOT NULL,
    address_type ENUM('Shipping', 'Billing') NOT NULL,
    is_default BOOLEAN DEFAULT FALSE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- Index for faster address retrieval by user
CREATE INDEX idx_addresses_user_id ON Addresses(user_id);


-- 4. Create Categories Table
CREATE TABLE Categories (
    category_id INT AUTO_INCREMENT PRIMARY KEY,
    category_name VARCHAR(100) UNIQUE NOT NULL,
    description TEXT,
    parent_category_id INT, -- For hierarchical categories
    FOREIGN KEY (parent_category_id) REFERENCES Categories(category_id) ON DELETE SET NULL
);

-- 5. Create Suppliers Table
CREATE TABLE Suppliers (
    supplier_id INT AUTO_INCREMENT PRIMARY KEY,
    supplier_name VARCHAR(100) NOT NULL,
    contact_person VARCHAR(100),
    email VARCHAR(100) UNIQUE,
    phone_number VARCHAR(20),
    address VARCHAR(255)
);

-- 6. Create Products Table (Base product information)
CREATE TABLE Products (
    product_id INT AUTO_INCREMENT PRIMARY KEY,
    product_name VARCHAR(255) NOT NULL,
    description TEXT,
    base_price DECIMAL(10, 2) NOT NULL CHECK (base_price > 0),
    category_id INT,
    supplier_id INT,
    image_url VARCHAR(255),
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (category_id) REFERENCES Categories(category_id) ON DELETE SET NULL,
    FOREIGN KEY (supplier_id) REFERENCES Suppliers(supplier_id) ON DELETE SET NULL
);

-- Indexes for products
CREATE INDEX idx_products_category_id ON Products(category_id);
CREATE INDEX idx_products_supplier_id ON Products(supplier_id);
CREATE FULLTEXT INDEX idx_products_name_desc ON Products(product_name, description); -- For text search

-- 7. Create Product_Variants Table (For different options of a product, e.g., size, color)
CREATE TABLE Product_Variants (
    variant_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    sku VARCHAR(100) UNIQUE NOT NULL, -- Stock Keeping Unit
    attributes JSON, -- e.g., {"color": "Red", "size": "M", "material": "Cotton"}
    price_adjustment DECIMAL(10, 2) DEFAULT 0, -- Price difference from base product
    stock_quantity INT NOT NULL CHECK (stock_quantity >= 0),
    image_url VARCHAR(255), -- Specific image for this variant
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE
);

-- Index for product variants
CREATE INDEX idx_product_variants_product_id ON Product_Variants(product_id);
CREATE INDEX idx_product_variants_sku ON Product_Variants(sku);

-- 8. Create Product_Reviews Table
CREATE TABLE Product_Reviews (
    review_id INT AUTO_INCREMENT PRIMARY KEY,
    product_id INT NOT NULL,
    user_id INT NOT NULL, -- User who wrote the review
    rating INT NOT NULL CHECK (rating >= 1 AND rating <= 5),
    comment TEXT,
    review_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    UNIQUE (product_id, user_id) -- A user can review a product only once
);

-- Indexes for reviews
CREATE INDEX idx_reviews_product_id ON Product_Reviews(product_id);
CREATE INDEX idx_reviews_user_id ON Product_Reviews(user_id);
CREATE INDEX idx_reviews_rating ON Product_Reviews(rating);


-- 9. Create Coupons Table
CREATE TABLE Coupons (
    coupon_id INT AUTO_INCREMENT PRIMARY KEY,
    coupon_code VARCHAR(50) UNIQUE NOT NULL,
    discount_type ENUM('Percentage', 'Fixed') NOT NULL,
    discount_value DECIMAL(10, 2) NOT NULL,
    minimum_amount DECIMAL(10, 2) DEFAULT 0,
    valid_from TIMESTAMP NOT NULL,
    valid_until TIMESTAMP NOT NULL,
    is_active BOOLEAN DEFAULT TRUE,
    usage_limit INT DEFAULT NULL, -- NULL for unlimited
    times_used INT DEFAULT 0,
    CHECK (valid_until > valid_from)
);

-- Index for coupons
CREATE INDEX idx_coupons_code ON Coupons(coupon_code);


-- 10. Create Orders Table
CREATE TABLE Orders (
    order_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL, -- User who placed the order
    order_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    total_amount DECIMAL(10, 2) NOT NULL CHECK (total_amount >= 0),
    discount_amount DECIMAL(10, 2) DEFAULT 0,
    final_amount DECIMAL(10, 2) AS (total_amount - discount_amount) STORED, -- Computed column
    order_status ENUM('Pending', 'Processing', 'Shipped', 'Delivered', 'Cancelled', 'Refunded') DEFAULT 'Pending',
    shipping_address_id INT, -- Link to Addresses table
    billing_address_id INT,  -- Link to Addresses table
    coupon_id INT, -- Optional: if a coupon was applied
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE,
    FOREIGN KEY (shipping_address_id) REFERENCES Addresses(address_id) ON DELETE SET NULL,
    FOREIGN KEY (billing_address_id) REFERENCES Addresses(address_id) ON DELETE SET NULL,
    FOREIGN KEY (coupon_id) REFERENCES Coupons(coupon_id) ON DELETE SET NULL
);

-- Indexes for orders
CREATE INDEX idx_orders_user_id ON Orders(user_id);
CREATE INDEX idx_orders_date ON Orders(order_date);
CREATE INDEX idx_orders_status ON Orders(order_status);


-- 11. Create Order_Items Table (Junction table for Orders and Product_Variants)
CREATE TABLE Order_Items (
    order_item_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    variant_id INT NOT NULL, -- References Product_Variants
    quantity INT NOT NULL CHECK (quantity > 0),
    price_at_purchase DECIMAL(10, 2) NOT NULL CHECK (price_at_purchase > 0), -- Price of the variant at the time of purchase
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (variant_id) REFERENCES Product_Variants(variant_id) ON DELETE RESTRICT,
    UNIQUE (order_id, variant_id) -- Ensures a specific variant appears only once per order item entry
);

-- Indexes for order items
CREATE INDEX idx_order_items_order_id ON Order_Items(order_id);
CREATE INDEX idx_order_items_variant_id ON Order_Items(variant_id);


-- 12. Create Payment_Methods Table (e.g., credit cards, PayPal tokens)
CREATE TABLE Payment_Methods (
    payment_method_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    method_type ENUM('Credit Card', 'Debit Card', 'PayPal', 'UPI', 'Net Banking') NOT NULL,
    card_last_four VARCHAR(4), -- Storing last four digits for display
    card_brand VARCHAR(50), -- e.g., Visa, MasterCard
    token VARCHAR(255) UNIQUE, -- Token from payment gateway (DO NOT store actual card numbers)
    is_default BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 13. Create Transactions Table (Records of payment attempts/success for orders)
CREATE TABLE Transactions (
    transaction_id VARCHAR(255) PRIMARY KEY, -- Use a UUID or payment gateway's transaction ID
    order_id INT NOT NULL,
    payment_method_id INT, -- The method used for this transaction
    amount DECIMAL(10, 2) NOT NULL,
    currency VARCHAR(3) DEFAULT 'USD',
    transaction_status ENUM('Pending', 'Success', 'Failed', 'Refunded') NOT NULL,
    gateway_response TEXT, -- JSON or text from payment gateway
    transaction_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (payment_method_id) REFERENCES Payment_Methods(payment_method_id) ON DELETE SET NULL
);

-- Indexes for transactions
CREATE INDEX idx_transactions_order_id ON Transactions(order_id);
CREATE INDEX idx_transactions_status ON Transactions(transaction_status);
CREATE INDEX idx_transactions_date ON Transactions(transaction_date);


-- 14. Create Shipments Table (Details about order shipment)
CREATE TABLE Shipments (
    shipment_id INT AUTO_INCREMENT PRIMARY KEY,
    order_id INT NOT NULL,
    tracking_number VARCHAR(100) UNIQUE,
    shipping_carrier VARCHAR(100),
    shipment_status ENUM('Pending', 'Processing', 'Shipped', 'In Transit', 'Delivered', 'Cancelled') DEFAULT 'Pending',
    shipped_date TIMESTAMP,
    estimated_delivery_date TIMESTAMP,
    actual_delivery_date TIMESTAMP,
    shipping_address_id INT NOT NULL, -- Redundant but useful for historical record if original address changes
    FOREIGN KEY (order_id) REFERENCES Orders(order_id) ON DELETE CASCADE,
    FOREIGN KEY (shipping_address_id) REFERENCES Addresses(address_id) ON DELETE RESTRICT
);

-- Indexes for shipments
CREATE INDEX idx_shipments_order_id ON Shipments(order_id);
CREATE INDEX idx_shipments_tracking_number ON Shipments(tracking_number);
CREATE INDEX idx_shipments_status ON Shipments(shipment_status);


-- 15. Create Wishlists Table
CREATE TABLE Wishlists (
    wishlist_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE NOT NULL, -- Each user has only one wishlist in this model
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 16. Create Wishlist_Items Table
CREATE TABLE Wishlist_Items (
    wishlist_item_id INT AUTO_INCREMENT PRIMARY KEY,
    wishlist_id INT NOT NULL,
    product_id INT NOT NULL, -- Could also link to variant_id if wishlisting specific variants
    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (wishlist_id) REFERENCES Wishlists(wishlist_id) ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES Products(product_id) ON DELETE CASCADE,
    UNIQUE (wishlist_id, product_id)
);

-- Indexes for wishlist items
CREATE INDEX idx_wishlist_items_wishlist_id ON Wishlist_Items(wishlist_id);
CREATE INDEX idx_wishlist_items_product_id ON Wishlist_Items(product_id);


-- 17. Create Shopping_Carts Table
CREATE TABLE Shopping_Carts (
    cart_id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT UNIQUE NOT NULL, -- Each user has only one active shopping cart
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES Users(user_id) ON DELETE CASCADE
);

-- 18. Create Cart_Items Table
CREATE TABLE Cart_Items (
    cart_item_id INT AUTO_INCREMENT PRIMARY KEY,
    cart_id INT NOT NULL,
    variant_id INT NOT NULL, -- Link to Product_Variants
    quantity INT NOT NULL CHECK (quantity > 0),
    added_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (cart_id) REFERENCES Shopping_Carts(cart_id) ON DELETE CASCADE,
    FOREIGN KEY (variant_id) REFERENCES Product_Variants(variant_id) ON DELETE CASCADE,
    UNIQUE (cart_id, variant_id) -- A specific variant can only be once in a cart item
);

-- Indexes for cart items
CREATE INDEX idx_cart_items_cart_id ON Cart_Items(cart_id);
CREATE INDEX idx_cart_items_variant_id ON Cart_Items(variant_id);

-- TRIGGERS

DELIMITER $$

-- Trigger 1: Decrease stock quantity when an item is added to an order
CREATE TRIGGER trg_after_order_item_insert
AFTER INSERT ON Order_Items
FOR EACH ROW
BEGIN
    UPDATE Product_Variants
    SET stock_quantity = stock_quantity - NEW.quantity
    WHERE variant_id = NEW.variant_id;
END$$

-- Trigger 2: Increase stock quantity when an order item is cancelled/refunded
-- This trigger fires if an order's status changes to 'Cancelled' or 'Refunded'
-- and assumes that when an order is cancelled/refunded, its items are effectively returned to stock.
CREATE TRIGGER trg_after_order_status_update
AFTER UPDATE ON Orders
FOR EACH ROW
BEGIN
    IF OLD.order_status NOT IN ('Cancelled', 'Refunded') AND NEW.order_status IN ('Cancelled', 'Refunded') THEN
        UPDATE Product_Variants pv
        JOIN Order_Items oi ON pv.variant_id = oi.variant_id
        SET pv.stock_quantity = pv.stock_quantity + oi.quantity
        WHERE oi.order_id = NEW.order_id;
    END IF;
END$$

DELIMITER ;

-- STORED PROCEDURES AND FUNCTIONS

-- Stored Procedure to place a new order
DELIMITER $$
CREATE PROCEDURE PlaceOrder(
    IN p_user_id INT,
    IN p_shipping_address_id INT,
    IN p_billing_address_id INT,
    IN p_coupon_code VARCHAR(50),
    OUT p_order_id INT
)
BEGIN
    DECLARE v_total_amount DECIMAL(10, 2) DEFAULT 0;
    DECLARE v_discount_amount DECIMAL(10, 2) DEFAULT 0;
    DECLARE v_coupon_id INT;
    DECLARE v_discount_type ENUM('Percentage', 'Fixed');
    DECLARE v_discount_value DECIMAL(10, 2);
    DECLARE v_min_amount DECIMAL(10, 2);
    DECLARE v_order_created INT DEFAULT 0;

    -- Get total amount from shopping cart
    SELECT SUM(ci.quantity * (p.base_price + pv.price_adjustment))
    INTO v_total_amount
    FROM Cart_Items ci
    JOIN Product_Variants pv ON ci.variant_id = pv.variant_id
    JOIN Products p ON pv.product_id = p.product_id
    WHERE ci.cart_id = (SELECT cart_id FROM Shopping_Carts WHERE user_id = p_user_id);

    -- Apply coupon if provided and valid
    IF p_coupon_code IS NOT NULL THEN
        SELECT coupon_id, discount_type, discount_value, minimum_amount
        INTO v_coupon_id, v_discount_type, v_discount_value, v_min_amount
        FROM Coupons
        WHERE coupon_code = p_coupon_code
          AND is_active = TRUE
          AND valid_from <= NOW()
          AND valid_until >= NOW();

        IF v_coupon_id IS NOT NULL AND v_total_amount >= v_min_amount THEN
            IF v_discount_type = 'Percentage' THEN
                SET v_discount_amount = v_total_amount * (v_discount_value / 100);
            ELSE -- Fixed amount
                SET v_discount_amount = v_discount_value;
            END IF;
            -- Ensure discount does not exceed total amount
            SET v_discount_amount = LEAST(v_discount_amount, v_total_amount);
        ELSE
            SET v_coupon_id = NULL; -- Invalidate coupon if not applicable
        END IF;
    END IF;

    -- Start transaction for atomicity
    START TRANSACTION;

    -- Create the order
    INSERT INTO Orders (user_id, total_amount, discount_amount, shipping_address_id, billing_address_id, coupon_id, order_status)
    VALUES (p_user_id, v_total_amount, v_discount_amount, p_shipping_address_id, p_billing_address_id, v_coupon_id, 'Pending');

    SET p_order_id = LAST_INSERT_ID();

    -- Move items from shopping cart to order_items
    INSERT INTO Order_Items (order_id, variant_id, quantity, price_at_purchase)
    SELECT
        p_order_id,
        ci.variant_id,
        ci.quantity,
        (p.base_price + pv.price_adjustment) -- Store price at time of purchase
    FROM Cart_Items ci
    JOIN Product_Variants pv ON ci.variant_id = pv.variant_id
    JOIN Products p ON pv.product_id = p.product_id
    WHERE ci.cart_id = (SELECT cart_id FROM Shopping_Carts WHERE user_id = p_user_id);

    -- Check if all items were successfully added to order_items
    IF ROW_COUNT() = (SELECT COUNT(*) FROM Cart_Items WHERE cart_id = (SELECT cart_id FROM Shopping_Carts WHERE user_id = p_user_id)) THEN
        SET v_order_created = 1;
        -- Clear the shopping cart
        DELETE FROM Cart_Items WHERE cart_id = (SELECT cart_id FROM Shopping_Carts WHERE user_id = p_user_id);

        -- Increment coupon usage if coupon was applied
        IF v_coupon_id IS NOT NULL THEN
            UPDATE Coupons SET times_used = times_used + 1 WHERE coupon_id = v_coupon_id;
        END IF;
        COMMIT;
    ELSE
        ROLLBACK;
        SET p_order_id = NULL; -- Indicate failure
    END IF;

END$$
DELIMITER ;

-- Stored Function to calculate average rating for a product
DELIMITER $$
CREATE FUNCTION GetProductAverageRating(product_id_param INT)
RETURNS DECIMAL(3, 2)
READS SQL DATA
BEGIN
    DECLARE avg_rating DECIMAL(3, 2);
    SELECT AVG(rating) INTO avg_rating FROM Product_Reviews WHERE product_id = product_id_param;
    RETURN IFNULL(avg_rating, 0.00);
END$$
DELIMITER ;

-- Stored Procedure to get a user's complete order history with details
DELIMITER $$
CREATE PROCEDURE GetUserOrderHistory(IN p_user_id INT)
BEGIN
    SELECT
        o.order_id,
        o.order_date,
        o.order_status,
        o.final_amount,
        o.total_amount AS subtotal,
        o.discount_amount,
        pm.method_type AS payment_method,
        s.shipment_status,
        s.tracking_number,
        GROUP_CONCAT(
            CONCAT(
                oi.quantity, ' x ',
                p.product_name,
                ' (Variant: ', JSON_UNQUOTE(JSON_EXTRACT(pv.attributes, '$.color')),
                ', ', JSON_UNQUOTE(JSON_EXTRACT(pv.attributes, '$.size')), ') @ ',
                oi.price_at_purchase
            )
            SEPARATOR '\n'
        ) AS order_items_summary
    FROM Orders o
    LEFT JOIN Transactions t ON o.order_id = t.order_id AND t.transaction_status = 'Success'
    LEFT JOIN Payment_Methods pm ON t.payment_method_id = pm.payment_method_id
    LEFT JOIN Shipments s ON o.order_id = s.order_id
    JOIN Order_Items oi ON o.order_id = oi.order_id
    JOIN Product_Variants pv ON oi.variant_id = pv.variant_id
    JOIN Products p ON pv.product_id = p.product_id
    WHERE o.user_id = p_user_id
    GROUP BY o.order_id, o.order_date, o.order_status, o.final_amount, o.total_amount, o.discount_amount, pm.method_type, s.shipment_status, s.tracking_number
    ORDER BY o.order_date DESC;
END$$
DELIMITER ;

-- VIEWS

-- View for quick access to product details including average rating
CREATE VIEW Product_Details_View AS
SELECT
    p.product_id,
    p.product_name,
    p.description,
    p.base_price,
    c.category_name,
    s.supplier_name,
    p.image_url,
    p.is_active,
    GetProductAverageRating(p.product_id) AS average_rating,
    (SELECT SUM(pv.stock_quantity) FROM Product_Variants pv WHERE pv.product_id = p.product_id) AS total_stock_available
FROM Products p
LEFT JOIN Categories c ON p.category_id = c.category_id
LEFT JOIN Suppliers s ON p.supplier_id = s.supplier_id;

-- View for recent orders with customer info
CREATE VIEW Recent_Orders_Customer_View AS
SELECT
    o.order_id,
    o.order_date,
    o.order_status,
    o.final_amount,
    u.username,
    cp.first_name,
    cp.last_name,
    u.email
FROM Orders o
JOIN Users u ON o.user_id = u.user_id
LEFT JOIN Customer_Profiles cp ON u.user_id = cp.user_id
ORDER BY o.order_date DESC;