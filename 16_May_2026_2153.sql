-- 2153. The Number of Passengers in Each Bus II

-- Table: Buses
-- +--------------+------+
-- | Column Name  | Type |
-- +--------------+------+
-- | bus_id       | int  |
-- | arrival_time | int  |
-- | capacity     | int  |
-- +--------------+------+
-- bus_id is the primary key column for this table.
-- Each row of this table contains information about the arrival time of a bus at the 
-- LeetCode station and its capacity (the number of empty seats it has).
-- No two buses will arrive at the same time and all bus capacities will be positive integers.
 
-- Table: Passengers
-- +--------------+------+
-- | Column Name  | Type |
-- +--------------+------+
-- | passenger_id | int  |
-- | arrival_time | int  |
-- +--------------+------+
-- passenger_id is the primary key column for this table.
-- Each row of this table contains information about the arrival time of a passenger 
-- at the LeetCode station.

-- Buses and passengers arrive at the LeetCode station. If a bus arrives at the 
-- station at a time tbus and a passenger arrived at a time tpassenger where 
-- tpassenger <= tbus and the passenger did not catch any bus, the passenger will 
-- use that bus. In addition, each bus has a capacity. If at the moment the bus 
-- arrives at the station there are more passengers waiting than its capacity capacity, 
-- only capacity passengers will use the bus.


-- Write an SQL query to report the number of users that used each bus.
-- Return the result table ordered by bus_id in ascending order.

-- Buses table:
-- +--------+--------------+----------+
-- | bus_id | arrival_time | capacity |
-- +--------+--------------+----------+
-- | 1      | 2            | 1        |
-- | 2      | 4            | 10       |
-- | 3      | 7            | 2        |
-- +--------+--------------+----------+
-- Passengers table:
-- +--------------+--------------+
-- | passenger_id | arrival_time |
-- +--------------+--------------+
-- | 11           | 1            |
-- | 12           | 1            |
-- | 13           | 5            |
-- | 14           | 6            |
-- | 15           | 7            |
-- +--------------+--------------+
-- Output: 
-- +--------+----------------+
-- | bus_id | passengers_cnt |
-- +--------+----------------+
-- | 1      | 1              |
-- | 2      | 1              |
-- | 3      | 2              |
-- +--------+----------------+
-- Explanation: 
-- - Passenger 11 arrives at time 1.
-- - Passenger 12 arrives at time 1.
-- - Bus 1 arrives at time 2 and collects passenger 11 as it has one empty seat.
-- - Bus 2 arrives at time 4 and collects passenger 12 as it has ten empty seats.
-- - Passenger 12 arrives at time 5.
-- - Passenger 13 arrives at time 6.
-- - Passenger 14 arrives at time 7.
-- - Bus 3 arrives at time 7 and collects passengers 12 and 13 as it has two empty seats.


DROP TABLE IF EXISTS Buses;
DROP TABLE IF EXISTS Passengers;

CREATE TABLE Buses (
    bus_id INT PRIMARY KEY,
    arrival_time INT,
    capacity INT
);

CREATE TABLE Passengers (
    passenger_id INT PRIMARY KEY,
    arrival_time INT
);

INSERT INTO Buses (bus_id, arrival_time, capacity) VALUES
(1, 2, 1),
(2, 4, 10),
(3, 7, 2);

INSERT INTO Passengers (passenger_id, arrival_time) VALUES
(11, 1),
(12, 1),
(13, 5),
(14, 6),
(15, 7);

WITH bus_info AS (
    SELECT
        bus_id,
        (LAG(arrival_time,1,-1) OVER(ORDER BY arrival_time)) +1 AS start_time,
        arrival_time AS end_time,
        capacity
    FROM Buses
),
bus_capacity_info AS (
    SELECT 
        p.passenger_id,
        p.arrival_time,
        bi.bus_id,
        bi.capacity,
        CAST(bi.capacity AS SIGNED) - CAST(
            ROW_NUMBER() OVER(
                PARTITION BY bi.bus_id
                ORDER BY p.arrival_time
            )
        AS SIGNED )  AS passenger_rank
    FROM bus_info bi
    LEFT JOIN  passengers p
    ON p.arrival_time BETWEEN bi.start_time AND bi.end_time
),
special_passenger AS (
    SELECT 
        original_bus_id AS bus_id,
        COUNT(*) AS passengers_cnt
    FROM (
    SELECT 
            bus_id,
            CASE 
                WHEN LEAD(capacity) OVER(ORDER BY arrival_time) - capacity >= 0 
                THEN LEAD(bus_id) OVER(ORDER BY arrival_time) 
                ELSE NULL
            END AS original_bus_id
    FROM bus_capacity_info
    WHERE passenger_id IS NULL 
    OR passenger_rank < 0
    ) t
    GROUP BY 1
),
normal_passengers AS (
SELECT
    bus_id,
    count(*) as passengers_cnt
FROM bus_capacity_info
WHERE passenger_rank >= 0
GROUP BY 
        bus_id
)
SELECT
    bus_id,
    passengers_cnt
FROM normal_passengers
UNION ALL
SELECT
    bus_id,
    passengers_cnt
FROM special_passenger