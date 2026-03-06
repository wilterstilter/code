/*
  * Hourly Utilization Report: Returns hourly BigQuery usage
  * by reservation, project, job type, and user
  */

SELECT
    -- usage_time is used for grouping jobs by the hour
    -- usage_date is used to separately store the date this job occurred
    TIMESTAMP_TRUNC(jbo.period_start, HOUR) AS usage_time,
    EXTRACT(DATE FROM jbo.period_start) AS usage_date,
    jbo.reservation_id,
    jbo.project_id,
    jbo.job_type,
    jbo.user_email,
    -- Aggregate total_slots_ms used for all jobs at this hour and divide
    -- by the number of milliseconds in an hour. Most accurate for hours with
    -- consistent slot usage
    SUM(jbo.period_slot_ms) / (1000 * 60 * 60) AS average_hourly_slot_usage
FROM
    `region-us-south1`.INFORMATION_SCHEMA.JOBS_TIMELINE_BY_ORGANIZATION AS jbo
WHERE (jbo.statement_type != "SCRIPT" OR jbo.statement_type IS NULL)  -- Avoid duplicate byte counting in parent and children jobs.
GROUP BY
    usage_time,
    usage_date,
    jbo.project_id,
    jbo.reservation_id,
    jbo.job_type,
    jbo.user_email
ORDER BY
    usage_time ASC
