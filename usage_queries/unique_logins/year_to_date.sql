SELECT
    COUNT(DISTINCT u.email) AS unique_logins_year_to_date
FROM
    activity a
JOIN
    users u ON a."userId" = u.id
WHERE
    a."createdAt" BETWEEN date_trunc('year', now()) AND now()
    AND u.email NOT LIKE '%@ellipsiseducation.com%'
    AND u.email NOT LIKE '%@codelicious.com%'
    AND u.email NOT LIKE '%@example.com%'
    AND u.email NOT LIKE '%@test.com%';
