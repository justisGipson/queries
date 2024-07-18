-- Count unique logins from the "activity" table within a specific date range, excluding certain email domains
--
SELECT
    d.name AS district_name,
    s.name AS school_name,
    COUNT(DISTINCT u.email) AS unique_logins_year_to_date
FROM
    activity a
JOIN
    users u ON a."userId" = u.id
LEFT JOIN
    user_districts ud ON u.id = ud."userId"
LEFT JOIN
    districts d ON ud."districtId" = d.id
LEFT JOIN
    user_schools us ON u.id = us."userId"
LEFT JOIN
    schools s ON us."schoolId" = s.id
WHERE
    a."createdAt" BETWEEN date_trunc('year', now()) AND now()
    AND u.email NOT LIKE '%@ellipsiseducation.com%'
    AND u.email NOT LIKE '%@codelicious.com%'
    AND u.email NOT LIKE '%@example.com%'
    AND u.email NOT LIKE '%@test.com%'
GROUP BY
    d.name, s.name;
