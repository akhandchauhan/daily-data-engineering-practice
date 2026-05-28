-- 2238. Number of Times a Driver Was a Passenger

-- Table: Rides
-- +--------------+------+
-- | Column Name  | Type |
-- +--------------+------+
-- | ride_id      | int  |
-- | driver_id    | int  |
-- | passenger_id | int  |
-- +--------------+------+
-- ride_id is the primary key for this table.
-- Each row of this table contains the ID of the driver and the ID of the passenger that rode 
-- in ride_id. Note that driver_id != passenger_id.

-- Write an  SQL query to report the ID of each driver and the number of
--  times they were a passenger.

-- Return the result table in any order.
-- Rides table:
-- +---------+-----------+--------------+
-- | ride_id | driver_id | passenger_id |
-- +---------+-----------+--------------+
-- | 1       | 7         | 1            |
-- | 2       | 7         | 2            |
-- | 3       | 11        | 1            |
-- | 4       | 11        | 7            |
-- | 5       | 11        | 7            |
-- | 6       | 11        | 3            |
-- +---------+-----------+--------------+
-- Output: 
-- +-----------+-----+
-- | driver_id | cnt |
-- +-----------+-----+
-- | 7         | 2   |
-- | 11        | 0   |
-- +-----------+-----+
-- Explanation: 
-- There are two drivers in all the given rides: 7 and 11.
-- The driver with ID = 7 was a passenger two times.
-- The driver with ID = 11 was never a passenger.

DROP TABLE IF EXISTS Rides;

CREATE TABLE Rides (
    ride_id INT PRIMARY KEY,
    driver_id INT,
    passenger_id INT
);

INSERT INTO Rides (ride_id, driver_id, passenger_id) VALUES
(1, 7, 1),
(2, 7, 2),
(3, 11, 1),
(4, 11, 7),
(5, 11, 7),
(6, 11, 3);

WITH driver_info AS (
    SELECT
        passenger_id AS driver_id,
        COUNT(*) AS cnt
    FROM Rides
    GROUP BY 
            passenger_id
),
all_driver_info AS (
    SELECT 
            DISTINCT driver_id
    FROM Rides
)
SELECT 
    adi.driver_id,
    COALESCE(cnt, 0) AS cnt
FROM all_driver_info adi 
LEFT JOIN driver_info di 
ON adi.driver_id = di.driver_id ;