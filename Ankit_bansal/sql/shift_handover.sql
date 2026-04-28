/*
206 - The Shift Handover Problem
Category - Analytics
Medium - 20 Points

You work at a 24/7 logistics company that operates in shifts. Each shift has 
an opening stock and a closing stock. The closing stock of one shift should 
match the opening stock of the next shift.

If they don’t match → handover discrepancy.

---

Table: shifts

| shift_id       | INT      |
| warehouse_id   | INT      |
| shift_start    | DATETIME |
| shift_end      | DATETIME |
| opening_stock  | INT      |
| closing_stock  | INT      |

---

The Ask:

Return all discrepancies:

- warehouse_id
- outgoing_shift_id
- incoming_shift_id
- closing_stock
- opening_stock
- discrepancy (opening - closing)
- gap_minutes
- discrepancy_type ('shortage' / 'surplus')
- is_worst_handover ('Y' / 'N')

---

Constraints:

- Compare ONLY consecutive shifts per warehouse
- Ignore last shift (no next)
- Ignore clean matches
- gap_minutes >= 0
- Worst = max ABS(discrepancy) per warehouse

---

EXPECTED OUTPUT:

+--------------+-------------------+-------------------+---------------+---------------+-------------+-------------+------------------+-------------------+
| warehouse_id | outgoing_shift_id | incoming_shift_id | closing_stock | opening_stock | discrepancy | gap_minutes | discrepancy_type | is_worst_handover |
+--------------+-------------------+-------------------+---------------+---------------+-------------+-------------+------------------+-------------------+
| 1            | 1                 | 2                 | 100           | 95            | -5          | 0           | shortage         | N                 |
| 1            | 3                 | 4                 | 110           | 120           | 10          | 0           | surplus          | Y                 |
| 2            | 5                 | 6                 | 200           | 180           | -20         | 0           | shortage         | Y                 |
| 2            | 6                 | 7                 | 180           | 190           | 10          | 60          | surplus          | N                 |
| 4            | 12                | 13                | 490           | 480           | -10         | 0           | shortage         | N                 |
| 4            | 13                | 14                | 505           | 530           | 25          | 0           | surplus          | Y                 |
| 4            | 14                | 15                | 500           | 485           | -15         | 0           | shortage         | N                 |
| 6            | 17                | 18                | 400           | 380           | -20         | 120         | shortage         | Y                 |
+--------------+-------------------+-------------------+---------------+---------------+-------------+-------------+------------------+-------------------+
*/

-- DROP TABLE
DROP TABLE IF EXISTS shifts;

-- CREATE TABLE
CREATE TABLE shifts (
    shift_id INT PRIMARY KEY,
    warehouse_id INT,
    shift_start DATETIME,
    shift_end DATETIME,
    opening_stock INT,
    closing_stock INT
);

-- INSERT DATA
INSERT INTO shifts VALUES
(1,1,'2024-01-01 06:00:00','2024-01-01 14:00:00',100,100),
(2,1,'2024-01-01 14:00:00','2024-01-01 22:00:00',95,95),
(3,1,'2024-01-01 22:00:00','2024-01-02 06:00:00',95,110),
(4,1,'2024-01-02 06:00:00','2024-01-02 14:00:00',120,115),

(5,2,'2024-01-01 06:00:00','2024-01-01 14:00:00',200,200),
(6,2,'2024-01-01 14:00:00','2024-01-01 22:00:00',180,180),
(7,2,'2024-01-01 23:00:00','2024-01-02 07:00:00',190,185),

(8,3,'2024-01-01 06:00:00','2024-01-01 14:00:00',300,310),
(9,3,'2024-01-01 14:00:00','2024-01-01 22:00:00',310,295),
(10,3,'2024-01-01 22:00:00','2024-01-02 06:00:00',295,305),
(11,3,'2024-01-02 06:00:00','2024-01-02 14:00:00',305,300),

(12,4,'2024-01-01 06:00:00','2024-01-01 14:00:00',500,490),
(13,4,'2024-01-01 14:00:00','2024-01-01 22:00:00',480,505),
(14,4,'2024-01-01 22:00:00','2024-01-02 06:00:00',530,500),
(15,4,'2024-01-02 06:00:00','2024-01-02 14:00:00',485,480),

(16,5,'2024-01-01 06:00:00','2024-01-01 14:00:00',150,145),

(17,6,'2024-01-01 06:00:00','2024-01-01 14:00:00',400,400),
(18,6,'2024-01-01 16:00:00','2024-01-01 22:00:00',380,370),

(19,7,'2024-01-01 06:00:00','2024-01-01 14:00:00',250,260),
(20,7,'2024-01-01 14:00:00','2024-01-01 22:00:00',260,270),
(21,7,'2024-01-01 22:00:00','2024-01-02 06:00:00',270,280);