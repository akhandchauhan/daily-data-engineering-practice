-- find companies who have atleast 2 users who speaks both 
-- english and german

DROP TABLE IF EXISTS company_users;
create table company_users 
(
company_id int,
user_id int,
language varchar(20)
);

insert into company_users values (1,1,'English')
,(1,1,'German')
,(1,2,'English')
,(1,3,'German')
,(1,3,'English')
,(1,4,'English')
,(2,5,'English')
,(2,5,'German')
,(2,5,'Spanish')
,(2,6,'German')
,(2,6,'Spanish')
,(2,7,'English');

WITH user_language_info AS (
    SELECT
            company_id,
            user_id
    FROM company_users
    WHERE language IN ('English','German') -- ✓ pre-filter before GROUP BY
    GROUP BY
            company_id,
            user_id
    HAVING
          COUNT(DISTINCT language) = 2
)
SELECT
        company_id
FROM user_language_info
GROUP BY
        company_id
HAVING COUNT(user_id) >= 2