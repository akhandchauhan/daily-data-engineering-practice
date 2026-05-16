-- 2230. The Users That Are Eligible for Discount

-- Table: Purchases
-- +-------------+----------+
-- | Column Name | Type     |
-- +-------------+----------+
-- | user_id     | int      |
-- | time_stamp  | datetime |
-- | amount      | int      |
-- +-------------+----------+
-- (user_id, time_stamp) is the primary key for this table.
-- Each row contains information about the purchase time and the amount
-- paid for the user with ID user_id.

-- A user is eligible for a discount if they had a purchase in the
-- inclusive interval of time [startDate, endDate]
-- with at least minAmount amount.

-- Both dates should be considered as the start of the day.
-- Example:
-- endDate = '2022-03-05'
-- means '2022-03-05 00:00:00'

-- Write an SQL query to report the IDs of the users
-- that are eligible for a discount.

-- Return the result table ordered by user_id.

DROP PROCEDURE IF EXISTS getUserIDs;

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


CREATE PROCEDURE getUserIDs(
    IN startDate DATE,
    IN endDate DATE,
    IN minAmount INT
)
BEGIN

    SELECT DISTINCT user_id
    FROM Purchases
    WHERE amount >= minAmount
      AND time_stamp BETWEEN startDate AND endDate
    ORDER BY user_id;

END;

-- Call Procedure
CALL getUserIDs('2022-03-08', '2022-03-20', 1000);

