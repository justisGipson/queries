-- !!! ACTIVITY TABLE !!!
-- Calculate monthly active users
WITH monthly_active_users AS (
  SELECT
    DATE_TRUNC('month', a."createdAt") AS month,
    COUNT(DISTINCT u.email) AS active_users
  FROM activity a
  JOIN users u ON a."userId" = u.id
  -- Going back 1 year from the current date, all timeish data
  WHERE a."createdAt" BETWEEN (DATE_TRUNC('year', now()) - INTERVAL '1 years') AND now()
    AND u.email NOT LIKE '%@ellipsiseducation.com%'
    AND u.email NOT LIKE '%@codelicious.com%'
    AND u.email NOT LIKE '%@example.com%'
    AND u.email NOT LIKE '%@test.com%'
  GROUP BY month
),
-- Find the last activity month for each user
user_last_activity AS (
  SELECT
    a."userId",
    MAX(DATE_TRUNC('month', a."createdAt")) AS last_activity_month
  FROM activity a
  GROUP BY a."userId"
),
-- Calculate churned users for each month
churned_users AS (
  SELECT
    mau.month,
    COUNT(DISTINCT u.email) AS churned_users
  FROM monthly_active_users mau
  -- Left join with user_last_activity to identify churned users
  LEFT JOIN user_last_activity ula ON ula.last_activity_month < mau.month - INTERVAL '3 months'
  LEFT JOIN users u ON ula."userId" = u.id
  GROUP BY mau.month
)
-- Final query to calculate churn rate
SELECT
  mau.month,
  mau.active_users,
  COALESCE(cu.churned_users, 0) AS churned_users,
  -- churn_rate could exceed 100% if churned_users is > active_users
  ROUND(COALESCE(cu.churned_users * 1.0 / mau.active_users, 0) * 100, 2) || '%' AS churn_rate
FROM monthly_active_users mau
-- Left join with churned_users to get the number of churned users for each month
LEFT JOIN churned_users cu ON mau.month = cu.month;
