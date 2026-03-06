/*
 * Job Execution Report: Returns job-level statistics including average
 * slot utilization
 */

SELECT
    project_id,
    job_id,
    reservation_id,
    EXTRACT(DATE FROM creation_time) AS creation_date,
    creation_time,
    end_time,
    TIMESTAMP_DIFF(COALESCE(end_time, CURRENT_TIMESTAMP()), start_time, SECOND) AS job_duration_seconds,
    job_type,
    user_email,
    state,
    error_result,
    total_bytes_processed,
    -- Average slot utilization per job is calculated by dividing
    -- total_slot_ms by the millisecond duration of the job
    SAFE_DIVIDE(total_slot_ms, (TIMESTAMP_DIFF(end_time, start_time, MILLISECOND))) AS avg_slots
FROM
    `region-us-south1`.INFORMATION_SCHEMA.JOBS_BY_ORGANIZATION
ORDER BY
    creation_time DESC
