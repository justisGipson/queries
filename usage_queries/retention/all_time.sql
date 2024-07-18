-- !!! ACTIVITY TABLE !!!
-- Identify the first activity month for each user
-- all time
WITH user_first_activity_month AS (
  SELECT
    a."userId",
    DATE_TRUNC('month', MIN(a."createdAt")) AS first_activity_month
  FROM activity a
  JOIN users u ON a."userId" = u.id
  WHERE
    a."createdAt" BETWEEN (DATE_TRUNC('year', now()) - INTERVAL '1 years') AND now() -- Only consider activity in the last year
    AND u.email NOT LIKE '%@ellipsiseducation.com%'
    AND u.email NOT LIKE '%@codelicious.com%'
    AND u.email NOT LIKE '%@example.com%'
    AND u.email NOT LIKE '%@test.com%'
  GROUP BY a."userId"
),
-- Get the activity month for each user's activity
user_monthly_activities AS (
  SELECT
    a."userId",
    DATE_TRUNC('month', a."createdAt") AS activity_month
  FROM activity a
),
-- Calculate the number of active users for each cohort in each month
monthly_active_users AS (
  SELECT
    ufam.first_activity_month,
    uma.activity_month,
    COUNT(DISTINCT uma."userId") AS active_users
  FROM user_first_activity_month ufam
  JOIN user_monthly_activities uma ON ufam."userId" = uma."userId" AND uma.activity_month >= ufam.first_activity_month
  GROUP BY ufam.first_activity_month, uma.activity_month
),
-- Calculate the total number of users in each cohort
cohort_size AS (
  SELECT
    ufam.first_activity_month,
    COUNT(DISTINCT ufam."userId") AS cohort_users
  FROM user_first_activity_month ufam
  GROUP BY ufam.first_activity_month
)
-- Final query to calculate retention rate
SELECT
  mau.first_activity_month AS cohort_month,
  mau.active_users AS active_users,
  ROUND((mau.active_users * 1.0 / cs.cohort_users) * 100, 2) AS retention_rate -- Calculate retention rate as a percentage
FROM monthly_active_users mau
JOIN cohort_size cs ON mau.first_activity_month = cs.first_activity_month
ORDER BY cohort_month;
