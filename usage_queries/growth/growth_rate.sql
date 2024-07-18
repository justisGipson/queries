-- Calculate monthly user counts from activity table
WITH monthly_users AS (
  SELECT
    DATE_TRUNC('month', a."createdAt") AS month,
    COUNT(DISTINCT u.email) AS total_users
  FROM activity a
  JOIN users u ON a."userId" = u.id
  WHERE
    -- Going back 1 year from the current date, all timeish data
    a."createdAt" BETWEEN (DATE_TRUNC('year', now()) - INTERVAL '1 years') AND now()
    AND u.email NOT LIKE '%@ellipsiseducation.com%'
    AND u.email NOT LIKE '%@codelicious.com%'
    AND u.email NOT LIKE '%@example.com%'
    AND u.email NOT LIKE '%@test.com%'
  GROUP BY month
)
-- Final query to calculate growth rate
SELECT
  month,
  total_users,
  -- Calculate growth rate as a percentage
  to_char(ROUND((total_users - LAG(total_users) OVER (ORDER BY month)) * 1.0 / LAG(total_users) OVER (ORDER BY month) * 100, 2), '999D99%') AS "Growth Rate"
FROM monthly_users;
