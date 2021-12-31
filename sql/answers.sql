-- average complete time of a course
SELECT 
c2.title,
round(avg(extract(epoch from c."completedDate"  - c."startDate" )/3600/24)) avg_course_complete_days
FROM certificates c 
JOIN courses c2 ON c.course = c2.id
GROUP BY c2.title
ORDER BY avg_course_complete_days DESC 
;

-- average amount of users time spent in a course
SELECT
round(avg(extract(epoch from c."completedDate"  - c."startDate" )/3600/24)) course_duration_days
FROM certificates c
;

-- average amount of users time spent for each course individually
SELECT 
c2.title,
round(avg(extract(epoch from c."completedDate"  - c."startDate" )/3600/24)) avg_course_complete_days
FROM certificates c 
JOIN courses c2 ON c.course = c2.id
GROUP BY c2.title
ORDER BY avg_course_complete_days DESC 
;

-- report of fastest vs. slowest users completing a course
WITH slow_fast AS (
	SELECT 
	c.course,
	c."user",
	c."completedDate"  - c."startDate" user_time_spend,
	ROW_NUMBER() over(PARTITION BY c.course ORDER BY c."completedDate"  - c."startDate" desc) rn_slow,
	ROW_NUMBER() over(PARTITION BY c.course ORDER BY c."completedDate"  - c."startDate") rn_fast
	FROM certificates c
	)
SELECT
c.title course_title,
CASE WHEN rn_slow = 1 AND rn_fast =1 THEN 'Only one user'
	 WHEN rn_slow = 1 THEN 'Slowest user'
	 WHEN rn_fast = 1 THEN 'Fastest user'
	 ELSE 'error'
END user_status,
concat(u."firstName",' ', u."lastName") AS user_name,
sf.user_time_spend
FROM slow_fast sf
JOIN users u ON sf."user" = u.id 
JOIN courses c ON sf.course = c.id 
WHERE rn_slow = 1 OR rn_fast = 1
ORDER BY c.title, user_status
;

-- amount of certificates per customer
WITH user_cert AS (
	SELECT 
	c."user",
	count(course) count_certificates,
	count(DISTINCT course) count_dist_certificates
	FROM certificates c 
	GROUP BY c."user" )
SELECT 
avg(uc.count_certificates) avg_certificates_per_user,
avg(uc.count_dist_certificates) avg_dist_certificates_per_user
FROM user_cert uc
;