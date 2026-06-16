-- find cities where covid cases are increasing continuosly

create table covid(city varchar(50),days date,cases int);
delete from covid;

INSERT INTO covid VALUES
('DELHI','2022-01-01',100),('DELHI','2022-01-02',200),('DELHI','2022-01-03',300),
('MUMBAI','2022-01-01',100),('MUMBAI','2022-01-02',100),('MUMBAI','2022-01-03',300),
('CHENNAI','2022-01-01',100),('CHENNAI','2022-01-02',200),('CHENNAI','2022-01-03',150),
('BANGALORE','2022-01-01',100),('BANGALORE','2022-01-02',300),('BANGALORE','2022-01-03',200),
('BANGALORE','2022-01-04',400);

 -- m1
WITH city_ranked AS (
    SELECT
        city,
        CAST(
            RANK() OVER(               -- ✓ correct: chronological rank per city
                PARTITION BY city
                ORDER BY days
        ) AS SIGNED) -                 -- ❌ CAST unnecessary; RANK() returns signed BIGINT in MySQL 8.0
        CAST( RANK() OVER(             -- ❌ second full window scan; one LAG() achieves same in a single pass
                PARTITION BY city
                ORDER BY cases         -- ❌ NULLs in `cases` sort first (ASC), giving them RANK 1 and producing diff=0 — silent false positive
        ) AS SIGNED) AS diff
    FROM covid
)
SELECT
     city
FROM city_ranked
GROUP BY
        city
HAVING
    COUNT(distinct diff) = 1           -- ✓ elegant: all rows must share the same rank delta
    AND MAX(diff) = 0;                 -- ❌ single-row city (diff=0, count=1) passes this — no COUNT(*) > 1 guard
