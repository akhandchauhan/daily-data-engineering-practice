-- 2820. Election Results
-- Description
-- Table: Votes
-- +-------------+---------+ 
-- | Column Name | Type    | 
-- +-------------+---------+ 
-- | voter       | varchar | 
-- | candidate   | varchar |
-- +-------------+---------+
-- (voter, candidate) is the primary key (combination of unique values) for this table.
-- Each row of this table contains name of the voter and their candidate. 
-- The election is conducted in a city where everyone can vote for one or more candidates or choose 
--not to vote. Each person has 
-- 1 vote so if they vote for multiple candidates, their vote gets equally split across them. 
-- For example, if a person votes for 2 candidates, these candidates receive an equivalent of 0.5 
--votes each.
-- Write a solution to find candidate who got the most votes and won the election. Output the name 
--of the candidate or If multiple
-- candidates have an equal number of votes, display the names of all of them.
-- Return the result table ordered by candidate in ascending order.
-- The result format is in the following example.
-- Example 1:
-- Input: 
-- Votes table:
-- +----------+-----------+
-- | voter    | candidate |
-- +----------+-----------+
-- | Kathy    | null      |
-- | Charles  | Ryan      |
-- | Charles  | Christine |
-- | Charles  | Kathy     |
-- | Benjamin | Christine |
-- | Anthony  | Ryan      |
-- | Edward   | Ryan      |
-- | Terry    | null      |
-- | Evelyn   | Kathy     |
-- | Arthur   | Christine |
-- +----------+-----------+
-- Output: 
-- +-----------+
-- | candidate | 
-- +-----------+
-- | Christine |  
-- | Ryan      |  
-- +-----------+
-- Explanation: 
-- - Kathy and Terry opted not to participate in voting, resulting in their votes 
--being recorded as 0. Charles distributed 
-- his vote among three candidates, equating to 0.33 for each candidate. On the 
--other hand, Benjamin, Arthur, Anthony, Edward, 
-- and Evelyn each cast their votes for a single candidate.
-- - Collectively, Candidate Ryan and Christine amassed a total of 2.33 votes, 
--while Kathy received a combined total of 1.33 votes.
-- Since Ryan and Christine received an equal number of votes, we will display
-- their names in ascending order.


DROP TABLE Votes;

Create table if not exists Votes(voter varchar(30), candidate varchar(30));
Truncate table Votes;

INSERT INTO Votes (voter, candidate) VALUES
('Kathy', NULL),
('Charles', 'Ryan'),
('Charles', 'Christine'),
('Charles', 'Kathy'),
('Benjamin', 'Christine'),
('Anthony', 'Ryan'),
('Edward', 'Ryan'),
('Terry', NULL),
('Evelyn', 'Kathy'),
('Arthur', 'Christine');

WITH vote_split AS (
    SELECT 
        voter,
        candidate,
        1.0 / COUNT(*) OVER (PARTITION BY voter) AS vote_share
    FROM Votes
    WHERE candidate IS NOT NULL
)
SELECT candidate
FROM (
    SELECT 
        candidate,
        DENSE_RANK() OVER (ORDER BY SUM(vote_share) DESC) AS rnk
    FROM vote_split
    GROUP BY candidate
) t
WHERE rnk = 1
ORDER BY candidate;

-----------------------------------------------------------------------------------------------------------

-- m2
WITH voter_info AS (
    SELECT 
            voter,
            SUM(CASE WHEN candidate IS NOT NULL THEN 1 ELSE 0 END) AS voter_count
    FROM Votes 
    GROUP BY voter
),
candidate_voter_info AS (
    SELECT 
            v.voter,
            v.candidate,
            CASE 
                WHEN vi.voter_count > 1 
                THEN 1*1.0/vi.voter_count 
                ELSE vi.voter_count
            END 
            AS candidate_vote_count 
    FROM voter_info vi 
    JOIN votes v 
    ON vi.voter = v.voter 
)
SELECT candidate
FROM (
    SELECT 
            candidate,
            DENSE_RANK() OVER(
                        ORDER BY SUM(candidate_vote_count) DESC
                    )
                    AS candidate_rank
    FROM candidate_voter_info 
    GROUP BY candidate
) a 
WHERE candidate_rank = 1
ORDER BY candidate;