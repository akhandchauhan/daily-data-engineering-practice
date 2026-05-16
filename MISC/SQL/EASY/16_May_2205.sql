-- 2205. The Number of Users That Are Eligible for Discount

-- Description
-- Table: Purchases
--
-- +-------------+----------+
-- | Column Name | Type     |
-- +-------------+----------+
-- | user_id     | int      |
-- | time_stamp  | datetime |
-- | amount      | int      |
-- +-------------+----------+
--
-- (user_id, time_stamp) is the primary key for this table.
--
-- Each row contains information about the purchase time
-- and the amount paid for the user with ID user_id.
--
-- A user is eligible for a discount if they had a purchase
-- in the inclusive interval of time [startDate, endDate]
-- with at least minAmount amount.
--
-- To convert the dates to times, both dates should be
-- considered as the start of the day.
--
-- Example:
-- endDate = '2022-03-05'
-- should be considered as:
-- '2022-03-05 00:00:00'
--
-- Write an SQL query to report the number of users
-- that are eligible for a discount.
--
-- The query result format is shown in the example below.
--
-- Example:
--
-- Input:
--
-- Purchases table:
--
-- +---------+---------------------+--------+
-- | user_id | time_stamp          | amount |
-- +---------+---------------------+--------+
-- | 1       | 2022-04-20 09:03:00 | 4416   |
-- | 2       | 2022-03-19 19:24:02 | 678    |
-- | 3       | 2022-03-18 12:03:09 | 4523   |
-- | 3       | 2022-03-30 09:43:42 | 626    |
-- +---------+---------------------+--------+
--
-- startDate = '2022-03-08'
-- endDate = '2022-03-20'
-- minAmount = 1000
--
-- Output:
--
-- +----------+
-- | user_cnt |
-- +----------+
-- | 1        |
-- +----------+
--
-- Explanation:
--
-- Out of the three users, only User 3 is eligible for a discount.
--
-- User 1:
-- Had a purchase with at least minAmount amount,
-- but not within the time interval.
--
-- User 2:
-- Had a purchase within the time interval,
-- but with less than minAmount amount.
--
-- User 3:
-- Is the only user who satisfies both conditions.

DROP TABLE IF EXISTS Purchases;
-- Create Table
CREATE TABLE Purchases (
    user_id INT,
    time_stamp DATETIME,
    amount INT,
    PRIMARY KEY (user_id, time_stamp)
);


-- Insert Sample Data
INSERT INTO Purchases (user_id, time_stamp, amount) VALUES
(1, '2022-04-20 09:03:00', 4416),
(2, '2022-03-19 19:24:02', 678),
(3, '2022-03-18 12:03:09', 4523),
(3, '2022-03-30 09:43:42', 626);

CREATE FUNCTION getUserIDs(startDate DATE, endDate DATE, minAmount INT) RETURNS INT
BEGIN
  RETURN (
      # Write your MySQL query statement below.
      # Write your MySQL query statement below.
      SELECT count(DISTINCT user_id) AS user_cnt
      FROM Purchases
      WHERE time_stamp BETWEEN startDate AND endDate AND amount >= minAmount;
  );
END