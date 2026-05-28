-- 3204. Bitwise User Permissions Analysis 

-- Table: user_permissions
-- +-------------+---------+
-- | Column Name | Type    |
-- +-------------+---------+
-- | user_id     | int     |
-- | permissions | int     |
-- +-------------+---------+
-- user_id is the primary key.
-- Each row of this table contains the user ID and their permissions encoded as an integer.
-- Consider that each bit in the permissions integer represents a different access level or 
-- feature that a user has.

-- Write a solution to calculate the following:

-- common_perms: The access level granted to all users. This is computed using a bitwise 
-- AND operation on the permissions column.
-- any_perms: The access level granted to any user. This is computed using a bitwise OR 
-- operation on the permissions column.
-- Return the result table in any order.
-- Input:

-- user_permissions table:

-- +---------+-------------+
-- | user_id | permissions |
-- +---------+-------------+
-- | 1       | 5           |
-- | 2       | 12          |
-- | 3       | 7           |
-- | 4       | 3           |
-- +---------+-------------+
--  
-- Output:

-- +-------------+--------------+
-- | common_perms | any_perms   |
-- +--------------+-------------+
-- | 0            | 15          |
-- +--------------+-------------+
--     
-- Explanation:

-- common_perms: Represents the bitwise AND result of all permissions:
-- <ul>
-- 	<li>For user 1 (5): 5 (binary 0101)</li>
-- 	<li>For user 2 (12): 12 (binary 1100)</li>
-- 	<li>For user 3 (7): 7 (binary 0111)</li>
-- 	<li>For user 4 (3): 3 (binary 0011)</li>
-- 	<li>Bitwise AND: 5 &amp; 12 &amp; 7 &amp; 3 = 0 (binary 0000)</li>
-- </ul>
-- </li>
-- <li><strong>any_perms:</strong> Represents the bitwise OR result of all permissions:
-- <ul>
-- 	<li>Bitwise OR: 5 | 12 | 7 | 3 = 15 (binary 1111)</li>
-- </ul>
-- </li>

Create table if not exists user_permissions(user_id int, permissions int);
Truncate table user_permissions;
INSERT INTO user_permissions (user_id, permissions)
VALUES
    (1, 5),
    (2, 12),
    (3, 7),
    (4, 3);

-- m1
SELECT bit_and(permissions) as common_perm,bit_or(permissions) as any_perm
FROM user_permissions;

----------------------------------------------------------------------------------------------------
-- m2

WITH RECURSIVE perms AS (
    SELECT 
        user_id,
        permissions,
        ROW_NUMBER() OVER (ORDER BY user_id) AS rn
    FROM user_permissions
),
cte AS (
    SELECT
        rn,
        permissions AS common_perms,
        permissions AS any_perms
    FROM perms
    WHERE rn = 1

    UNION ALL

    SELECT
        p.rn,
        c.common_perms & p.permissions,
        c.any_perms | p.permissions
    FROM cte c
    JOIN perms p
    ON p.rn = c.rn + 1
)
SELECT
    common_perms,
    any_perms
FROM cte
ORDER BY rn DESC
LIMIT 1;

