-- A company organizes a felicitation event to cheer up its employees and clients
-- and keep them motivated. The company has many departments, and in this event,
-- the company wants to felicitate its best employees and clients of each department.
--
-- An employee who has the most sales in his/her department is considered
-- the best employee in that department.
--
-- A client who has contributed the highest sales to a department is considered
-- the best client of that department.
--
-- You are given the following tables:
--   1. empdetails
--   2. empsales
--   3. department
--   4. client
--
-- Write a query to find the client_id and emp_id of the best client and the
-- best employee respectively for each department.

DROP TABLE student;
DROP TABLE department;
-- Create tables
CREATE TABLE department (
    dep_id INT,
    dep_name VARCHAR(50)
);

CREATE TABLE empdetails (
    emp_id INT,
    first_name VARCHAR(50),
    gender VARCHAR(1),
    dep_id INT
);

CREATE TABLE client (
    client_id INT,
    client_name VARCHAR(50)
);

CREATE TABLE empsales (
    emp_id INT,
    client_id INT,
    sales INT
);

-- Insert data
INSERT INTO department (dep_id, dep_name) VALUES
(1, 'Electronics'),
(2, 'Furniture'),
(3, 'Clothing');

INSERT INTO empdetails (emp_id, first_name, gender, dep_id) VALUES
(101, 'Alice', 'F', 1),
(102, 'Bob', 'M', 1),
(103, 'Charlie', 'M', 2),
(104, 'Diana', 'F', 2),
(105, 'Ethan', 'M', 3),
(106, 'Fiona', 'F', 3);

INSERT INTO client (client_id, client_name) VALUES
(1, 'Amazon'),
(2, 'Walmart'),
(3, 'Costco'),
(4, 'Target'),
(5, 'BestBuy');

INSERT INTO empsales (emp_id, client_id, sales) VALUES
(101, 1, 5000),
(101, 2, 3000),
(102, 1, 7000),
(102, 3, 2000),
(103, 2, 4000),
(103, 4, 3000),
(104, 4, 6000),
(105, 5, 8000),
(106, 3, 5000),
(106, 5, 2000);


-- m1 (my method more complex thinking using full outer join)
WITH emp_sales_info as (
    SELECT 
        ed.dep_id,
        ed.emp_id,
        ed.first_name as employee_name,
        SUM(es.sales) as total_sales,
        ROW_NUMBER() OVER(PARTITION BY dep_id ORDER BY SUM(es.sales) DESC) AS emp_rnk 
    FROM empdetails ed 
    LEFT JOIN empsales es 
    ON ed.emp_id = es.emp_id
    GROUP BY 1,2,3
),
emp_ranked as (
    SELECT dep_id,
            employee_name
    FROM emp_sales_info 
    WHERE emp_rnk = 1
),
client_sales_info as (
    SELECT 
        ed.dep_id,
        c.client_id,
        c.client_name,
        SUM(es.sales) as total_sales,
        ROW_NUMBER() OVER(PARTITION BY ed.dep_id ORDER BY SUM(es.sales) DESC) AS RNK 
    FROM client c 
    LEFT JOIN empsales es 
    ON c.client_id = es.client_id
    LEFT JOIN empdetails ed 
    ON ed.emp_id = es.emp_id
    GROUP BY 1,2,3 
),
client_ranked as (
    SELECT 
        dep_id,
        client_name
    FROM client_sales_info
    WHERE rnk = 1
),
final_info as (
    SELECT er.dep_id as emp_dep_id,
        er.employee_name, 
        cr.dep_id as client_dep_id,
        cr.client_name
    FROM emp_ranked er 
    LEFT JOIN client_ranked cr 
    ON er.dep_id = cr.dep_id
    UNION 
    SELECT er.dep_id,
        er.employee_name, 
        cr.dep_id,
        cr.client_name
    FROM emp_ranked er 
    RIGHT JOIN client_ranked cr 
    ON er.dep_id = cr.dep_id
)
SELECT COALESCE(emp_dep_id, client_dep_id) as dep_id,
       employee_name,
       client_name
FROM final_info 

----------------------------------------------------------------------------------------------------------------------------------

-- m2

WITH emp_sales_ranked AS (
    -- Rank employees by total sales within each department
    SELECT 
        ed.dep_id,
        ed.emp_id,
        SUM(es.sales) as total_sales,
        ROW_NUMBER() OVER(PARTITION BY ed.dep_id ORDER BY SUM(es.sales) DESC) AS rn
    FROM empdetails ed 
    INNER JOIN empsales es ON ed.emp_id = es.emp_id
    GROUP BY ed.dep_id, ed.emp_id
),
client_sales_ranked AS (
    -- Rank clients by total sales contribution to each department
    SELECT 
        ed.dep_id,
        es.client_id,
        SUM(es.sales) as total_sales,
        ROW_NUMBER() OVER(PARTITION BY ed.dep_id ORDER BY SUM(es.sales) DESC) AS rn
    FROM empsales es
    INNER JOIN empdetails ed ON es.emp_id = ed.emp_id
    GROUP BY ed.dep_id, es.client_id
)
-- Join to get best employee and best client for each department
SELECT 
    e.dep_id,
    e.emp_id,
    c.client_id
FROM emp_sales_ranked e
INNER JOIN client_sales_ranked c 
    ON e.dep_id = c.dep_id 
    AND e.rn = 1 
    AND c.rn = 1
ORDER BY e.dep_id;


----------------------------------------------------------------------------------------------------------------------------------


-- m3 

WITH cte AS (
    SELECT
        s.*,
        e.dep_id
    FROM empsales s
    INNER JOIN empdetails e
        ON s.emp_id = e.emp_id
),
emp_client_cte AS (
    SELECT
        dep_id,
        emp_id AS id,
        'emp' AS sale_type,
        SUM(sales) AS sales
    FROM cte
    GROUP BY dep_id, emp_id

    UNION ALL

    SELECT
        dep_id,
        client_id AS id,
        'client' AS sale_type,
        SUM(sales) AS sales
    FROM cte
    GROUP BY dep_id, client_id
),

ranked_cte AS (
    SELECT
        dep_id,
        id,sale_type, sales,
        ROW_NUMBER() OVER (PARTITION BY dep_id, sale_type ORDER BY sales DESC ) AS rn
    FROM emp_client_cte
)
SELECT
    dep_id,
    MAX(CASE WHEN sale_type = 'client' THEN id END) AS client_id,
    MAX(CASE WHEN sale_type = 'emp' THEN id END) AS emp_id
FROM ranked_cte
WHERE rn = 1
GROUP BY dep_id;
