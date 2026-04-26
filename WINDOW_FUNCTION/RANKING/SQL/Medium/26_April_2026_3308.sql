-- 3308. Find Top Performing Driver 

-- Description
-- Table: Drivers
-- +--------------+---------+
-- | Column Name  | Type    |
-- +--------------+---------+
-- | driver_id    | int     |
-- | name         | varchar |
-- | age          | int     |
-- | experience   | int     |
-- | accidents    | int     |
-- +--------------+---------+
-- (driver_id) is the unique key for this table.
-- Each row includes a driver's ID, their name, age, years of driving experience, 
-- and the number of accidents they’ve had.

-- Table: Vehicles
-- +--------------+---------+
-- | vehicle_id   | int     |
-- | driver_id    | int     |
-- | model        | varchar |
-- | fuel_type    | varchar |
-- | mileage      | int     |
-- +--------------+---------+
-- (vehicle_id, driver_id, fuel_type) is the unique key for this table.
-- Each row includes the vehicle's ID, the driver who operates it, the model,
-- fuel type, and mileage.

-- Table: Trips
-- +--------------+---------+
-- | trip_id      | int     |
-- | vehicle_id   | int     |
-- | distance     | int     |
-- | duration     | int     |
-- | rating       | int     |
-- +--------------+---------+
-- (trip_id) is the unique key for this table.
-- Each row includes a trip's ID, the vehicle used, the distance covered 
-- (in miles), the trip duration (in minutes), and the passenger's rating (1-5).

-- Uber is analyzing drivers based on their trips. Write a solution to find the 
-- top-performing driver for each fuel type based on the following criteria:

-- A driver's performance is calculated as the average rating across all their trips.
-- Average rating should be rounded to 2 decimal places.
-- If two drivers have the same average rating, the driver with the longer 
-- total distance traveled should be ranked higher.
-- If there is still a tie, choose the driver with the fewest accidents.
-- Return the result table ordered by fuel_type in ascending order.

-- Drivers table:
-- +-----------+----------+-----+------------+-----------+
-- | driver_id | name     | age | experience | accidents |
-- +-----------+----------+-----+------------+-----------+
-- | 1         | Alice    | 34  | 10         | 1         |
-- | 2         | Bob      | 45  | 20         | 3         |
-- | 3         | Charlie  | 28  | 5          | 0         |
-- +-----------+----------+-----+------------+-----------+

-- Vehicles table:
-- +------------+-----------+---------+-----------+---------+
-- | vehicle_id | driver_id | model   | fuel_type | mileage |
-- +------------+-----------+---------+-----------+---------+
-- | 100        | 1         | Sedan   | Gasoline  | 20000   |
-- | 101        | 2         | SUV     | Electric  | 30000   |
-- | 102        | 3         | Coupe   | Gasoline  | 15000   |
-- +------------+-----------+---------+-----------+---------+

-- Trips table:
-- +---------+------------+----------+----------+--------+
-- | trip_id | vehicle_id | distance | duration | rating |
-- +---------+------------+----------+----------+--------+
-- | 201     | 100        | 50       | 30       | 5      |
-- | 202     | 100        | 30       | 20       | 4      |
-- | 203     | 101        | 100      | 60       | 4      |
-- | 204     | 101        | 80       | 50       | 5      |
-- | 205     | 102        | 40       | 30       | 5      |
-- | 206     | 102        | 60       | 40       | 5      |
-- +---------+------------+----------+----------+--------+

-- Output:
-- +-----------+-----------+--------+----------+
-- | fuel_type | driver_id | rating | distance |
-- +-----------+-----------+--------+----------+
-- | Electric  | 2         | 4.50   | 180      |
-- | Gasoline  | 3         | 5.00   | 100      |
-- +-----------+-----------+--------+----------+
-- Explanation:

-- For fuel type Gasoline, both Alice (Driver 1) and Charlie (Driver 3) have trips.
-- Charlie has an average rating of 5.0, while Alice has 4.5. Therefore,
-- Charlie is selected.
-- For fuel type Electric, Bob (Driver 2) is the only driver with an average
-- rating of 4.5, so he is selected.
-- The output table is ordered by fuel_type in ascending order.

-- Drop tables if they exist
DROP TABLE IF EXISTS Trips;
DROP TABLE IF EXISTS Vehicles;
DROP TABLE IF EXISTS Drivers;

-- Create Drivers table
CREATE TABLE Drivers (
    driver_id INT PRIMARY KEY,
    name VARCHAR(50),
    age INT,
    experience INT,
    accidents INT
);

-- Create Vehicles table
CREATE TABLE Vehicles (
    vehicle_id INT,
    driver_id INT,
    model VARCHAR(50),
    fuel_type VARCHAR(50),
    mileage INT,
    PRIMARY KEY (vehicle_id, driver_id, fuel_type)
);

-- Create Trips table
CREATE TABLE Trips (
    trip_id INT PRIMARY KEY,
    vehicle_id INT,
    distance INT,
    duration INT,
    rating INT
);

-- Insert into Drivers
INSERT INTO Drivers VALUES
(1, 'Alice', 34, 10, 1),
(2, 'Bob', 45, 20, 3),
(3, 'Charlie', 28, 5, 0);

-- Insert into Vehicles
INSERT INTO Vehicles VALUES
(100, 1, 'Sedan', 'Gasoline', 20000),
(101, 2, 'SUV', 'Electric', 30000),
(102, 3, 'Coupe', 'Gasoline', 15000);

-- Insert into Trips
INSERT INTO Trips VALUES
(201, 100, 50, 30, 5),
(202, 100, 30, 20, 4),
(203, 101, 100, 60, 4),
(204, 101, 80, 50, 5),
(205, 102, 40, 30, 5),
(206, 102, 60, 40, 5);

WITH driver_info AS (
    SELECT 
            v.fuel_type,
            v.driver_id,
            d.accidents,
            ROUND(
                AVG(t.rating)
            ,2) AS rating,
            SUM(t.distance) AS distance
    FROM Vehicles v 
    JOIN Trips t 
    ON v.vehicle_id = t.vehicle_id
    JOIN Drivers d
    ON d.driver_id = v.driver_id 
    GROUP BY v.fuel_type,
            v.driver_id,
            d.accidents
),
driver_ranked AS(
    SELECT 
        fuel_type,
        driver_id,
        rating,
        distance,
        ROW_NUMBER() OVER(
            PARTITION BY fuel_type
            ORDER BY rating DESC,
                    distance DESC,
                    accidents
        ) AS driver_rank
    FROM driver_info
)
SELECT 
    fuel_type,
    driver_id,
    rating,
    distance
FROM driver_ranked
WHERE driver_rank = 1
ORDER BY fuel_type;