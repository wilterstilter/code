/*
 * Job Error Report: Returns information about jobs that resulted in an
 * error
 */

SELECT
    project_id,
    user_email,
    creation_time,
    job_type,
    CASE WHEN statement_type IS NULL THEN 'N/A' ELSE statement_type END AS statement_type,
    error_result
FROM
    `region-us-south1`.INFORMATION_SCHEMA.JOBS_BY_ORGANIZATION
WHERE
    -- Jobs that resulted in an error will have the error_result.reason
    -- field populated
    error_result.reason IS NOT NULL
