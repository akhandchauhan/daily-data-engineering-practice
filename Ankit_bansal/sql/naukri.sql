-- Funnel Flow:
-- Visit Portal (Website, e.g., myperfectresume.com)
--   -> Register on Portal (Website, e.g., myperfectresume.com)
--       -> Create a Resume
--           -> Purchase subscription to download resume
--               -> Can create/edit more resumes



DROP TABLE IF EXISTS portal;

CREATE TABLE portal (
    portal_id INT PRIMARY KEY,
    portal_code VARCHAR(10),
    portal_name VARCHAR(50)
);

INSERT INTO portal (portal_id, portal_code, portal_name) VALUES
(1, 'MPR',  'My Perfect Resume'),
(2, 'RN',   'Resume Now'),
(3, 'ZETY', 'Zety'),
(4, 'LC',   'Live Career'),
(5, 'GEN',  'Resume Genius'),
(6, 'HELP', 'Resume Help');


DROP TABLE IF EXISTS user_registration;

CREATE TABLE user_registration (
    user_id BIGINT,
    portal_id INT,
    registration_datetime DATETIME,
    subscription_flag CHAR(1),
    subscription_datetime DATETIME NULL
);

INSERT INTO user_registration VALUES
(1001, 2, '2024-01-05 09:27:44', 'Y', '2024-01-06 10:00:00'),
(1002, 3, '2024-02-15 14:07:11', 'Y', '2024-02-15 15:30:00'),
(1003, 2, '2024-03-10 08:00:00', 'N', NULL),
(1004, 4, '2024-05-19 09:45:00', 'Y', '2024-05-20 10:00:00'),
(1005, 3, '2024-12-10 12:00:00', 'Y', '2024-12-15 12:00:00'),
(1006, 1, '2024-07-01 11:00:00', 'Y', '2024-07-02 09:00:00'),
(1007, 2, '2024-12-31 23:59:59', 'Y', '2025-01-01 00:15:00'),
(1008, 4, '2024-03-15 23:59:59', 'N', NULL),
(1009, 2, '2025-01-15 23:59:59', 'Y', '2025-02-01 00:15:00'),
(1010, 3, '2024-02-10 14:00:00', 'N', NULL),
(1011, 5, '2024-03-01 00:00:00', 'Y', '2024-03-02 09:00:00'),
(1012, 1, '2024-04-01 09:30:00', 'N', NULL),
(1013, 2, '2024-07-05 14:00:00', 'N', NULL),
(1014, 5, '2024-08-10 18:00:00', 'Y', '2024-08-11 08:00:00'),
(1015, 2, '2024-01-20 23:59:59', 'Y', '2025-01-01 00:15:00');

DROP TABLE IF EXISTS resume_doc;

CREATE TABLE resume_doc (
    resume_id INT PRIMARY KEY,
    user_id BIGINT,
    date_created DATETIME,
    experience_years INT
);

INSERT INTO resume_doc VALUES
(2001, 1001, '2024-01-07 11:00:00', 2),
(2002, 1001, '2024-02-12 12:00:00', 3),
(2003, 1002, '2024-02-16 10:00:00', 5),
(2004, 1002, '2024-03-05 12:00:00', 7),
(2005, 1004, '2024-05-21 11:00:00', 12),
(2006, 1005, '2024-06-15 09:00:00', 0),
(2007, 1005, '2024-06-20 10:00:00', 1),
(2008, 1006, '2024-07-01 15:00:00', 8),
(2009, 1006, '2024-08-12 19:00:00', 9),
(2010, 1007, '2025-01-02 10:00:00', 20),
(2011, 1001, '2025-01-07 11:00:00', 3),
(2012, 1001, '2025-01-08 11:00:00', 3);


-- q1 = count of registration every month on resume now portal for 2024

SELECT 
    MONTHNAME(ur.registration_datetime) as mth,
    COUNT(DISTINCT ur.user_id) as registrations
FROM portal p 
JOIN user_registration ur   
ON p.portal_id = ur.portal_id
WHERE p.portal_id = 2 
and p.portal_name ='Resume Now'
AND YEAR(registration_datetime) = 2024
GROUP BY 1

---------------------------------------------------------------------------------------------

-- Question 2:
-- Which portal has the highest subscription rate for users registered in the last 30 days?
-- Subscription rate = Total Subscriptions / Total Registrations

select p.portal_name,
       COUNT(ur.subscription_datetime)/IFNULL(COUNT(ur.registration_datetime),0) AS subscription_rate
FROM portal p 
JOIN user_registration ur   
ON p.portal_id = ur.portal_id
WHERE DATEDIFF(CURRENT_DATE, ur.registration_datetime) <= 30
GROUP BY 1
ORDER BY 2 DESC 
LIMIT 1


-- q3
-- how many registered users created less than 3 resumes


SELECT COUNT(*) AS user_cnt 
FROM (
    SELECT ur.user_id,IFNULL(COUNT(r.resume_id),0) as resume_cnt
    FROM user_registration ur   
    LEFT JOIN resume_doc r   
    ON ur.user_id = r.user_id
    GROUP BY 1
    HAVING COUNT(r.resume_id) < 3
) A

-------------------------------------------------------------------------------------------------------------------
-- q4
-- Create a list of users who subscribed in 2024 on the 'Zety' portal and get
-- the experience_years on their first resume

SELECT user_id, experience_years
FROM (
    SELECT ur.user_id,rd.resume_id,rd.experience_years,
    ROW_NUMBER() OVER(PARTITION BY ur.user_id ORDER BY rd.date_created) as rnk
    FROM portal p 
    LEFT JOIN user_registration ur  
    ON p.portal_id = ur.portal_id  
    LEFT JOIN resume_doc rd    
    ON ur.user_id = rd.user_id 
    WHERE YEAR(ur.subscription_datetime) = 2024
    AND p.portal_name ='Zety'
)  a  
WHERE rnk = 1 and experience_years > 0