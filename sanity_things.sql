--SELECT
--      lessons.*,
--      lesson_grades."gradeLevelId",
--      lesson_standards."standardId",
--      lesson_supplementals."supplementalId",
--      lesson_types.id
--    FROM lessons
--    LEFT JOIN lesson_grades ON lessons.id = lesson_grades."lessonId"
--    LEFT JOIN lesson_standards ON lessons.id = lesson_standards."lessonId"
--    LEFT JOIN lesson_supplementals ON lessons.id = lesson_supplementals."lessonId"
--    LEFT JOIN lesson_types ON lessons."lessonTypeId" = lesson_types.id

--SELECT
--  lessons.id,
--  lessons."lessonTypeId",
--  lessons."courseId",
--  ARRAY_AGG(DISTINCT lesson_grades."gradeLevelId") AS grade_levels,
--  ARRAY_AGG(DISTINCT lesson_standards."standardId") AS standards,
--  ARRAY_AGG(DISTINCT lesson_supplementals."supplementalId") AS supplementals,
--  lesson_types.id AS lesson_type_id
--FROM lessons
--LEFT JOIN lesson_grades ON lessons.id = lesson_grades."lessonId"
--LEFT JOIN lesson_standards ON lessons.id = lesson_standards."lessonId"
--LEFT JOIN lesson_supplementals ON lessons.id = lesson_supplementals."lessonId"
--LEFT JOIN lesson_types ON lessons."lessonTypeId" = lesson_types.id
--GROUP BY
--  lessons.id,
--  lessons."lessonTypeId",
--  lessons."courseId",
--  lesson_types.id;

--SELECT
--  lessons.id AS lesson_id,
--  lessons."lessonTypeId",
--  lessons."courseId",
--  ARRAY_AGG(DISTINCT lesson_grades."gradeLevelId") AS grade_level_ids,
--  ARRAY_AGG(DISTINCT lesson_standards."standardId") AS standard_ids,
--  ARRAY_AGG(DISTINCT lesson_supplementals."supplementalId") AS supplemental_ids,
--  lesson_types.id AS lesson_type_id,
--  ARRAY_AGG(DISTINCT grade_levels.name) AS grade_level_names,
--  ARRAY_AGG(DISTINCT standards."standardIdentifier") AS standard_names,
--  ARRAY_AGG(DISTINCT supplementals.name) AS supplemental_names,
--  lesson_types.name AS lesson_type_name
--FROM lessons
--LEFT JOIN lesson_grades ON lessons.id = lesson_grades."lessonId"
--LEFT JOIN lesson_standards ON lessons.id = lesson_standards."lessonId"
--LEFT JOIN lesson_supplementals ON lessons.id = lesson_supplementals."lessonId"
--LEFT JOIN lesson_types ON lessons."lessonTypeId" = lesson_types.id
--LEFT JOIN grade_levels ON lesson_grades."gradeLevelId" = grade_levels.id
--LEFT JOIN standards ON lesson_standards."standardId" = standards.id
--LEFT JOIN supplementals ON lesson_supplementals."supplementalId" = supplementals.id
--GROUP BY
--  lessons.id,
--  lessons."lessonTypeId",
--  lessons."courseId",
--  lesson_types.id;

--SELECT
--  lessons.id AS lesson_id,
--  lesson_types.name AS lesson_type_name,
--  ARRAY_AGG(DISTINCT grade_levels.name) AS grade_level_names,
--  ARRAY_AGG(DISTINCT standards."standardIdentifier") AS standard_names,
--  ARRAY_AGG(DISTINCT supplementals.name) AS supplemental_names
--FROM lessons
--LEFT JOIN lesson_grades ON lessons.id = lesson_grades."lessonId"
--LEFT JOIN lesson_standards ON lessons.id = lesson_standards."lessonId"
--LEFT JOIN lesson_supplementals ON lessons.id = lesson_supplementals."lessonId"
--LEFT JOIN lesson_types ON lessons."lessonTypeId" = lesson_types.id
--LEFT JOIN grade_levels ON lesson_grades."gradeLevelId" = grade_levels.id
--LEFT JOIN standards ON lesson_standards."standardId" = standards.id
--LEFT JOIN supplementals ON lesson_supplementals."supplementalId" = supplementals.id
--GROUP BY
--  lessons.id,
--  lesson_types.name;

--SELECT
--  lessons.id AS lesson_id,
--  lesson_types.name AS lesson_type_name,
--  ARRAY_AGG(DISTINCT grade_levels.name) AS grade_level_names,
--  ARRAY_AGG(DISTINCT standards."standardIdentifier") AS standard_ids,
--  jsonb_agg(supplementals.details) AS supplementals
--FROM lessons
--LEFT JOIN lesson_grades ON lessons.id = lesson_grades."lessonId"
--LEFT JOIN lesson_standards ON lessons.id = lesson_standards."lessonId"
--LEFT JOIN (
--  SELECT
--    lesson_supplementals."lessonId",
--    jsonb_build_object(
--      'name', supplementals.name,
--      'number', supplementals.number,
--      'link', supplementals.link
--    ) AS details
--  FROM lesson_supplementals
--  JOIN supplementals ON lesson_supplementals."supplementalId" = supplementals.id
--  GROUP BY lesson_supplementals."lessonId", details
--) AS supplementals ON lessons.id = supplementals."lessonId"
--LEFT JOIN lesson_types ON lessons."lessonTypeId" = lesson_types.id
--LEFT JOIN grade_levels ON lesson_grades."gradeLevelId" = grade_levels.id
--LEFT JOIN standards ON lesson_standards."standardId" = standards.id
--GROUP BY
--  lessons.id,
--  lesson_types.name;

--SELECT
--  lessons.id AS lesson_id,
--  lessons.name AS lesson_name,
--  lessons."durationInMinutes" AS lesson_duration,
--  lessons.description AS lesson_description,
--  lessons.link AS lesson_link,
--  lessons.number AS lesson_number,
--  lessons."driveId" AS lesson_driveId,
--  lesson_types.name AS lesson_type_name,
--  ARRAY_AGG(DISTINCT grade_levels.name) AS grade_level_names,
--  ARRAY_AGG(DISTINCT standards."standardIdentifier") AS standard_names,
--  jsonb_agg(
--    jsonb_build_object(
--      'name', supplementals.name,
--      'number', supplementals.number,
--      'link', supplementals.link,
--      'driveId', supplementals."driveId"
--    )
--  ) AS supplementals
--FROM lessons
--LEFT JOIN lesson_grades ON lessons.id = lesson_grades."lessonId"
--LEFT JOIN lesson_standards ON lessons.id = lesson_standards."lessonId"
--LEFT JOIN lesson_supplementals ON lessons.id = lesson_supplementals."lessonId"
--LEFT JOIN supplementals ON lesson_supplementals."supplementalId" = supplementals.id
--LEFT JOIN lesson_types ON lessons."lessonTypeId" = lesson_types.id
--LEFT JOIN grade_levels ON lesson_grades."gradeLevelId" = grade_levels.id
--LEFT JOIN standards ON lesson_standards."standardId" = standards.id
--GROUP BY
--  lessons.id,
--  lessons.name,
--  lessons."durationInMinutes",
--  lessons.description,
--  lessons.link,
--  lessons.number,
--  lessons."driveId",
--  lesson_types.name;

--SELECT
--  lessons.id AS lesson_id,
--  lessons.name AS lesson_name,
--  lessons."durationInMinutes" AS lesson_duration,
--  lessons.description AS lesson_description,
--  lessons.link AS lesson_link,
--  lessons.number AS lesson_number,
--  lessons."driveId" AS lesson_driveId,
--  lesson_types.name AS lesson_type_name,
--  ARRAY_AGG(DISTINCT grade_levels.name) AS grade_level_names,
--  ARRAY_AGG(DISTINCT standards."standardIdentifier") AS standard_names,
--  supplementals.details AS supplementals
--FROM lessons
--LEFT JOIN lesson_grades ON lessons.id = lesson_grades."lessonId"
--LEFT JOIN lesson_standards ON lessons.id = lesson_standards."lessonId"
--LEFT JOIN (
--  SELECT
--    lesson_supplementals."lessonId",
--    jsonb_agg(jsonb_build_object(
--      'name', supplementals.name,
--      'number', supplementals.number,
--      'link', supplementals.link,
--      'driveId', supplementals."driveId"
--    )) AS details
--  FROM lesson_supplementals
--  JOIN supplementals ON lesson_supplementals."supplementalId" = supplementals.id
--  GROUP BY lesson_supplementals."lessonId"
--) AS supplementals ON lessons.id = supplementals."lessonId"
--LEFT JOIN lesson_types ON lessons."lessonTypeId" = lesson_types.id
--LEFT JOIN grade_levels ON lesson_grades."gradeLevelId" = grade_levels.id
--LEFT JOIN standards ON lesson_standards."standardId" = standards.id
--GROUP BY
--  lessons.id,
--  lessons.name,
--  lessons."durationInMinutes",
--  lessons.description,
--  lessons.link,
--  lessons.number,
--  lessons."driveId",
--  lesson_types.name,
--  supplementals.details;

--SELECT
--  lessons.id AS lesson_id,
--  lessons.name AS lesson_name,
--  lessons."durationInMinutes" AS lesson_duration,
--  lessons.description AS lesson_description,
--  lessons.link AS lesson_link,
--  lessons.number AS lesson_number,
--  lessons."driveId" AS lesson_driveId,
--  lesson_types.name AS lesson_type_name,
--  ARRAY_AGG(DISTINCT grade_levels.name) AS grade_level_names,
--  ARRAY_AGG(DISTINCT standards."standardIdentifier") AS standard_names,
--  supplementals.details AS supplementals
--FROM lessons
--LEFT JOIN lesson_grades ON lessons.id = lesson_grades."lessonId"
--LEFT JOIN lesson_standards ON lessons.id = lesson_standards."lessonId"
--LEFT JOIN (
--  SELECT
--    lesson_supplementals."lessonId",
--    jsonb_agg(jsonb_build_object(
--      'name', supplementals.name,
--      'number', supplementals.number,
--      'link', supplementals.link,
--      'driveId', supplementals."driveId",
--      'grade', supplemental_grade_names.grade_names
--    )) AS details
--  FROM lesson_supplementals
--  JOIN supplementals ON lesson_supplementals."supplementalId" = supplementals.id
--  LEFT JOIN (
--    SELECT "supplementalId", ARRAY_AGG(DISTINCT grade_levels.name) AS grade_names
--    FROM supplemental_grades
--    JOIN grade_levels ON supplemental_grades."gradeLevelId" = grade_levels.id
--    GROUP BY "supplementalId"
--  ) AS supplemental_grade_names ON supplementals.id = supplemental_grade_names."supplementalId"
--  GROUP BY lesson_supplementals."lessonId"
--) AS supplementals ON lessons.id = supplementals."lessonId"
--LEFT JOIN lesson_types ON lessons."lessonTypeId" = lesson_types.id
--LEFT JOIN grade_levels ON lesson_grades."gradeLevelId" = grade_levels.id
--LEFT JOIN standards ON lesson_standards."standardId" = standards.id
--GROUP BY
--  lessons.id,
--  lessons.name,
--  lessons."durationInMinutes",
--  lessons.description,
--  lessons.link,
--  lessons.number,
--  lessons."driveId",
--  lesson_types.name,
--  supplementals.details;

SELECT
  lessons.id AS lesson_id,
  lessons.name AS lesson_name,
  lessons."durationInMinutes" AS lesson_duration,
  lessons.description AS lesson_description,
  lessons.link AS lesson_link,
  lessons.number AS lesson_number,
  lessons."driveId" AS lesson_driveId,
  lesson_types.name AS lesson_type_name,
  ARRAY_AGG(DISTINCT grade_levels.name) AS grade_level_names,
  ARRAY_AGG(DISTINCT standards."standardIdentifier") AS standard_names,
  supplementals.details AS supplementals
FROM lessons
LEFT JOIN lesson_grades ON lessons.id = lesson_grades."lessonId"
LEFT JOIN lesson_standards ON lessons.id = lesson_standards."lessonId"
LEFT JOIN (
  SELECT
    lesson_supplementals."lessonId",
    jsonb_agg(jsonb_build_object(
      'name', supplementals.name,
      'number', supplementals.number,
      'link', supplementals.link,
      'driveId', supplementals."driveId",
      'grade', supplemental_grade_names.grade_names,
      'type', supplemental_types.name
    )) AS details
  FROM lesson_supplementals
  JOIN supplementals ON lesson_supplementals."supplementalId" = supplementals.id
  JOIN supplemental_types ON supplementals."supplementalTypeId" = supplemental_types.id
  LEFT JOIN (
    SELECT "supplementalId", ARRAY_AGG(DISTINCT grade_levels.name) AS grade_names
    FROM supplemental_grades
    JOIN grade_levels ON supplemental_grades."gradeLevelId" = grade_levels.id
    GROUP BY "supplementalId"
  ) AS supplemental_grade_names ON supplementals.id = supplemental_grade_names."supplementalId"
  GROUP BY lesson_supplementals."lessonId"
) AS supplementals ON lessons.id = supplementals."lessonId"
LEFT JOIN lesson_types ON lessons."lessonTypeId" = lesson_types.id
LEFT JOIN grade_levels ON lesson_grades."gradeLevelId" = grade_levels.id
LEFT JOIN standards ON lesson_standards."standardId" = standards.id
GROUP BY
  lessons.id,
  lessons.name,
  lessons."durationInMinutes",
  lessons.description,
  lessons.link,
  lessons.number,
  lessons."driveId",
  lesson_types.name,
  supplementals.details;
