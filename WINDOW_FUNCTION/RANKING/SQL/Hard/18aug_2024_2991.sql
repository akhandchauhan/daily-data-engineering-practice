-- 2991. Top Three Wineries 
-- Description
-- Table: Wineries
-- +-------------+----------+
-- | Column Name | Type     |
-- +-------------+----------+
-- | id          | int      |
-- | country     | varchar  |
-- | points      | int      |
-- | winery      | varchar  |
-- +-------------+----------+
-- id is column of unique values for this table.
-- This table contains id, country, points, and winery.

-- Write a solution to find the top three wineries in each country based on 
--their total points. If multiple wineries have the same total points, 
--order them by winery name in ascending order. If there's no second winery,
-- output 'No Second Winery,' and if there's no third winery, output 'No Third Winery.'
-- Return the result table ordered by country in ascending order.
-- The result format is in the following example.
--  
-- Example 1:
-- Input: 
-- Wineries table:
-- +-----+-----------+--------+-----------------+
-- | id  | country   | points | winery          | 
-- +-----+-----------+--------+-----------------+
-- | 103 | Australia | 84     | WhisperingPines | 
-- | 737 | Australia | 85     | GrapesGalore    |    
-- | 848 | Australia | 100    | HarmonyHill     | 
-- | 222 | Hungary   | 60     | MoonlitCellars  | 
-- | 116 | USA       | 47     | RoyalVines      | 
-- | 124 | USA       | 45     | Eagle'sNest     | 
-- | 648 | India     | 69     | SunsetVines     | 
-- | 894 | USA       | 39     | RoyalVines      |  
-- | 677 | USA       | 9      | PacificCrest    |  
-- +-----+-----------+--------+-----------------+
-- Output: 
-- +-----------+---------------------+-------------------+----------------------+
-- | country   | top_winery          | second_winery     | third_winery         |
-- +-----------+---------------------+-------------------+----------------------+
-- | Australia | HarmonyHill (100)   | GrapesGalore (85) | WhisperingPines (84) |
-- | Hungary   | MoonlitCellars (60) | No second winery  | No third winery      | 
-- | India     | SunsetVines (69)    | No second winery  | No third winery      |  
-- | USA       | RoyalVines (86)     | Eagle'sNest (45)  | PacificCrest (9)     | 
-- +-----------+---------------------+-------------------+----------------------+
-- Explanation
-- For Australia
--  - HarmonyHill Winery accumulates the highest score of 100 points in Australia.
--  - GrapesGalore Winery has a total of 85 points, securing the second-highest position
-- in Australia.
--  - WhisperingPines Winery has a total of 80 points, ranking as the third-highest.
-- For Hungary
--  - MoonlitCellars is the sole winery, accruing 60 points, automatically making it the
-- highest. There is no second or third winery.
-- For India
--  - SunsetVines is the sole winery, earning 69 points, making it the top winery.
-- There is no second or third winery.
-- For the USA
--  - RoyalVines Wines accumulates a total of 47 + 39 = 86 points, claiming the highest
-- position in the USA.
--  - Eagle'sNest has a total of 45 points, securing the second-highest position in 
-- the USA.
--  - PacificCrest accumulates 9 points, ranking as the third-highest winery in the USA
-- Output table is ordered by country in ascending order.
Create table if Not Exists Wineries ( 
  id int, country varchar(60), points int, winery varchar(60)
  );
Truncate table Wineries;

INSERT INTO Wineries (id, country, points, winery) VALUES
(103, 'Australia', 84, 'WhisperingPines'),
(737, 'Australia', 85, 'GrapesGalore'),
(848, 'Australia', 100, 'HarmonyHill'),
(222, 'Hungary', 60, 'MoonlitCellars'),
(116, 'USA', 47, 'RoyalVines'),
(124, 'USA', 45, 'EaglesNest'),
(648, 'India', 69, 'SunsetVines'),
(894, 'USA', 39, 'RoyalVines'),
(677, 'USA', 9, 'PacificCrest');

WITH cte AS (
    SELECT country, winery, SUM(points) AS total_points,
    ROW_NUMBER() OVER (PARTITION BY country ORDER BY SUM(points)  DESC,winery) AS rnk
    FROM Wineries
    GROUP BY country, winery
),
cte2 as(
SELECT *,CONCAT(winery," (",total_points,")" ) as wwp
FROM cte
where rnk <=3
)
SELECT country,MAX(case when rnk =1 then wwp else NULL end) AS top_winery,
  IFNULL(MAX(case when rnk =2 then wwp else NULL end),'No Second winery') AS second_winery,
  IFNULL(MAX(case when rnk =3 then wwp else NULL end),'No Third winery') AS third_winery
FROM cte2
GROUP BY country;


----------------------------------------------------------------------------------------

-- m2 
WITH wineries_points_agg AS (
  SELECT 
        country,
        winery,
        SUM(points) AS total_points
  FROM Wineries
  GROUP BY country,
          winery
),
wineries_ranked AS (
  SELECT 
        country,
        winery,
        total_points,
        ROW_NUMBER() OVER(
          PARTITION BY country 
          ORDER BY 
                total_points DESC,
                winery
        ) AS winery_rank
  FROM wineries_points_agg 
)
SELECT 
    country,
    MAX(CASE WHEN winery_rank = 1 THEN CONCAT(winery,' (',total_points,')') 
        END
      ) AS top_winery,
      COALESCE(
          MAX(CASE WHEN winery_rank = 2 THEN CONCAT(winery,' (',total_points,')') 
        END
          )
       , 'No Second Winery') AS second_winery,
      COALESCE(
        MAX(CASE WHEN winery_rank = 3 THEN CONCAT(winery,' (',total_points,')') 
        END)
       , 'No Third Winery') AS third_winery
FROM wineries_ranked
GROUP BY country
ORDER BY country ;