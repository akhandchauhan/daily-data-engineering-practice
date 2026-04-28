/*
204 - The Silent Bestsellers
Category - Analytics
Medium - 20 Points

You work at a retail analytics company managing data for a chain of stores across multiple cities. 
The product team wants to identify "Silent Bestsellers" — products that are among the top 3 
best-selling products by revenue in their category, but have never been promoted or discounted.

A product is a Silent Bestseller if:
- It ranks in top 3 by total revenue within its category
- It has NEVER appeared in promotions table (any store, any time)
- It was sold in at least 2 stores

Revenue = quantity * unit_price

If tie → use DENSE_RANK
Ranking only within qualified products

---

Table: sales

| sale_id     | INT     |
| product_id  | INT     |
| category    | VARCHAR |
| store_id    | INT     |
| sale_date   | DATE    |
| quantity    | INT     |
| unit_price  | DECIMAL |

---

Table: promotions

| promotion_id | INT  |
| product_id   | INT  |
| store_id     | INT  |
| promo_start  | DATE |
| promo_end    | DATE |

---

Return:

- product_id
- category
- total_revenue
- revenue_rank
- stores_sold_in
- first_sale_date
- last_sale_date

Order by product_id, category, revenue_rank

---

EXPECTED OUTPUT:

+------------+-------------+---------------+--------------+----------------+-----------------+----------------+
| product_id | category    | total_revenue | revenue_rank | stores_sold_in | first_sale_date | last_sale_date |
+------------+-------------+---------------+--------------+----------------+-----------------+----------------+
| 101        | Electronics | 15000         | 1            | 3              | 2024-01-15      | 2024-03-10     |
| 103        | Electronics | 7200          | 2            | 2              | 2024-01-05      | 2024-02-10     |
| 104        | Electronics | 4140          | 3            | 2              | 2024-01-20      | 2024-02-25     |
| 105        | Electronics | 4140          | 3            | 2              | 2024-01-25      | 2024-03-15     |
| 201        | Clothing    | 11250         | 1            | 3              | 2024-01-08      | 2024-03-18     |
| 203        | Clothing    | 4290          | 2            | 2              | 2024-01-20      | 2024-02-25     |
| 206        | Clothing    | 4025          | 3            | 2              | 2024-01-22      | 2024-02-18     |
| 301        | Furniture   | 5600          | 1            | 2              | 2024-01-03      | 2024-02-08     |
| 302        | Furniture   | 3750          | 2            | 2              | 2024-01-18      | 2024-02-22     |
| 306        | Furniture   | 2720          | 3            | 2              | 2024-01-30      | 2024-02-25     |
+------------+-------------+---------------+--------------+----------------+-----------------+----------------+
*/

-- DROP TABLES
DROP TABLE IF EXISTS promotions;
DROP TABLE IF EXISTS sales;

-- CREATE TABLES
CREATE TABLE sales (
    sale_id INT PRIMARY KEY,
    product_id INT,
    category VARCHAR(50),
    store_id INT,
    sale_date DATE,
    quantity INT,
    unit_price DECIMAL(10,2)
);

CREATE TABLE promotions (
    promotion_id INT PRIMARY KEY,
    product_id INT,
    store_id INT,
    promo_start DATE,
    promo_end DATE
);

-- INSERT INTO sales
INSERT INTO sales VALUES
(1,101,'Electronics',1,'2024-01-15',10,500),
(2,101,'Electronics',2,'2024-02-20',8,500),
(3,101,'Electronics',3,'2024-03-10',12,500),
(4,102,'Electronics',1,'2024-01-10',15,450),
(5,102,'Electronics',2,'2024-02-15',10,450),
(6,102,'Electronics',3,'2024-03-20',8,450),
(7,107,'Electronics',1,'2024-01-12',20,490),
(8,103,'Electronics',1,'2024-01-05',6,480),
(9,103,'Electronics',2,'2024-02-10',9,480),
(10,104,'Electronics',1,'2024-01-20',5,460),
(11,104,'Electronics',2,'2024-02-25',4,460),
(12,105,'Electronics',2,'2024-01-25',4,460),
(13,105,'Electronics',3,'2024-03-15',5,460),
(14,106,'Electronics',1,'2024-01-30',2,300),
(15,106,'Electronics',2,'2024-02-28',3,300),

(16,201,'Clothing',1,'2024-01-08',20,150),
(17,201,'Clothing',2,'2024-02-12',25,150),
(18,201,'Clothing',3,'2024-03-18',30,150),
(19,202,'Clothing',1,'2024-01-15',18,140),
(20,202,'Clothing',2,'2024-02-20',22,140),
(21,202,'Clothing',3,'2024-03-25',15,140),
(22,203,'Clothing',1,'2024-01-20',15,130),
(23,203,'Clothing',2,'2024-02-25',18,130),
(24,206,'Clothing',1,'2024-01-22',15,115),
(25,206,'Clothing',3,'2024-02-18',20,115),
(26,204,'Clothing',1,'2024-02-01',10,120),
(27,204,'Clothing',3,'2024-03-05',8,120),
(28,205,'Clothing',2,'2024-01-10',5,100),

(29,301,'Furniture',1,'2024-01-03',4,800),
(30,301,'Furniture',2,'2024-02-08',3,800),
(31,302,'Furniture',2,'2024-01-18',3,750),
(32,302,'Furniture',3,'2024-02-22',2,750),
(33,303,'Furniture',1,'2024-01-25',2,700),
(34,303,'Furniture',3,'2024-03-01',3,700),
(35,305,'Furniture',3,'2024-01-28',5,720),
(36,306,'Furniture',1,'2024-01-30',2,680),
(37,306,'Furniture',3,'2024-02-25',2,680),
(38,304,'Furniture',1,'2024-02-10',2,650),
(39,304,'Furniture',2,'2024-03-15',1,650);

-- INSERT INTO promotions
INSERT INTO promotions VALUES
(1,102,1,'2024-01-01','2024-01-31'),
(2,202,3,'2024-03-01','2024-03-31'),
(3,303,2,'2024-01-15','2024-02-15');