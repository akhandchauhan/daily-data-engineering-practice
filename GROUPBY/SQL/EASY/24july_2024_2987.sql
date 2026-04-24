-- 2987. Find Expensive Cities
-- Description
-- Table: Listings
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | listing_id  | int     |
-- | city        | varchar |
-- | price       | int     |
-- +-------------+---------+
-- listing_id is column of unique values for this table.
-- This table contains listing_id, city, and price.

-- Write a solution to find cities where the average home prices exceed the 
-- national average home price.

-- Return the result table sorted by city in ascending order.

-- Input: 
-- Listings table:
-- +------------+--------------+---------+
-- | listing_id | city         | price   | 
-- +------------+--------------+---------+
-- | 113        | LosAngeles   | 7560386 | 
-- | 136        | SanFrancisco | 2380268 |
-- | 92         | Chicago      | 9833209 | 
-- | 60         | Chicago      | 5147582 | 
-- | 8          | Chicago      | 5274441 |  
-- | 79         | SanFrancisco | 8372065 | 
-- | 37         | Chicago      | 7939595 | 
-- | 53         | LosAngeles   | 4965123 | 
-- | 178        | SanFrancisco | 999207  | 
-- | 51         | NewYork      | 5951718 | 
-- | 121        | NewYork      | 2893760 | 
-- +------------+--------------+---------+
-- Output
-- +------------+
-- | city       | 
-- +------------+
-- | Chicago    | 
-- | LosAngeles |  
-- +------------+
-- Explanation
-- The national average home price is $6,122,059.45. Among the cities listed:
-- - Chicago has an average price of $7,043,706.75
-- - Los Angeles has an average price of $6,277,754.5
-- - San Francisco has an average price of $3,900,513.33
-- - New York has an average price of $4,422,739
-- Only Chicago and Los Angeles have average home prices exceeding the national average. 
-- Therefore, these two cities are included in the output table. 
-- The output table is sorted in ascending order based on the city names.
Create Table if Not Exists Listings (listing_id int, city varchar(50), price int);
Truncate table Listings;
INSERT INTO Listings (listing_id, city, price)
VALUES
('113', 'LosAngeles', '7560386'),
('136', 'SanFrancisco', '2380268'),
('92', 'Chicago', '9833209'),
('60', 'Chicago', '5147582'),
('8', 'Chicago', '5274441'),
('79', 'SanFrancisco', '8372065'),
('37', 'Chicago', '7939595'),
('53', 'LosAngeles', '4965123'),
('178', 'SanFrancisco', '999207'),
('51', 'NewYork', '5951718'),
('121', 'NewYork', '2893760');

-- m1 final interview ready
SELECT city
FROM Listings
GROUP BY city
HAVING AVG(price) >(SELECT AVG(price) from Listings)
ORDER BY city;

---------------------------------------------------------------------------------------
--m2
WITH city_info AS (
SELECT 
    city,
    AVG(price) OVER() AS overall_avg,
    AVG(price) OVER(PARTITION BY city) AS city_avg
FROM Listings
)
SELECT 
    DISTINCT city
FROM city_info 
WHERE city_avg > overall_avg
ORDER BY city;
