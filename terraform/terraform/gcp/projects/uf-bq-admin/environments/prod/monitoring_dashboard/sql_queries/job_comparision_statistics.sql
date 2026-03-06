/*
 * Job Comparison Report: Returns information about jobs to compare performance
 * and troubleshoot.
 */
SELECT
    project_id,
    reservation_id,
    cache_hit,
    job_id,
    start_time,
    job_type,
    priority,
    creation_time,
    end_time,
    error_result.reason AS error_reason,
    SUM(total_bytes_processed) AS sum_bytes_processed,
    SUM(total_slot_ms) AS sum_slot_ms,
    SUM(TIMESTAMP_DIFF(start_time, creation_time, SECOND)) AS creation_sum_sec,
    SUM(TIMESTAMP_DIFF(COALESCE(end_time, CURRENT_TIMESTAMP()), start_time, SECOND)) AS duration_sum_sec,
    SUM((SELECT SUM(stage_s.shuffle_output_bytes_spilled) FROM UNNEST(job_stages) AS stage_s)) AS shuffle_output_bytes_spilled,
    SUM((SELECT SUM(stage_s.shuffle_output_bytes) FROM UNNEST(job_stages) AS stage_s)) AS shuffle_output_bytes
FROM
    `region-us-south1`.INFORMATION_SCHEMA.JOBS_BY_ORGANIZATION
WHERE
    job_id = @job_param
    OR job_id = @job_param_2
GROUP BY
    1, 2, 3, 4, 5, 6, 7, 8, 9, 10
