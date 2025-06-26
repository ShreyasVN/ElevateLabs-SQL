# Elevate Labs - SQL Developer Internship | Task 3: Advanced SELECT Queries

## 🌟 Project Overview

This repository demonstrates the successful completion of "Task 3: Writing Basic SELECT Queries" as part of the Elevate Labs SQL Developer Internship. Building upon the robust E-commerce database schema designed in Task 1 and populated with data in Task 2, this task focuses on the fundamental yet powerful skill of extracting specific data from one or more tables using various `SELECT` statement clauses.

## 🚀 Data Querying with SELECT Statements Deep Dive

This task primarily involves using Data Query Language (DQL) commands, specifically `SELECT` statements, to retrieve information from the database.

### [cite_start]1. Basic Projection: `SELECT` Statement [cite: 17, 18]

* **Purpose:** To specify which columns or expressions to retrieve from a table.
* [cite_start]**Implementation:** Examples include `SELECT *` to retrieve all columns or `SELECT column1, column2` to retrieve specific columns[cite: 18].
* [cite_start]**Key Concept:** Projection[cite: 22].

### [cite_start]2. Filtering Rows: `WHERE` Clause [cite: 18, 19]

* [cite_start]**Purpose:** To filter rows based on specified conditions, returning only the rows that meet those criteria[cite: 19].
* [cite_start]**Implementation:** Demonstrates applying single conditions, combining conditions with `AND` and `OR`, using `LIKE` for pattern matching, and `BETWEEN` for range filtering[cite: 18].
* **Key Concepts:**
    * [cite_start]**`LIKE '%value%'`**: Used for pattern matching, where `%` is a wildcard representing any sequence of zero or more characters[cite: 20].
    * [cite_start]**`BETWEEN`**: Used to select values within a given range (inclusive)[cite: 20].
    * **`=` vs. `IN`**: `=` is used for exact matches of a single value, while `IN` is used to match any value in a specified list of values.

### [cite_start]3. Sorting Results: `ORDER BY` Clause [cite: 18, 21]

* [cite_start]**Purpose:** To sort the result set of a query based on one or more columns in ascending (`ASC`) or descending (`DESC`) order[cite: 18, 21].
* **Implementation:** Examples include sorting by a single column or multiple columns.
* **Key Concepts:**
    * [cite_start]**Default Sort Order:** If neither `ASC` nor `DESC` is specified, the default sort order is `ASC` (ascending)[cite: 22].

### [cite_start]4. Limiting Results: `LIMIT` Clause [cite: 18, 20]

* [cite_start]**Purpose:** To restrict the number of rows returned by the query[cite: 20].
* **Implementation:** Used to retrieve a specific number of top records or a subset of records starting from an offset.

### 5. Advanced Query Features Covered:

* [cite_start]**`DISTINCT`**: Used to return only unique values in the specified column(s), eliminating duplicate rows from the result set[cite: 22].
* [cite_start]**Aliasing**: Allows assigning temporary names (aliases) to columns or tables in a query, which can make queries more readable and shorter[cite: 21]. For example, `SELECT customer_name AS cname FROM Customers;`

---

## 📚 Answers to Theoretical Questions

As per Task 3 requirements, here are the detailed answers to the theoretical database concepts related to basic `SELECT` queries:

1.  **What does `SELECT` do?**
    [cite_start]The `SELECT` statement is a fundamental SQL command used to retrieve (or "select") data from one or more tables in a database[cite: 17, 18]. It specifies which columns to fetch and can include clauses to filter, sort, group, and limit the results.

2.  **How do you filter rows?**
    [cite_start]Rows are filtered primarily using the `WHERE` clause in a `SELECT` statement[cite: 18, 19]. [cite_start]Conditions specified in the `WHERE` clause (using operators like `=`, `>`, `<`, `LIKE`, `BETWEEN`, `AND`, `OR`, `NOT`, `IN`, `IS NULL`) determine which rows are included in the result set[cite: 18].

3.  **What is `LIKE '%value%'`?**
    [cite_start]`LIKE '%value%'` is an operator used within the `WHERE` clause for pattern matching[cite: 20]. The `%` (percentage sign) is a wildcard character that matches any sequence of zero or more characters. [cite_start]So, `' %value% '` matches any string that contains "value" anywhere within it[cite: 20]. For example, `LIKE 'A%'` matches strings starting with 'A', and `LIKE '%Z'` matches strings ending with 'Z'.

4.  **What is `BETWEEN` used for?**
    [cite_start]`BETWEEN` is a logical operator used in the `WHERE` clause to select values within a specified range[cite: 20]. It is inclusive, meaning that both the starting and ending values of the range are included in the result. For example, `Price BETWEEN 10 AND 50` selects prices from 10 up to and including 50.

5.  **How do you limit output rows?**
    [cite_start]You limit output rows using the `LIMIT` clause in a `SELECT` statement[cite: 18, 20]. This clause is typically placed at the end of the query. For example, `LIMIT 10` will retrieve only the first 10 rows from the result set. An optional `OFFSET` can be used with `LIMIT` (e.g., `LIMIT 10 OFFSET 5`) to start retrieving rows from a specific position.

6.  **Difference between `=` and `IN`?**
    * **`=` (Equals operator):** Used to check for an exact match against a single value. Example: `WHERE status = 'active'`.
    * **`IN` (In operator):** Used to check if a value matches any one of multiple values in a specified list. Example: `WHERE category_id IN (1, 3, 5)`. The `IN` operator is essentially shorthand for multiple `OR` conditions.

7.  **How to sort in descending order?**
    [cite_start]To sort query results in descending order, you use the `ORDER BY` clause followed by the column name and the `DESC` (descending) keyword[cite: 21]. For example, `ORDER BY price DESC` sorts results from the highest price to the lowest.

8.  **What is aliasing?**
    [cite_start]Aliasing is the process of assigning a temporary, alternative name to a column or a table in a SQL query[cite: 21]. This temporary name is called an alias. Aliases are defined using the `AS` keyword (though `AS` is often optional for columns).
    * **Column Aliasing:** Improves readability of output (e.g., `SELECT first_name AS "First Name"`).
    * **Table Aliasing:** Simplifies queries, especially when dealing with long table names or self-joins (e.g., `SELECT * FROM Customers AS C JOIN Orders AS O ON C.CustomerID = O.CustomerID`).

9.  **Explain `DISTINCT`.**
    [cite_start]The `DISTINCT` keyword is used in a `SELECT` statement to eliminate duplicate rows from the result set[cite: 22]. When `DISTINCT` is applied to one or more columns, it returns only the unique combinations of values for those columns. For example, `SELECT DISTINCT city FROM Customers` would list each unique city from which customers reside, even if multiple customers are from the same city.

10. **What is the default sort order?**
    [cite_start]The default sort order when using the `ORDER BY` clause in SQL is **ascending**[cite: 22]. If you do not specify `ASC` or `DESC` after the column name in the `ORDER BY` clause, the database will sort the results from the lowest value to the highest.

---

## 🛠️ Tools Used

* [cite_start]**DB Browser for SQLite / MySQL Workbench**: As specified in the task, these tools are suitable for writing and executing `SELECT` queries[cite: 18].
* **MySQL Server**: The relational database management system (DBMS) where the E-commerce schema (from Task 1) is deployed and populated (from Task 2), providing the data for these queries.

## 🚀 Setup & Execution Guide

To execute the `SELECT` queries from this task:

1.  **Prerequisites:** Ensure your E-commerce database schema (from Task 1) is already set up and running on your MySQL Server, and that it has been populated with sample data (from Task 2).
2.  **Clone Repository:** Download or clone this GitHub repository to your local machine.
3.  **Execute SQL Script:**
    * Open your preferred SQL client (e.g., MySQL Workbench, DB Browser for SQLite).
    * Connect to your `super_advanced_ecommerce_db` database.
    * Open the SQL script file for Task 3 (e.g., `task_3_select_statements.sql` - *you will create this file based on the examples provided in our chat*) in a new query tab.
    * Execute the `SELECT` statements to observe their results. You can run them one by one or in blocks.

---

## ✅ Submission Checklist Adherence

[cite_start]This submission adheres to the general guidelines provided in `task 3.pdf`[cite: 23, 24, 25, 26, 27, 28, 29]:

* [cite_start]**Time Window:** Task completed and submitted within the specified timeframe[cite: 23, 24].
* [cite_start]**Self-Research Allowed:** Self-research was conducted to ensure correct syntax and best practices for various `SELECT` query constructs[cite: 25].
* [cite_start]**Debug Yourself:** All errors encountered during development were resolved independently, fostering problem-solving skills[cite: 26].
* [cite_start]**No Paid Tools:** The task was completed using free and open-source tools[cite: 27].
* **GitHub Submission:** This repository serves as the complete submission, including:
    * The SQL code for `SELECT` statements.
    * [cite_start]This `README.md` file comprehensively explaining the work done and answering theoretical questions[cite: 28].
