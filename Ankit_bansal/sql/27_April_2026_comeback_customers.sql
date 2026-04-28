/*
205 - The Comeback Customers
Category - Analytics
Hard - 40 Points

You work at an e-commerce company. The marketing team wants to identify 
“Comeback Customers” — customers who had a period of inactivity 
(no orders for 60 or more days) and then came back.

Table: orders
| order_id     | INT  |
| customer_id  | INT  |
| order_date   | DATE |
| order_amount | INT  |

---

The Ask:

Find all comeback customers and return:

- customer_id
- gap_days (longest gap between consecutive orders)
- orders_before_comeback
- orders_after_comeback
- spend_before_comeback
- spend_after_comeback
- comeback_date (date of order after the gap)

---

Constraints:

- Only customers with ≥ 2 orders
- Gap = difference between consecutive orders
- Consider ONLY gaps ≥ 60 days
- If multiple → pick longest
- Tie → pick earliest
- Split metrics around that gap
- Ignore customers with no qualifying gap

---

EXPECTED OUTPUT:

+-------------+----------+------------------------+-----------------------+-----------------------+----------------------+---------------+
| customer_id | gap_days | orders_before_comeback | orders_after_comeback | spend_before_comeback | spend_after_comeback | comeback_date |
+-------------+----------+------------------------+-----------------------+-----------------------+----------------------+---------------+
| 101         | 92       | 3                      | 2                     | 1200                  | 1050                 | 2024-06-01    |
| 102         | 92       | 3                      | 2                     | 750                   | 750                  | 2024-09-01    |
| 103         | 62       | 1                      | 4                     | 100                   | 900                  | 2024-03-03    |
| 104         | 60       | 1                      | 2                     | 400                   | 950                  | 2024-03-01    |
| 107         | 90       | 2                      | 3                     | 1100                  | 1950                 | 2024-05-01    |
| 108         | 182      | 1                      | 1                     | 1000                  | 1200                 | 2024-07-01    |
| 109         | 76       | 4                      | 1                     | 1150                  | 500                  | 2024-05-01    |
+-------------+----------+------------------------+-----------------------+-----------------------+----------------------+---------------+
*/

-- DROP TABLE
DROP TABLE IF EXISTS orders;

-- CREATE TABLE
CREATE TABLE orders (
    order_id INT PRIMARY KEY,
    customer_id INT,
    order_date DATE,
    order_amount INT
);

-- INSERT DATA
INSERT INTO orders VALUES
(1,101,'2024-01-01',500),
(2,101,'2024-02-01',300),
(3,101,'2024-03-01',400),
(4,101,'2024-06-01',600),
(5,101,'2024-07-01',450),

(6,102,'2024-01-01',200),
(7,102,'2024-04-01',300),
(8,102,'2024-06-01',250),
(9,102,'2024-09-01',400),
(10,102,'2024-10-01',350),

(11,103,'2024-01-01',100),
(12,103,'2024-03-03',150),
(13,103,'2024-05-01',200),
(14,103,'2024-07-01',250),
(15,103,'2024-08-01',300),

(16,104,'2024-01-01',400),
(17,104,'2024-03-01',500),
(18,104,'2024-04-01',450),

(19,105,'2024-01-01',300),
(20,105,'2024-02-01',350),
(21,105,'2024-03-01',400),
(22,105,'2024-04-01',450),

(23,106,'2024-01-01',500),

(24,107,'2024-01-01',600),
(25,107,'2024-02-01',500),
(26,107,'2024-05-01',700),
(27,107,'2024-06-01',650),
(28,107,'2024-07-01',600),

(29,108,'2024-01-01',1000),
(30,108,'2024-07-01',1200),

(31,109,'2024-01-01',200),
(32,109,'2024-01-15',300),
(33,109,'2024-02-01',250),
(34,109,'2024-02-15',400),
(35,109,'2024-05-01',500);