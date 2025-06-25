# Elevate Labs - SQL Developer Internship | Task 1: Advanced E-commerce Database Design

## 🌟 Project Overview

This repository showcases the successful completion of "Task 1: Database Setup and Schema Design" as part of the Elevate Labs SQL Developer Internship. [cite_start]The primary objective was to design, implement, and document a robust relational database schema, demonstrating proficiency in defining tables, relationships, and leveraging advanced SQL features[cite: 1].

**Chosen Domain:** **E-commerce Platform**

An E-commerce domain was selected due to its inherent complexity and the diverse set of entities and interactions involved, providing an excellent opportunity to apply sophisticated database design principles, including transaction management, real-time inventory control, and advanced reporting capabilities.

## 🚀 Database Schema Deep Dive: The E-commerce Backbone

The meticulously designed schema forms the core of a scalable e-commerce platform, structured to ensure data integrity, minimize redundancy, and optimize performance for various operations.

### Core Entities & Relationships

The database is built around the following interconnected entities:

* **User & Customer Management:**
    * `Users`: Stores fundamental user authentication details (e.g., `username`, `email`, `password_hash`, `role`). This table serves as the primary entry point for all platform users.
    * `Customer_Profiles`: Extends `Users` with specific customer-related information (e.g., `first_name`, `last_name`, `phone_number`). It maintains a **One-to-One (1:1)** relationship with `Users`.
    * `Addresses`: Manages reusable shipping and billing addresses. A `User` can have multiple `Addresses` (**One-to-Many, 1:M**).

* **Product Catalog & Supply Chain:**
    * `Categories`: Organizes products into hierarchical categories (e.g., `parent_category_id` for sub-categories). A `Category` can contain many `Products` (**1:M**).
    * `Suppliers`: Stores information about product vendors. A `Supplier` can provide many `Products` (**1:M**).
    * `Products`: Contains base information for all items available for sale (e.g., `product_name`, `description`, `base_price`). A `Product` can have many `Product_Variants` (**1:M**).
    * `Product_Variants`: Handles diverse product options (e.g., color, size) using a flexible `JSON` attribute column. Each variant has a unique `sku` and `stock_quantity`.

* **Order Processing & Fulfillment:**
    * `Orders`: Represents customer purchases, tracking `total_amount`, `discount_amount`, `order_status`, and linking to customer addresses and applied coupons. An `Order` is placed by a `User` (**M:1**).
    * `Order_Items`: A junction table detailing the specific `Product_Variants` and `quantity` within an `Order`. An `Order` can have many `Order_Items`, and an `Order_Item` refers to one `Product_Variant` (**M:M** resolved via `Order_Items`).
    * `Shipments`: Manages the physical delivery details of an order, including `tracking_number` and `shipment_status`. An `Order` can have multiple `Shipments` (**1:M**).

* **Financial & Payment Management:**
    * `Payment_Methods`: Stores tokenized payment information for users (e.g., last four digits of card, `method_type`, `token`). A `User` can have multiple `Payment_Methods` (**1:M**).
    * `Transactions`: Records all payment attempts and their `transaction_status` for `Orders`. An `Order` can be associated with multiple `Transactions` (**1:M**).

* **Customer Engagement & E-commerce Features:**
    * `Product_Reviews`: Captures customer feedback (`rating`, `comment`) for `Products`. A `User` can review many `Products`, and a `Product` can have many `Reviews` (**M:M** resolved through composite primary key on `product_id` and `user_id`).
    * `Coupons`: Manages discount codes with `discount_type` (Percentage/Fixed), `discount_value`, `valid_from`, and `valid_until` dates.
    * `Wishlists`: Allows users to save products for future consideration. Each `User` has one `Wishlist` (**1:1**).
    * `Wishlist_Items`: Links `Products` to `Wishlists` (**M:M** resolved via `Wishlist_Items`).
    * `Shopping_Carts`: Represents a user's active shopping cart, uniquely linked to a `User` (**1:1**).
    * `Cart_Items`: Details the `Product_Variants` and `quantity` currently in a `Shopping_Cart`. A `Shopping_Cart` can contain many `Cart_Items` (**1:M**).

---

## ✨ Advanced Database Features Implemented

To enhance the schema and demonstrate advanced SQL capabilities, the following features have been integrated:

1.  **Optimized Indexing:**
    * **Purpose:** To dramatically speed up data retrieval operations (SELECT queries) by allowing the database to quickly locate rows based on column values without scanning the entire table.
    * **Implementation:** Explicit `CREATE INDEX` statements are applied to:
        * All Foreign Key columns for efficient joins.
        * Frequently queried columns (e.g., `email`, `username` in `Users`).
        * `FULLTEXT INDEX` on `Products.product_name` and `Products.description` to enable powerful keyword-based search functionality.

2.  **Automated Triggers:**
    * **Purpose:** To enforce data integrity and automate business logic in response to specific data modification events.
    * **Implementation:**
        * `trg_after_order_item_insert`: **Automatically decrements** `Product_Variants.stock_quantity` whenever a new item is added to an `Order_Items` record. This ensures real-time inventory synchronization.
        * `trg_after_order_status_update`: **Automatically increments** `Product_Variants.stock_quantity` when an order's status changes to `Cancelled` or `Refunded`, effectively returning items to stock.

3.  **Encapsulated Stored Procedures & Functions:**
    * **Purpose:** To encapsulate complex business logic, improve performance by reducing network round trips, enhance security by abstracting direct table access, and promote code reusability.
    * **Implementation:**
        * `PlaceOrder(IN p_user_id, IN p_shipping_address_id, IN p_billing_address_id, IN p_coupon_code, OUT p_order_id)`: A sophisticated procedure that simulates the entire checkout process. It includes:
            * Calculating `total_amount` from the shopping cart.
            * Applying coupon discounts with validation.
            * **Transactional integrity (`START TRANSACTION`, `COMMIT`, `ROLLBACK`)** to ensure that the entire order placement (creating order, moving items, clearing cart, updating stock/coupon) is an atomic operation—either all steps succeed or none do.
        * `GetUserOrderHistory(IN p_user_id)`: Retrieves a detailed history of a user's orders, joining across multiple tables to provide comprehensive information including item details and order status.
        * `GetProductAverageRating(product_id_param INT) RETURNS DECIMAL(3, 2)`: A simple SQL function to calculate the average customer rating for any given product, used directly in views.

4.  **Simplified Views:**
    * **Purpose:** To simplify complex queries, control data access by exposing only necessary columns, and provide pre-joined "virtual tables" for reporting or application consumption.
    * **Implementation:**
        * `Product_Details_View`: Provides a consolidated view of product information, including `category_name`, `supplier_name`, computed `average_rating` (using `GetProductAverageRating` function), and `total_stock_available` (using a subquery).
        * `Recent_Orders_Customer_View`: Offers a quick overview of recent orders with essential customer details, ideal for administrative dashboards.

5.  **Flexible Data Types & Robust Constraints:**
    * `JSON` Data Type: Utilized in `Product_Variants.attributes` to store flexible, semi-structured product properties (e.g., color, size, material), allowing for easy extensibility without schema alteration.
    * `ENUM` Types: Used for predefined lists of values (e.g., `order_status`, `method_type`), ensuring data consistency and limiting input errors.
    * `CHECK` Constraints: Enforced on numerical columns (e.g., `price > 0`, `quantity > 0`, `rating BETWEEN 1 AND 5`) to maintain data validity.
    * `STORED` Computed Columns: `final_amount` in `Orders` is defined as a computed column, automatically deriving its value from `total_amount` and `discount_amount`, enhancing data integrity and query efficiency.

## 📊 Entity-Relationship (ER) Diagram

[cite_start]Below is the visual representation of the E-commerce database schema, illustrating all entities, their attributes, primary keys, foreign keys, and the cardinality of relationships[cite: 4, 6, 7].

![EER Diagram of Advanced E-commerce Database](Task 1 eer.png)

[cite_start]*(The ER diagram was generated using MySQL Workbench's Reverse Engineer feature from the executed schema. [cite: 2])*

---

## 📚 Answers to Theoretical Questions

[cite_start]As per Task 1 requirements, here are the detailed answers to the theoretical database concepts[cite: 3, 4, 5, 6, 7, 8, 9, 10]:

1.  **What is normalization?**
    [cite_start]Normalization is a systematic approach in database design used to reduce data redundancy and improve data integrity[cite: 1]. It involves organizing the columns and tables of a relational database to ensure that data dependencies are correctly enforced. The process typically involves breaking down large tables into smaller, less redundant tables and defining relationships between them using keys. [cite_start]The goal is to isolate data so that additions, deletions, and modifications of a field can be made in just one place[cite: 5].

2.  **Explain primary vs foreign key.**
    * **Primary Key (PK):** A column or a set of columns in a table that uniquely identifies each row in that table. [cite_start]It must contain unique values and cannot have NULL values[cite: 2]. [cite_start]Its purpose is to provide a unique identifier for each entity instance within a table, serving as the target for foreign key references[cite: 2].
    * **Foreign Key (FK):** A column or a set of columns in one table (the referencing table) that refers to the Primary Key in another table (the referenced table). [cite_start]It establishes a link between two tables, enforcing referential integrity[cite: 2].

3.  **What are constraints?**
    [cite_start]Constraints are rules enforced on data columns in a table to limit the type of data that can go into it[cite: 3]. They ensure the accuracy and reliability of the data. [cite_start]Common constraints include `PRIMARY KEY`, `FOREIGN KEY`, `NOT NULL`, `UNIQUE`, `CHECK`, and `DEFAULT`[cite: 3].

4.  **What is a surrogate key?**
    [cite_start]A surrogate key is an artificial primary key assigned to a record when no suitable natural primary key exists or when a natural key is too complex[cite: 4]. [cite_start]It is typically an auto-incrementing integer (e.g., `AUTO_INCREMENT` in MySQL)[cite: 8], has no business meaning, and is solely used for unique identification within the database.

5.  **How do you avoid data redundancy?**
    [cite_start]Data redundancy, where the same piece of data is stored in multiple places, can be avoided through database normalization[cite: 5]. [cite_start]By designing the schema into multiple related tables and using primary and foreign keys, data is stored only once, and relationships are managed through keys[cite: 5].

6.  **What is an ER diagram?**
    [cite_start]An Entity-Relationship (ER) Diagram is a visual representation of the entities (objects or concepts) within a system and the relationships between them[cite: 6]. [cite_start]It helps in understanding the logical structure of a database, identifying tables, attributes, and how different parts of the database connect[cite: 6].

7.  **What are the types of relationships in DBMS?**
    [cite_start]In a Relational Database Management System (DBMS), the main types of relationships are[cite: 7]:
    * **One-to-One (1:1):** Each record in table A relates to exactly one record in table B, and vice-versa.
    * **One-to-Many (1:M):** Each record in table A can relate to one or more records in table B, but each record in table B relates to only one record in table A.
    * **Many-to-Many (M:M):** Each record in table A can relate to one or more records in table B, and each record in table B can relate to one or more records in table A. These are usually resolved using a junction/associative table.

8.  **Explain the purpose of AUTO_INCREMENT.**
    [cite_start]`AUTO_INCREMENT` is a keyword used in SQL to automatically generate a unique number for each new record inserted into a table[cite: 8]. [cite_start]It is commonly used for primary key columns to ensure that each record has a unique identifier without manual intervention, simplifying data insertion and guaranteeing uniqueness[cite: 8].

9.  **What is the default storage engine in MySQL?**
    [cite_start]The default storage engine in MySQL is **InnoDB**[cite: 9]. InnoDB supports transactions (ACID properties), foreign keys, and crash recovery, making it suitable for high-reliability and high-performance applications.

10. **What is a composite key?**
    [cite_start]A composite key (or compound key) is a primary key that consists of two or more columns whose values, when combined, uniquely identify each row in a table[cite: 10]. [cite_start]None of the individual columns in a composite key is necessarily unique on its own, but their combination is[cite: 10].

---

## 🛠️ Tools Used

* [cite_start]**MySQL Workbench**: Utilized for designing the database schema, creating the EER diagram, and executing all SQL DDL (Data Definition Language) statements[cite: 2].
* **MySQL Server**: The relational database management system (DBMS) where the E-commerce schema was deployed and tested.

## 🚀 Setup & Execution Guide

To replicate this advanced E-commerce database setup:

1.  **Prerequisites:** Ensure you have MySQL Server installed and a MySQL client (like MySQL Workbench) connected.
2.  **Clone Repository:** Download or clone this GitHub repository to your local machine.
3.  **Execute SQL Script:**
    * Open MySQL Workbench.
    * Go to `File` > `New Query Tab`.
    * Open the SQL script file (e.g., `ecommerce_schema_advanced.sql`) from this repository in the new query tab.
    * Execute the entire script. This will create the `super_advanced_ecommerce_db` database and all its tables, indexes, triggers, stored procedures, and views.
4.  **Generate EER Diagram (Optional but Recommended):**
    * In MySQL Workbench, go to `File` > `New Model`.
    * Click on `Database` > `Reverse Engineer`.
    * Follow the wizard, selecting your MySQL connection and the `super_advanced_ecommerce_db` schema.
    * This will generate the EER diagram directly from your live database. You can then export it as an image (e.g., PNG).

---

## ✅ Submission Checklist Adherence

[cite_start]This submission meticulously adheres to all guidelines provided in Task 1[cite: 14]:

* [cite_start]**Time Window:** Task completed and submitted within the specified timeframe (10:00 AM to 10:00 PM IST on June 23, 2025)[cite: 9].
* [cite_start]**Self-Research Allowed:** Extensive self-research was conducted to understand and implement advanced SQL concepts (triggers, stored procedures, JSON data types, indexing, views)[cite: 10].
* [cite_start]**Debug Yourself:** All errors encountered during development were resolved independently, fostering strong problem-solving skills[cite: 11].
* [cite_start]**No Paid Tools:** The entire task was completed using free and open-source tools (MySQL Workbench, MySQL Server)[cite: 12]. [cite_start]No paid software was purchased[cite: 12].
* [cite_start]**GitHub Submission:** This repository serves as the complete submission, including[cite: 13]:
    * The SQL code for schema creation and advanced features.
    * The generated EER diagram image (`Task 1 eer.png`).
    * This `README.md` file comprehensively explaining the work done and answering theoretical questions.

---

**Thank you for reviewing my submission for Task 1!**

[cite_start]**Submit Here:** [Submission Link 1](http://googleusercontent.com/...) [cite: 1]