WITH active_users AS (
    -- Calculate total activity days for each user
    SELECT
        a."userId",
        COUNT(DISTINCT DATE(a."createdAt")) AS total_activity_days
    FROM activity a
    -- filter data within specified date range
    WHERE
        -- filter data within the last 3 months
        a."createdAt" >= now() - INTERVAL '24 hours'
        AND EXTRACT(DOW FROM a."createdAt") NOT IN (0, 6)
        AND a."userId" NOT IN (
            SELECT u.id
            FROM users u
            WHERE
                u.email LIKE '%@ellipsiseducation.com%'
                OR u.email LIKE '%@codelicious.com%'
                OR u.email LIKE '%@example.com%'
                OR u.email LIKE '%@test.com%'
        )
    -- group the results by userId for total activity days/user
    GROUP BY a."userId"
),
total_days AS (
    -- calculate the total number of days within the date range
    SELECT
        COUNT(DISTINCT DATE(a."createdAt")) AS total_days
    FROM activity a
    -- filter data within the specified date range
    WHERE
        a."createdAt" >= now() - INTERVAL '24 hours'
        AND EXTRACT(DOW FROM a."createdAt") NOT IN (0, 6)
        AND a."userId" NOT IN (
            SELECT u.id
            FROM users u
            WHERE
                u.email LIKE '%@ellipsiseducation.com%'
                OR u.email LIKE '%@codelicious.com%'
                OR u.email LIKE '%@example.com%'
                OR u.email LIKE '%@test.com%'
        )
),
user_info AS (
    SELECT
        au."userId" AS user_id,
        s.name AS school_name,
        d.name AS district_name,
        au.total_activity_days
    FROM active_users au
    JOIN users u ON au."userId" = u.id
    LEFT JOIN user_schools us ON au."userId" = us."userId"
    LEFT JOIN schools s ON us."schoolId" = s.id
    LEFT JOIN user_districts ud ON au."userId" = ud."userId"
    LEFT JOIN districts d ON ud."districtId" = d.id
)
SELECT
    ui.district_name,
    ui.school_name,
    to_char(ROUND(AVG(ui.total_activity_days * 1.0 / (SELECT total_days FROM total_days) * 100), 2), '999D99%') AS "Last 24 Hours"
FROM user_info ui
GROUP BY ui.district_name, ui.school_name;
