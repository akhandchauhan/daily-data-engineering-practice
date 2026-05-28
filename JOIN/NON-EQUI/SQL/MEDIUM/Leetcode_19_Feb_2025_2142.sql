-- 2142. The Number of Passengers in Each Bus I 
-- Description
-- Table: Buses
-- +--------------+------+
-- | Column Name  | Type |
-- +--------------+------+
-- | bus_id       | int  |
-- | arrival_time | int  |
-- +--------------+------+
-- bus_id is the column with unique values for this table.
-- Each row of this table contains information about the arrival time of a bus at the LeetCode station.
-- No two buses will arrive at the same time.
-- Table: Passengers
-- +--------------+------+
-- | Column Name  | Type |
-- +--------------+------+
-- | passenger_id | int  |
-- | arrival_time | int  |
-- +--------------+------+
-- passenger_id is the column with unique values for this table.
-- Each row of this table contains information about the arrival time of a passenger at the LeetCode station.
-- Buses and passengers arrive at the LeetCode station. If a bus arrives at the station at time
-- tbus and a passenger arrived at time tpassenger where tpassenger <= tbus and the passenger did
-- not catch any bus, the passenger will use that bus.
-- Write a solution to report the number of users that used each bus.
-- Return the result table ordered by bus_id in ascending order.
-- Input: 
-- Buses table:
-- +--------+--------------+
-- | bus_id | arrival_time |
-- +--------+--------------+
-- | 1      | 2            |
-- | 2      | 4            |
-- | 3      | 7            |
-- +--------+--------------+
-- Passengers table:
-- +--------------+--------------+
-- | passenger_id | arrival_time |
-- +--------------+--------------+
-- | 11           | 1            |
-- | 12           | 5            |
-- | 13           | 6            |
-- | 14           | 7            |
-- +--------------+--------------+
-- Output: 
-- +--------+----------------+
-- | bus_id | passengers_cnt |
-- +--------+----------------+
-- | 1      | 1              |
-- | 2      | 0              |
-- | 3      | 3              |
-- +--------+----------------+
-- Explanation: 
-- - Passenger 11 arrives at time 1.
-- - Bus 1 arrives at time 2 and collects passenger 11.
-- - Bus 2 arrives at time 4 and does not collect any passengers.
-- - Passenger 12 arrives at time 5.
-- - Passenger 13 arrives at time 6.
-- - Passenger 14 arrives at time 7.
-- - Bus 3 arrives at time 7 and collects passengers 12, 13, and 14.

DROP TABLE IF EXISTS Buses;
DROP TABLE IF EXISTS Passengers;

CREATE TABLE Buses (
    bus_id INT PRIMARY KEY,
    arrival_time INT NOT NULL
);

CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    arrival_time INT NOT NULL
);

INSERT INTO Buses (bus_id, arrival_time) VALUES
(1, 2),
(2, 4),
(3, 7);

INSERT INTO Passengers (passenger_id, arrival_time) VALUES
(11, 1),
(12, 5),
(13, 6),
(14, 7);

WITH cte AS (
    SELECT *, LAG(arrival_time, 1) OVER(ORDER BY arrival_time) AS prev_bus_time
    FROM Buses
)
SELECT c.bus_id, 
SUM(CASE WHEN c.arrival_time >= p.arrival_time AND p.arrival_time > IFNULL(c.prev_bus_time, 0) 
                THEN 1 ELSE 0 END) AS passengers_cnt
FROM cte AS c
LEFT JOIN Passengers AS p
ON c.arrival_time >= p.arrival_time
GROUP BY c.bus_id
ORDER BY c.bus_id;

--------------------------------------------------------------------------------------------------


-- m2
SELECT bus_id,
    COUNT(passenger_id) - LAG(COUNT(passenger_id), 1, 0) OVER (ORDER BY b.arrival_time
    ) AS passengers_cnt
FROM
    Buses AS b
    LEFT JOIN Passengers AS p ON p.arrival_time <= b.arrival_time
GROUP BY 1
ORDER BY 1;


--------------------------------------------------------------------------------------------------
-- m3
WITH bus_time_info as (
    SELECT bus_id,
            (LAG(arrival_time,1,-1) OVER(ORDER BY arrival_time)) + 1 as prev_arrival_time,
        arrival_time
    FROM Buses 
)
SELECT bti.bus_id,
       COUNT(p.passenger_id) AS passenger_cnt
FROM bus_time_info bti 
LEFT JOIN passengers p 
ON p.arrival_time between bti.prev_arrival_time and bti.arrival_time
GROUP BY bti.bus_id
ORDER BY bti.bus_id ;