/*
 * Job Comparison Report: Returns information about jobs to compare performance
 * and troubleshoot.
 */
SELECT
    job_id,
    creation_time,
    ROUND(TIMESTAMP_DIFF(start_time, creation_time, MILLISECOND) / 1000, 2) AS creation_duration_s,
    ROUND(TIMESTAMP_DIFF(end_time, start_time, MILLISECOND) / 1000, 2) AS execution_duration_s,
    project_id,
    user_email,
    job_type,
    statement_type,
    total_bytes_processed,
    total_slot_ms,
    total_slot_ms / TIMESTAMP_DIFF(end_time, start_time, MILLISECOND) AS avg_slots,
    cache_hit,
    ARRAY(
        SELECT
            STRUCT(
                snap.elapsed_ms,
                snap.total_slot_ms,
                snap.pending_units,
                snap.completed_units,
                snap.active_units,
                snap.elapsed_ms - COALESCE(LAG(snap.elapsed_ms) OVER (
                    ORDER BY snap.elapsed_ms ASC
                ), 0) AS incremental_elapsed_ms,
                snap.total_slot_ms - COALESCE(LAG(snap.total_slot_ms) OVER (
                    ORDER BY snap.elapsed_ms ASC
                ), 0) AS incremental_slot_ms
            )
        FROM
            UNNEST(timeline) AS snap
    ) AS timeline,
    # Rebuild the job_stages array so we can add additional attributes
    ARRAY(
        SELECT
            STRUCT(
                stage_s.id,
                stage_s.name,
                TIMESTAMP_MILLIS(stage_s.start_ms) AS start_time,
                stage_s.start_ms,
                TIMESTAMP_MILLIS(stage_s.end_ms) AS end_time,
                stage_s.end_ms,
                stage_s.end_ms - stage_s.start_ms AS duration_ms,
                stage_s.slot_ms,
                stage_s.slot_ms / (stage_s.end_ms - stage_s.start_ms) AS avg_slots,
                stage_s.input_stages,
                stage_s.status,
                stage_s.parallel_inputs,
                stage_s.completed_parallel_inputs,
                stage_s.records_read,
                stage_s.records_written,
                stage_s.shuffle_output_bytes,
                stage_s.shuffle_output_bytes_spilled,
                stage_s.wait_ratio_avg,
                stage_s.wait_ms_avg,
                stage_s.wait_ratio_max,
                stage_s.wait_ms_max,
                stage_s.read_ratio_avg,
                stage_s.read_ms_avg,
                stage_s.read_ratio_max,
                stage_s.read_ms_max,
                stage_s.compute_ratio_avg,
                stage_s.compute_ms_avg,
                stage_s.compute_ratio_max,
                stage_s.compute_ms_max,
                stage_s.write_ratio_avg,
                stage_s.write_ms_avg,
                stage_s.write_ratio_max,
                stage_s.write_ms_max,
                ARRAY_TO_STRING(
                    ARRAY(
                        SELECT step.kind
                        FROM
                            UNNEST(stage_s.steps) AS step
                            WITH OFFSET AS step_offset
                        ORDER BY step_offset ASC
                    ),
                    ", "
                ) AS steps
            )
        FROM
            UNNEST(job_stages) AS stage_s
    ) AS job_stages,
    ARRAY(
        SELECT
            STRUCT(
                ROUND(all_timeline_events.event_time / 1000, 2) AS event_time_seconds,
                job_stage_entry.id AS job_stage_id,
                job_stage_entry.name AS job_stage_name
            )
        FROM
            UNNEST(job_stages) AS job_stage_entry
        CROSS JOIN
            (
                (
                    SELECT DISTINCT jse1.start_ms - UNIX_MILLIS(start_time) AS event_time
                    FROM
                        UNNEST(job_stages) AS jse1
                )
                UNION DISTINCT
                (
                    SELECT DISTINCT jse2.end_ms - UNIX_MILLIS(start_time) AS event_time
                    FROM
                        UNNEST(job_stages) AS jse2
                )
                UNION DISTINCT
                (
                    SELECT DISTINCT timeline_entry.elapsed_ms AS event_time
                    FROM
                        UNNEST(timeline) AS timeline_entry
                )
            ) AS all_timeline_events
        WHERE
            all_timeline_events.event_time >= job_stage_entry.start_ms - UNIX_MILLIS(start_time)
            AND all_timeline_events.event_time <= job_stage_entry.end_ms - UNIX_MILLIS(start_time)
            AND job_stage_entry.id <= 19
    ) AS stages_gantt
FROM
    -- PUBLIC DASHBOARD USE ONLY
    -- Modify this to use your project's INFORMATION_SCHEMA table as follows:
    -- `region-{region_name}`.INFORMATION_SCHEMA.{table}
    `region-us-south1`.INFORMATION_SCHEMA.JOBS_BY_ORGANIZATION
-- If making a copy of this query, update `@job_param` for the Job Comparison Report.
-- Depending on if this is for the slow or fast job, use `@job_param` or `job_param_2`.
-- When creating the side-by-side comparison view, you will need to duplicate
-- this data source and update parameter to @job_param_2, or similar.
WHERE job_id = @job_param
