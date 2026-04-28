/*
203 - The Revenue Leakage
Category - Analytics
Extreme Hard - 75 Points

You work at a SaaS company that sells software licenses to enterprise clients. 
Each client has a contracted price agreed upon at the time of signing. However, 
the actual invoices raised each month sometimes differ from the contracted price — 
either due to discounts, billing errors, or unapproved price changes.

The finance team wants to identify revenue leakage — cases where clients are 
being billed less than their contracted price consistently over time.

---

Table: contracts

One row per client contract with the agreed monthly price.

| contract_id       | INT  |
| client_id         | INT  |
| contracted_amount | INT  |
| start_date        | DATE |
| end_date          | DATE |

---

Table: invoices

One row per invoice raised against a contract each month.

| invoice_id     | INT  |
| contract_id    | INT  |
| invoice_amount | INT  |
| invoice_date   | DATE |

---

The ask:

Find all contracts where the client was billed less than the contracted amount 
for 3 or more consecutive months. For each such contract return:

- contract_id
- client_id
- consecutive_months (max streak)
- total_leakage (entire contract)
- first_leakage_date (start of longest streak)
- last_leakage_date (end of longest streak)

Constraints:

- Missing invoice month = full leakage
- Multiple streaks → pick longest
- Tie → pick earliest
- invoice_amount never exceeds contracted_amount
- Ignore contracts with zero leakage
*/
/*
EXPECTED OUTPUT:

+-------------+-----------+--------------------+---------------+--------------------+-------------------+
| contract_id | client_id | consecutive_months | total_leakage | first_leakage_date | last_leakage_date |
+-------------+-----------+--------------------+---------------+--------------------+-------------------+
| 1           | 101       | 4                  | 7000          | 2024-02-01         | 2024-05-01        |
| 3           | 103       | 5                  | 11000         | 2024-07-01         | 2024-11-01        |
| 4           | 104       | 3                  | 27000         | 2024-03-01         | 2024-05-01        |
| 5           | 105       | 3                  | 3000          | 2024-01-01         | 2024-03-01        |
| 7           | 107       | 3                  | 7500          | 2024-01-01         | 2024-03-01        |
+-------------+-----------+--------------------+---------------+--------------------+-------------------+
*/
-- DROP TABLES
DROP TABLE IF EXISTS invoices;
DROP TABLE IF EXISTS contracts;

-- CREATE TABLES
CREATE TABLE contracts (
    contract_id INT PRIMARY KEY,
    client_id INT,
    contracted_amount INT,
    start_date DATE,
    end_date DATE
);

CREATE TABLE invoices (
    invoice_id INT PRIMARY KEY,
    contract_id INT,
    invoice_amount INT,
    invoice_date DATE
);

-- INSERT INTO contracts
INSERT INTO contracts VALUES
(1, 101, 10000, '2024-01-01', '2024-12-31'),
(2, 102, 8000,  '2024-01-01', '2024-12-31'),
(3, 103, 12000, '2024-01-01', '2024-12-31'),
(4, 104, 9000,  '2024-01-01', '2024-06-30'),
(5, 105, 7000,  '2024-01-01', '2024-06-30'),
(6, 106, 5000,  '2024-01-01', '2024-06-30'),
(7, 107, 6000,  '2024-01-01', '2024-12-31');

-- INSERT INTO invoices
INSERT INTO invoices VALUES
-- contract 1
(1,1,10000,'2024-01-01'),
(2,1,8000,'2024-02-01'),
(3,1,7500,'2024-03-01'),
(4,1,9000,'2024-04-01'),
(5,1,8500,'2024-05-01'),
(6,1,10000,'2024-06-01'),
(7,1,10000,'2024-07-01'),
(8,1,10000,'2024-08-01'),
(9,1,10000,'2024-09-01'),
(10,1,10000,'2024-10-01'),
(11,1,10000,'2024-11-01'),
(12,1,10000,'2024-12-01'),

-- contract 2
(13,2,8000,'2024-01-01'),
(14,2,6000,'2024-02-01'),
(15,2,7000,'2024-03-01'),
(16,2,8000,'2024-04-01'),
(17,2,8000,'2024-05-01'),
(18,2,6500,'2024-06-01'),
(19,2,7500,'2024-07-01'),
(20,2,8000,'2024-08-01'),
(21,2,8000,'2024-09-01'),
(22,2,8000,'2024-10-01'),
(23,2,8000,'2024-11-01'),
(24,2,8000,'2024-12-01'),

-- contract 3
(25,3,10000,'2024-01-01'),
(26,3,11000,'2024-02-01'),
(27,3,10500,'2024-03-01'),
(28,3,12000,'2024-04-01'),
(29,3,12000,'2024-05-01'),
(30,3,12000,'2024-06-01'),
(31,3,11000,'2024-07-01'),
(32,3,10000,'2024-08-01'),
(33,3,11500,'2024-09-01'),
(34,3,10000,'2024-10-01'),
(35,3,11000,'2024-11-01'),
(36,3,12000,'2024-12-01'),

-- contract 4 (missing months → leakage)
(37,4,9000,'2024-01-01'),
(38,4,9000,'2024-02-01'),
(39,4,9000,'2024-06-01'),

-- contract 5
(40,5,6000,'2024-01-01'),
(41,5,5500,'2024-02-01'),
(42,5,6500,'2024-03-01'),
(43,5,7000,'2024-04-01'),
(44,5,7000,'2024-05-01'),
(45,5,7000,'2024-06-01'),

-- contract 6 (no leakage)
(46,6,5000,'2024-01-01'),
(47,6,5000,'2024-02-01'),
(48,6,5000,'2024-03-01'),
(49,6,5000,'2024-04-01'),
(50,6,5000,'2024-05-01'),
(51,6,5000,'2024-06-01'),

-- contract 7
(52,7,5000,'2024-01-01'),
(53,7,4500,'2024-02-01'),
(54,7,5500,'2024-03-01'),
(55,7,6000,'2024-04-01'),
(56,7,6000,'2024-05-01'),
(57,7,6000,'2024-06-01'),
(58,7,4000,'2024-07-01'),
(59,7,5000,'2024-08-01'),
(60,7,4500,'2024-09-01'),
(61,7,6000,'2024-10-01'),
(62,7,6000,'2024-11-01'),
(63,7,6000,'2024-12-01');