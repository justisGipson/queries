-- !!! ACTIVITY TABLE !!!
-- Identify the first activity month for each user
-- all time
-- exclude the initial month from the retention rate calculation
-- calculate retention rate as a percentage
-- order by activity_month as well
WITH user_first_activity_month AS (
  SELECT
    a."userId",
    DATE_TRUNC('month', MIN(a."createdAt")) AS first_activity_month
  FROM activity a
  JOIN users u ON a."userId" = u.id
  WHERE
    u.email NOT LIKE '%@ellipsiseducation.com%'
    AND EXTRACT(DOW FROM a."createdAt") NOT IN (0, 6) -- exclude weekends
    AND u.email NOT LIKE '%@codelicious.com%'
    AND u.email NOT LIKE '%@example.com%'
    AND u.email NOT LIKE '%@test.com%'
  GROUP BY a."userId"
),
-- Get the activity month for each user's activity
user_weekly_activities AS (
  SELECT
    a."userId",
    DATE_TRUNC('week', a."createdAt") AS activity_week
  FROM activity a
),
-- Calculate the number of active users for each cohort in each month
weekly_active_users AS (
  SELECT
    ufam.first_activity_month AS cohort_month,
    uwa.activity_week,
    COUNT(DISTINCT uwa."userId") AS active_users,
    EXTRACT(WEEK FROM uwa.activity_week) - EXTRACT(WEEK FROM ufam.first_activity_month) + 1 AS week_number
  FROM user_first_activity_month ufam
  JOIN user_weekly_activities uwa ON ufam."userId" = uwa."userId"
    AND uwa.activity_week >= ufam.first_activity_month
    AND uwa.activity_week < DATE_TRUNC('month', ufam.first_activity_month + INTERVAL '1 month')
  GROUP BY ufam.first_activity_month, uwa.activity_week
),
-- Calculate the total number of users in each cohort
cohort_size AS (
  SELECT
    first_activity_month,
    COUNT(DISTINCT "userId") AS cohort_users
  FROM user_first_activity_month
  GROUP BY first_activity_month
)
-- Final query to calculate retention rate
SELECT
  cohort_month,
  to_char(COALESCE(ROUND(SUM(CASE WHEN week_number = 1 THEN active_users END) * 1.0 / MAX(cohort_users) * 100, 2),0), '999D99%') AS "Week 1 Retention",
  to_char(COALESCE(ROUND(SUM(CASE WHEN week_number = 2 THEN active_users END) * 1.0 / MAX(cohort_users) * 100, 2),0), '999D99%') AS "Week 2 Retention",
  to_char(COALESCE(ROUND(SUM(CASE WHEN week_number = 3 THEN active_users END) * 1.0 / MAX(cohort_users) * 100, 2),0), '999D99%') AS "Week 3 Retention",
  to_char(COALESCE(ROUND(SUM(CASE WHEN week_number = 4 THEN active_users END) * 1.0 / MAX(cohort_users) * 100, 2),0), '999D99%') AS "Week 4 Retention",
  to_char(COALESCE(ROUND(SUM(CASE WHEN week_number = 5 THEN active_users END) * 1.0 / MAX(cohort_users) * 100, 2),0), '999D99%') AS "Week 5 Retention"
FROM weekly_active_users
JOIN cohort_size ON cohort_month = first_activity_month
GROUP BY cohort_month
ORDER BY cohort_month;
