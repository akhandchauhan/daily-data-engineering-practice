-- 2199. Finding the Topic of Each Post
-- Description
-- Table: Keywords
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | topic_id    | int     |
-- | word        | varchar |
-- +-------------+---------+
-- (topic_id, word) is the primary key (combination of columns with unique values) for this table.
-- Each row of this table contains the id of a topic and a word that is used to express this topic.
-- There may be more than one word to express the same topic and one word may be used to
-- express multiple topics.
-- Table: Posts
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | post_id     | int     |
-- | content     | varchar |
-- +-------------+---------+
-- post_id is the primary key (column with unique values) for this table.
-- Content will consist only of English letters and spaces.
-- Write a solution to find the topics of each post:
-- If the post does not have keywords from any topic, its topic should be "Ambiguous!".
-- If the post has at least one keyword of any topic, its topic should be a string of the IDs
-- of its topics sorted in ascending order and separated by commas ','.
-- Return the result table in any order.
-- The result format is in the following example.
-- Example 1:
-- Input:
-- Keywords table:
-- +----------+----------+
-- | topic_id | word     |
-- +----------+----------+
-- | 1        | handball |
-- | 1        | football |
-- | 3        | WAR      |
-- | 2        | Vaccine  |
-- +----------+----------+
-- Posts table:
-- +---------+------------------------------------------------------------------------+
-- | post_id | content                                                                |
-- +---------+------------------------------------------------------------------------+
-- | 1       | We call it soccer They call it football hahaha                         |
-- | 2       | Americans prefer basketball while Europeans love handball and football |
-- | 3       | stop the war and play handball                                         |
-- | 4       | warning I planted some flowers this morning and then got vaccinated    |
-- +---------+------------------------------------------------------------------------+
-- Output:
-- +---------+------------+
-- | post_id | topic      |
-- +---------+------------+
-- | 1       | 1          |
-- | 2       | 1          |
-- | 3       | 1,3        |
-- | 4       | Ambiguous! |
-- +---------+------------+
-- Explanation:
-- 1: "football" expresses topic 1.
-- 2: "handball" and "football" both express topic 1.
-- 3: "war" expresses topic 3, "handball" expresses topic 1.
-- 4: "warning" is different from "war" — this post is ambiguous.

DROP TABLE IF EXISTS Keywords;
DROP TABLE IF EXISTS Posts;

CREATE TABLE Keywords (
    topic_id INT,
    word VARCHAR(255),
    PRIMARY KEY (topic_id, word)
);

INSERT INTO Keywords (topic_id, word) VALUES
(1, 'handball'),
(1, 'football'),
(3, 'WAR'),
(2, 'Vaccine');

CREATE TABLE Posts (
    post_id INT PRIMARY KEY,
    content VARCHAR(500)
);

INSERT INTO Posts (post_id, content) VALUES
(1, 'We call it soccer They call it football hahaha'),
(2, 'Americans prefer basketball while Europeans love handball and football'),
(3, 'stop the war and play handball'),
(4, 'warning I planted some flowers this morning and then got vaccinated');

SELECT post_id,
    IFNULL(GROUP_CONCAT(DISTINCT topic_id ORDER BY topic_id), 'Ambiguous!') AS topic
FROM Posts
LEFT JOIN Keywords ON
CONCAT(' ', LOWER(content), ' ') LIKE CONCAT('% ', LOWER(word), ' %')
GROUP BY post_id;
