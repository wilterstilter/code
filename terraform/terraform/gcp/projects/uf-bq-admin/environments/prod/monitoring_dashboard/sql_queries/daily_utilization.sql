/*
  * Daily Utilization Report: Returns daily BigQuery usage
  * by reservation, project, job type, and user
  */

SELECT
    TIMESTAMP_TRUNC(jbo.period_start, DAY) AS usage_date,
    jbo.reservation_id,
    jbo.project_id,
    jbo.job_type,
    jbo.user_email,
    -- Aggregate total_slots_ms used for all jobs on this day and divide
    -- by the number of milliseconds in a day. Most accurate for days with
    -- consistent slot usage
    SUM(jbo.period_slot_ms) / (1000 * 60 * 60 * 24) AS average_daily_slot_usage
FROM
    `region-us-south1`.INFORMATION_SCHEMA.JOBS_TIMELINE_BY_ORGANIZATION AS jbo
WHERE (jbo.statement_type != "SCRIPT" OR jbo.statement_type IS NULL)  -- Avoid duplicate byte counting in parent and children jobs.
GROUP BY
    usage_date,
    jbo.project_id,
    jbo.job_type,
    jbo.user_email,
    jbo.reservation_id
ORDER BY
    usage_date ASC
