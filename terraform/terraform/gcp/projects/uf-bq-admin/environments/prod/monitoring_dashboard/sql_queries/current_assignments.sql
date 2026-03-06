-- This table retrieves the latest slot capacity for each reservation
WITH
latest_slot_capacity AS (
    SELECT
        rcp.reservation_name,
        rcp.slot_capacity
    FROM
        `region-us-south1`.INFORMATION_SCHEMA.RESERVATION_CHANGES_BY_PROJECT AS rcp
    WHERE
        -- This subquery returns the latest slot capacity for each reservation
        -- by extracting the reservation with the maximum timestamp
        (rcp.reservation_name, rcp.change_timestamp) IN (
            SELECT AS STRUCT
                reservation_name,
                MAX(change_timestamp) AS change_timestamp
            FROM
                `region-us-south1`.INFORMATION_SCHEMA.RESERVATION_CHANGES_BY_PROJECT
            GROUP BY reservation_name
        )
)

-- Extract information about current assignments
SELECT
    acp.assignment_id,
    acp.project_id,
    acp.reservation_name,
    acp.job_type,
    acp.assignee_id,
    acp.assignee_type,
    lsc.slot_capacity
FROM
    `region-us-south1`.INFORMATION_SCHEMA.ASSIGNMENT_CHANGES_BY_PROJECT AS acp
-- Join to obtain the current slot capacities
LEFT JOIN latest_slot_capacity AS lsc
    ON lsc.reservation_name = acp.reservation_name
GROUP BY
    acp.assignment_id,
    acp.project_id,
    acp.reservation_name,
    acp.job_type,
    acp.assignee_id,
    acp.assignee_type,
    lsc.slot_capacity
-- In order to return only active assignments (i.e. ones that have not been
-- deleted) we select only assignments that have one entry in this table.
-- Assignments that have been deleted have two entries in this table,
-- one where the action is CREATE and one where the action is DELETE.
HAVING COUNT(assignment_id) = 1
