-- !!! ACTIVITY TABLE !!!
-- Identify the first activity month for each user
-- all time
-- month over month retention rate
WITH user_first_activity_month AS (
  SELECT
    a."userId",
    DATE_TRUNC('month', MIN(a."createdAt")) AS first_activity_month
  FROM activity a
  JOIN users u ON a."userId" = u.id
  WHERE
    u.email NOT LIKE '%@ellipsiseducation.com%'
    AND u.email NOT LIKE '%@codelicious.com%'
    AND u.email NOT LIKE '%@example.com%'
    AND u.email NOT LIKE '%@test.com%'
  GROUP BY a."userId"
),
-- Get the activity month and count of active users for each cohort
cohort_monthly_active_users AS (
  SELECT
    ufam.first_activity_month,
    DATE_TRUNC('month', a."createdAt") AS activity_month,
    COUNT(DISTINCT a."userId") AS active_users
  FROM user_first_activity_month ufam
  JOIN activity a ON ufam."userId" = a."userId"
  GROUP BY ufam.first_activity_month, DATE_TRUNC('month', a."createdAt")
),
-- Calculate month-over-month retention rate for each cohort
retention_rates AS (
  SELECT
    cmau.first_activity_month,
    cmau.activity_month,
    cmau.active_users,
    COALESCE(
      ROUND(cmau.active_users * 1.0 / LAG(cmau.active_users) OVER (
        PARTITION BY cmau.first_activity_month
        ORDER BY cmau.activity_month
      ) * 100, 2),
      100
    ) AS retention_rate
  FROM cohort_monthly_active_users cmau
)
-- Final query to retrieve retention rates
SELECT
  rr.first_activity_month AS cohort_month,
  rr.activity_month,
  rr.active_users AS active_users,
  rr.retention_rate AS retention_rate -- || '%' AS retention_rate only works for string concatenation in grafana tables
FROM retention_rates rr
ORDER BY cohort_month, activity_month;
