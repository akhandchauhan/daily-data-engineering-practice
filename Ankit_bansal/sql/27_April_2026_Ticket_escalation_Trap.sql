/*
207 - The Ticket Escalation Trap
Category - Analytics
Hard - 40 Points

You work at a SaaS customer support company. Tickets can be escalated between agents.
The goal is to identify tickets stuck in an “Escalation Trap”.

---

Table: tickets
| ticket_id   | INT      |
| customer_id | INT      |
| created_at  | DATETIME |
| status      | VARCHAR  |
| priority    | VARCHAR  |

---

Table: escalations
| escalation_id | INT      |
| ticket_id     | INT      |
| from_agent_id | INT      |
| to_agent_id   | INT      |
| escalated_at  | DATETIME |

---

The Ask:

Return one row per ticket where:

- status = 'open'
- escalation_count ≥ 3

Columns:

- ticket_id
- customer_id
- priority
- escalation_count
- total_hours_open (until '2024-06-01 00:00:00')
- avg_hours_per_escalation (rounded to 2 decimals)
- most_frequent_escalator (tie → lower agent_id)
- current_agent_id (latest to_agent_id)

---

Constraints:

- avg_hours_per_escalation = total_hours_open / escalation_count
- same agent can appear multiple times
- must resolve ties correctly
- current agent = last escalation

---

EXPECTED OUTPUT:

+-----------+-------------+----------+------------------+------------------+--------------------------+-------------------------+------------------+
| ticket_id | customer_id | priority | escalation_count | total_hours_open | avg_hours_per_escalation | most_frequent_escalator | current_agent_id |
+-----------+-------------+----------+------------------+------------------+--------------------------+-------------------------+------------------+
| 1         | 101         | high     | 4                | 736.00           | 184.00                   | 201                     | 205              |
| 2         | 102         | medium   | 3                | 518.00           | 172.67                   | 301                     | 304              |
| 3         | 103         | critical | 5                | 1119.00          | 223.80                   | 401                     | 406              |
| 6         | 106         | high     | 3                | 400.00           | 133.33                   | 701                     | 704              |
| 8         | 108         | critical | 4                | 569.00           | 142.25                   | 802                     | 804              |
+-----------+-------------+----------+------------------+------------------+--------------------------+-------------------------+------------------+
*/

-- DROP TABLES
DROP TABLE IF EXISTS escalations;
DROP TABLE IF EXISTS tickets;

-- CREATE TABLES
CREATE TABLE tickets (
    ticket_id INT PRIMARY KEY,
    customer_id INT,
    created_at DATETIME,
    status VARCHAR(20),
    priority VARCHAR(20)
);

CREATE TABLE escalations (
    escalation_id INT PRIMARY KEY,
    ticket_id INT,
    from_agent_id INT,
    to_agent_id INT,
    escalated_at DATETIME
);

-- INSERT INTO tickets
INSERT INTO tickets VALUES
(1,101,'2024-05-01 08:00:00','open','high'),
(2,102,'2024-05-10 10:00:00','open','medium'),
(3,103,'2024-04-15 09:00:00','open','critical'),
(4,104,'2024-05-05 11:00:00','closed','high'),
(5,105,'2024-05-20 14:00:00','open','low'),
(6,106,'2024-05-15 08:00:00','open','high'),
(7,107,'2024-05-25 10:00:00','open','medium'),
(8,108,'2024-05-08 07:00:00','open','critical');

-- INSERT INTO escalations
INSERT INTO escalations VALUES
(1,1,201,202,'2024-05-02 09:00:00'),
(2,1,202,203,'2024-05-05 10:00:00'),
(3,1,201,204,'2024-05-10 11:00:00'),
(4,1,204,205,'2024-05-20 14:00:00'),

(5,2,301,302,'2024-05-11 09:00:00'),
(6,2,302,303,'2024-05-15 10:00:00'),
(7,2,303,304,'2024-05-20 11:00:00'),

(8,3,401,402,'2024-04-16 08:00:00'),
(9,3,402,403,'2024-04-20 09:00:00'),
(10,3,401,404,'2024-04-25 10:00:00'),
(11,3,404,405,'2024-05-01 11:00:00'),
(12,3,401,406,'2024-05-10 12:00:00'),

(13,4,501,502,'2024-05-06 09:00:00'),
(14,4,502,503,'2024-05-10 10:00:00'),
(15,4,503,504,'2024-05-15 11:00:00'),
(16,4,504,505,'2024-05-20 12:00:00'),

(17,5,601,602,'2024-05-21 09:00:00'),
(18,5,602,603,'2024-05-25 10:00:00'),

(19,6,701,702,'2024-05-16 09:00:00'),
(20,6,702,703,'2024-05-20 10:00:00'),
(21,6,703,704,'2024-05-25 11:00:00'),

(22,8,801,802,'2024-05-09 08:00:00'),
(23,8,802,803,'2024-05-12 09:00:00'),
(24,8,803,802,'2024-05-18 10:00:00'),
(25,8,802,804,'2024-05-25 11:00:00');

WITH escalation_info AS (
    SELECT 
        t.customer_id,
        t.ticket_id,
        t.priority,
        COUNT(e.from_agent_id) AS escalation_count,
        TIMESTAMPDIFF(
            SECOND,
            MIN(t.created_at),
            '2024-06-01 00:00:00'
        )/(60*60) AS total_hours_open
    FROM tickets t 
    JOIN Escalations e 
    ON t.ticket_id = e.ticket_id 
    AND t.status = 'open'
    GROUP BY 
            t.customer_id,
            t.ticket_id,
            t.priority
    HAVING COUNT(e.from_agent_id) >= 3
)
, frequent_escalator_ranked AS (
    SELECT 
        ticket_id,
        from_agent_id AS most_frequent_escalator
    FROM(
        SELECT 
            e.ticket_id,
            e.from_agent_id,
            ROW_NUMBER() OVER(
                PARTITION BY e.ticket_id 
                ORDER BY COUNT(*) DESC,
                e.from_agent_id
            ) AS agents_ranked
        FROM Escalations e
        GROUP BY e.ticket_id,
                e.from_agent_id
    ) t
    WHERE agents_ranked = 1 
),
latest_agent AS (
    SELECT 
        to_agent_id AS current_agent_id,
        ticket_id
    FROM (
        SELECT 
            to_agent_id,
            ticket_id,
            ROW_NUMBER() OVER(
                PARTITION BY ticket_id
                ORDER BY escalated_at DESC
            ) AS escalations_ranked
        FROM Escalations e
    ) t 
    WHERE escalations_ranked = 1
)
SELECT 
        ei.ticket_id,
        ei.customer_id,
        ei.priority,
        ei.escalation_count,
        ei.total_hours_open,
        ROUND(ei.total_hours_open / ei.escalation_count,2) AS avg_hours_per_escalation,
        fer.most_frequent_escalator,
        li.current_agent_id

FROM escalation_info ei 
JOIN frequent_escalator_ranked fer
ON ei.ticket_id = fer.ticket_id
JOIN latest_agent li 
ON li.ticket_id = ei.ticket_id;