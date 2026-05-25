-- 2783. Flight Occupancy and Waitlist Analysis

-- Table: Flights
-- +-------------+------+
-- | Column Name | Type |
-- +-------------+------+
-- | flight_id   | int  |
-- | capacity    | int  |
-- +-------------+------+
-- flight_id is the column with unique values for this table.
-- Each row of this table contains flight id and its capacity.
-- Table: Passengers
-- +--------------+------+
-- | Column Name  | Type |
-- +--------------+------+
-- | passenger_id | int  |
-- | flight_id    | int  |
-- +--------------+------+
-- passenger_id is the column with unique values for this table.
-- Each row of this table contains passenger id and flight id.

-- Passengers book tickets for flights in advance. If a passenger books a 
-- ticket for a flight and there are still empty seats available, 
-- the ticket will be confirmed. However, the passenger will
-- be on a waitlist if the flight is already at full capacity.

-- Write a solution to report the number of passengers who successfully 
-- booked a flight (got a seat) and the number of passengers who are 
-- on the waitlist for each flight.
-- Return the result table ordered by flight_id in ascending order.
-- Input:
-- Flights table:
-- +-----------+----------+
-- | flight_id | capacity |
-- +-----------+----------+
-- | 1         | 2        |
-- | 2         | 2        |
-- | 3         | 1        |
-- +-----------+----------+
-- Passengers table:
-- +--------------+-----------+
-- | passenger_id | flight_id |
-- +--------------+-----------+
-- | 101          | 1         |
-- | 102          | 1         |
-- | 103          | 1         |
-- | 104          | 2         |
-- | 105          | 2         |
-- | 106          | 3         |
-- | 107          | 3         |
-- +--------------+-----------+
-- Output:
-- +-----------+------------+--------------+
-- | flight_id | booked_cnt | waitlist_cnt |
-- +-----------+------------+--------------+
-- | 1         | 2          | 1            |
-- | 2         | 2          | 0            |
-- | 3         | 1          | 1            |
-- +-----------+------------+--------------+
DROP TABLE Flights;
DROP TABLE Passengers;
Create table if not exists Flights(flight_id int, capacity int);
Create table if not exists Passengers (passenger_id int, flight_id int);
Truncate table Flights;
insert into Flights (flight_id, capacity) values ('1', '2'),('2', '2'),('3', '1');
Truncate table Passengers;
INSERT INTO Passengers (passenger_id, flight_id) VALUES
('101', '1'),
('102', '1'),
('103', '1'),
('104', '2'),
('105', '2'),
('106', '3'),
('107', '3');

-- m1
WITH flight_info AS (
SELECT 
    f.flight_id,
    f.capacity,
    p.passenger_id,
    CAST(f.capacity AS signed) - CAST(ROW_NUMBER() OVER(
                PARTITION BY f.flight_id
                ORDER BY passenger_id
    ) AS signed) AS passenger_assign
FROM Flights f
LEFT JOIN Passengers p 
ON f.flight_id = p.flight_id
)
SELECT 
    flight_id,
    SUM(CASE WHEN passenger_assign >= 0 THEN 1 ELSE 0 END) AS booked_cnt,
    SUM(CASE WHEN passenger_assign < 0 THEN 1 ELSE 0 END) AS waitlist_cnt
FROM flight_info
GROUP BY flight_id
ORDER BY flight_id;

-------------------------------------------------------------------------------

-- m2
WITH passenger_info AS (
    SELECT
        f.flight_id,
        f.capacity,
        p.passenger_id,
        ROW_NUMBER() OVER(
            PARTITION BY f.flight_id
            ORDER BY p.passenger_id
        ) AS rn
    FROM Flights f
    LEFT JOIN Passengers p
    ON f.flight_id = p.flight_id
)
SELECT
    flight_id,
    SUM(CASE WHEN rn <= capacity THEN 1 ELSE 0 END) AS booked_cnt,
    SUM(CASE WHEN rn > capacity THEN 1 ELSE 0 END) AS waitlist_cnt
FROM passenger_info
GROUP BY flight_id
ORDER BY flight_id;