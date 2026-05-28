-- 2738. Count Occurrences in Text
-- Description
-- Table: Files
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | file_name   | varchar |
-- | content     | text    |
-- +-------------+---------+
-- file_name is the column with unique values of this table.
-- Each row contains file_name and the content of that file.
-- Write a solution to find the number of files that have at least one occurrence of the words 'bull'
-- and 'bear' as a standalone word, respectively, disregarding any instances where it appears without
-- space on either side (e.g. 'bullet', 'bears', 'bull.' will not be considered).
-- Return the word 'bull' and 'bear' along with the corresponding number of occurrences in any order.
-- The result format is in the following example.
-- Input:
-- Files table:
-- +------------+-----------------------------------------------------------------------------------+
-- | file_name  | content                                                                           |
-- +------------+-----------------------------------------------------------------------------------+
-- | draft1.txt | The stock exchange predicts a bull market which would make many investors happy. |
-- | draft2.txt | The stock exchange predicts a bull market which would make many investors happy, |
-- |            | but analysts warn of possibility of too much optimism and that in fact we are    |
-- |            | awaiting a bear market.                                                          |
-- | draft3.txt | The stock exchange predicts a bull market which would make many investors happy, |
-- |            | but analysts warn of possibility of too much optimism and that in fact we are    |
-- |            | awaiting a bear market. As always predicting the future market is an uncertain   |
-- |            | game and all investors should follow their instincts and best practices.         |
-- +------------+-----------------------------------------------------------------------------------+
-- Output:
-- +------+-------+
-- | word | count |
-- +------+-------+
-- | bull | 3     |
-- | bear | 2     |
-- +------+-------+
-- Explanation:
-- - The word "bull" appears 1 time in each of the three drafts, so total is 3.
-- - The word "bear" appears 1 time in draft2 and draft3, so total is 2.

DROP TABLE Files;
Create table If Not Exists Files (file_name varchar(100), content text);

insert into Files (file_name, content) values ('draft1.txt', 'The stock exchange predicts a bull market which would make many investors happy.');
insert into Files (file_name, content) values ('draft2.txt', 'The stock exchange predicts a bull market which would make many investors happy, but analysts warn of possibility of too much optimism and that in fact we are awaiting a bear market.');
insert into Files (file_name, content) values ('final.txt', 'The stock exchange predicts a bull market which would make many investors happy, but analysts warn of possibility of too much optimism and that in fact we are awaiting a bear market. As always predicting the future market is an uncertain game and all investors should follow their instincts and best practices.');

SELECT 'bull' AS word, COUNT(*) AS count
FROM Files
WHERE content LIKE '% bull %'
UNION
SELECT 'bear' AS word, COUNT(*) AS count
FROM Files
WHERE content LIKE '% bear %';
