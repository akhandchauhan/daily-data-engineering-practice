# -- 3204. Bitwise User Permissions Analysis 
# -- Description
# -- Table: user_permissions
# -- +-------------+---------+
# -- | Column Name | Type    |
# -- +-------------+---------+
# -- | user_id     | int     |
# -- | permissions | int     |
# -- +-------------+---------+
# -- user_id is the primary key.
# -- Each row of this table contains the user ID and their permissions encoded as an integer.
# -- Consider that each bit in the permissions integer represents a different access level or 
# -- feature that a user has.
# -- Write a solution to calculate the following:
# -- common_perms: The access level granted to all users. This is computed using a bitwise 
# -- AND operation on the permissions column.
# -- any_perms: The access level granted to any user. This is computed using a bitwise OR 
# -- operation on the permissions column.
# -- Return the result table in any order.
# -- The result format is shown in the following example.
# -- Example:
# -- Input:
# -- user_permissions table:
# -- +---------+-------------+
# -- | user_id | permissions |
# -- +---------+-------------+
# -- | 1       | 5           |
# -- | 2       | 12          |
# -- | 3       | 7           |
# -- | 4       | 3           |
# -- +---------+-------------+
# -- Output:
# -- +-------------+--------------+
# -- | common_perms | any_perms   |
# -- +--------------+-------------+
# -- | 0            | 15          |
# -- +--------------+-------------+
# -- Explanation:
# -- common_perms: Represents the bitwise AND result of all permissions:
# -- <ul>
# -- 	<li>For user 1 (5): 5 (binary 0101)</li>
# -- 	<li>For user 2 (12): 12 (binary 1100)</li>
# -- 	<li>For user 3 (7): 7 (binary 0111)</li>
# -- 	<li>For user 4 (3): 3 (binary 0011)</li>
# -- 	<li>Bitwise AND: 5 &amp; 12 &amp; 7 &amp; 3 = 0 (binary 0000)</li>
# -- </ul>
# -- </li>
# -- <li><strong>any_perms:</strong> Represents the bitwise OR result of all permissions:
# -- <ul>
# -- 	<li>Bitwise OR: 5 | 12 | 7 | 3 = 15 (binary 1111)</li>
# -- </ul>



import pandas as pd

df = pd.DataFrame({
    'user_id': [1, 2, 3, 4],
    'permissions': [5, 12, 7, 3]
})

common_perms = df['permissions'].iloc[0]
any_perms = df['permissions'].iloc[0]


for val in df['permissions'].iloc[1:]:
    common_perms = common_perms & val
    any_perms = any_perms | val

result = pd.DataFrame({
    'common_perms': [common_perms],
    'any_perms': [any_perms]
})

print(result)
