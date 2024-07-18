SELECT
    COUNT(DISTINCT u.email) AS unique_logins_last_7_days
FROM
    activity a
JOIN
    users u ON a."userId" = u.id
WHERE
    a."createdAt" >= now() - INTERVAL '7 days'
    AND u.email NOT LIKE '%@ellipsiseducation.com%'
    AND u.email NOT LIKE '%@codelicious.com%'
    AND u.email NOT LIKE '%@example.com%'
    AND u.email NOT LIKE '%@test.com%';
