# Elevate Labs - SQL Developer Internship | Task 2: Data Insertion and Handling Nulls

## 🌟 Project Overview

This repository demonstrates the successful completion of "Task 2: Data Insertion and Handling Nulls" as part of the Elevate Labs SQL Developer Internship. Building upon the robust E-commerce database schema designed in Task 1, this task focuses on populating the database with meaningful data and managing data integrity, specifically addressing the proper handling of `NULL` values and applying DML operations.

## 🚀 Data Manipulation Language (DML) Operations Deep Dive

This task involves utilizing Data Manipulation Language (DML) commands to interact with the database, ensuring data can be effectively added, modified, and removed.

### 1. `INSERT` Statements: Populating the Database

* **Purpose:** To add new rows (records) into the tables created in Task 1.
* **Implementation:** The SQL script includes `INSERT INTO` statements for various tables (`users`, `customer_profiles`, `products`, `orders`, etc.) to create a realistic dataset for an e-commerce platform.
* **Handling Nulls & Defaults:** Demonstrates inserting values into all columns, or selectively inserting into specific columns, allowing other columns to take their `DEFAULT` values or be `NULL` if permitted by the schema. Special attention is given to fields where `NULL` is appropriate (e.g., `last_login`, `address_line2`).

### 2. `UPDATE` Statements: Modifying Existing Data

* **Purpose:** To change existing data in one or more rows of a table.
* **Implementation:** The script showcases `UPDATE` statements to modify specific records (e.g., changing a user's email, updating a product's price, changing an order's status).
* **Conditional Updates:** Emphasizes the crucial role of the `WHERE` clause to target specific rows for modification, preventing unintended mass updates. Examples include updating a single customer's phone number or changing the status of multiple pending orders.

### 3. `DELETE` Statements: Removing Data

* **Purpose:** To remove existing rows from a table.
* **Implementation:** The script includes `DELETE FROM` statements to remove specific records (e.g., deleting a specific cart item, removing a cancelled order).
* **Controlled Deletion:** Highlights the importance of the `WHERE` clause in `DELETE` statements to ensure only desired rows are removed, preventing accidental data loss. Discusses how `ON DELETE CASCADE` (if defined in Task 1's schema) impacts deletion of related data.

---

## 📚 Answers to Theoretical Questions

As per Task 2 requirements, here are the detailed answers to the theoretical database concepts related to DML and Null handling:

1.  **Difference between `NULL` and `0`?**
    * **`NULL`**: Represents the absence of a value. It means "no data," "unknown," or "not applicable." It is not equal to `0`, an empty string (`''`), or a space. `NULL` is a marker for missing or undefined information.
    * **`0`**: Represents an actual numerical value of zero. It is a specific, defined quantity. For example, `0` in a `stock_quantity` column means there are zero items, whereas `NULL` would mean the stock quantity is unknown or not recorded.

2.  **What is a default constraint?**
    A `DEFAULT` constraint is used to provide a default value for a column when no value is explicitly specified during an `INSERT` operation. If a column has a `DEFAULT` constraint and no value is given for that column, the default value is automatically inserted. This helps ensure data consistency and reduces the need for application-side handling of missing values.

3.  **How does `IS NULL` work?**
    The `IS NULL` operator is used to test for `NULL` values. Because `NULL` is not a value but a state of absence, it cannot be compared using standard comparison operators like `=`, `<`, or `>`. Instead, you use `column_name IS NULL` to check if a column's value is `NULL`, and `column_name IS NOT NULL` to check if it has a non-`NULL` value.

4.  **How do you update multiple rows?**
    You update multiple rows using the `UPDATE` statement along with a `WHERE` clause that selects more than one row. For example, `UPDATE Employees SET Status = 'Inactive' WHERE Department = 'Marketing';` would update the status for all employees in the Marketing department. Without a `WHERE` clause, the `UPDATE` statement would modify *all* rows in the table.

5.  **Can we insert partial values?**
    Yes, you can insert partial values into a table using `INSERT INTO`. When inserting partial values, you must explicitly specify the columns you are providing values for. Any columns not listed will either receive their `DEFAULT` value (if defined) or `NULL` (if the column allows `NULL`s). Columns defined with `NOT NULL` constraints that are not included in the `INSERT` statement or do not have a `DEFAULT` value will cause an error.

6.  **What happens if a `NOT NULL` field is left empty?**
    If a `NOT NULL` field (a column explicitly defined to not accept `NULL` values) is left empty (i.e., no value is provided for it during an `INSERT` or it's set to `NULL` during an `UPDATE`), the database will raise an error. This prevents records from being created or updated with missing critical information.

7.  **How do you rollback a deletion?**
    Rollback of a deletion is possible if the `DELETE` operation was part of an **active transaction**. In SQL, you can use `START TRANSACTION` (or `BEGIN TRANSACTION`), perform the `DELETE` statement, and then, if you realize it was a mistake, issue a `ROLLBACK` command. This will undo all changes made since the `START TRANSACTION` command. If `COMMIT` has already been executed, or if the `DELETE` was performed outside an explicit transaction (e.g., in `autocommit` mode, which is often the default), the deletion cannot be rolled back without a database backup.

8.  **Can we insert values into specific columns only?**
    Yes, absolutely. To insert values into specific columns, you must list the column names explicitly after the table name in the `INSERT INTO` statement, and then provide values for only those listed columns.
    Example: `INSERT INTO Customers (first_name, last_name, email) VALUES ('Jane', 'Doe', 'jane.doe@example.com');`

9.  **How to insert values using `SELECT`?**
    You can insert values into a table by selecting data from another table or a complex query using the `INSERT INTO ... SELECT` statement. This is highly efficient for copying data, populating summary tables, or migrating data.
    Example: `INSERT INTO NewCustomers (id, name) SELECT user_id, username FROM OldUsers WHERE registration_date > '2023-01-01';`

10. **What is `ON DELETE CASCADE`?**
    `ON DELETE CASCADE` is a referential action specified on a `FOREIGN KEY` constraint. When a row in the parent table (the table containing the primary key referenced by the foreign key) is deleted, `ON DELETE CASCADE` automatically deletes all matching rows in the child table (the table containing the foreign key). This ensures that child records dependent on a deleted parent record are also removed, preventing "orphan" records and maintaining referential integrity.

---

## 🛠️ Tools Used

* **DB Fiddle / SQLiteStudio**: As specified in the task, these tools are suitable for writing and executing DML statements.
* **MySQL Server / MySQL Workbench**: Used as the database environment where the Task 1 schema was established, providing the target for these DML operations.

## 🚀 Setup & Execution Guide

To execute the DML statements from this task:

1.  **Prerequisites:** Ensure your E-commerce database schema (from Task 1) is already set up and running on your MySQL Server.
2.  **Clone Repository:** Download or clone this GitHub repository to your local machine.
3.  **Execute SQL Script:**
    * Open your preferred SQL client (e.g., MySQL Workbench, DB Fiddle, SQLiteStudio).
    * Connect to your `super_advanced_ecommerce_db` database.
    * Open the SQL script file for Task 2 (e.g., `task_2_dml_statements.sql` - *you will create this file*) from this repository in a new query tab.
    * Execute the `INSERT` statements first to populate your tables.
    * Then, execute the `UPDATE` and `DELETE` statements (perhaps commenting out `DELETE` if you want to keep data for further practice).

---

## ✅ Submission Checklist Adherence

This submission adheres to the guidelines provided in Task 2:

* **Time Window:** Task completed and submitted within the specified timeframe.
* **Self-Research Allowed:** Self-research was conducted to ensure correct syntax and best practices for DML operations and null handling.
* **Debug Yourself:** All errors encountered during development were resolved independently.
* **No Paid Tools:** The task was completed using free tools.
* **GitHub Submission:** This repository serves as the complete submission, including:
    * The SQL code for `INSERT`, `UPDATE`, and `DELETE` statements.
    * This `README.md` file comprehensively explaining the work done and answering theoretical questions.
