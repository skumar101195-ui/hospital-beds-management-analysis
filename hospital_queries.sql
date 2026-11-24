-- Hospital Beds Management: SQL queries from student notebook
-- Run after loading the four CSVs into SQLite tables.
-- The original notebook uses pandas.to_sql() for table creation.

-- Query 01: SQL Query 1: Exploring Hospital Services Data
SELECT *
FROM services_weekly
LIMIT 5;

-- Query 02: SQL Query 2: Counting Hospital Service Records
SELECT COUNT(*) AS total_records
FROM services_weekly;

-- Query 03: SQL Query 3: Department-wise Record Count
SELECT
    service,
    COUNT(*) AS total_records
FROM services_weekly
GROUP BY service
ORDER BY service;

-- Query 04: SQL Query 4: Department-wise Patient Admission Analysis
SELECT
    service,
    SUM(patients_request) AS total_requests,
    SUM(patients_admitted) AS total_admitted,
    SUM(patients_refused) AS total_refused
FROM services_weekly
GROUP BY service
ORDER BY total_refused DESC;

-- Query 05: SQL Query 5: Department-wise Patient Refusal Rate
SELECT
    service,
    SUM(patients_request) AS total_requests,
    SUM(patients_refused) AS total_refused,
    ROUND(
        100.0 * SUM(patients_refused) /
        NULLIF(SUM(patients_request), 0),
        2
    ) AS refusal_rate
FROM services_weekly
GROUP BY service
ORDER BY refusal_rate DESC;

-- Query 06: SQL Query 6: Department-wise Patient Satisfaction
SELECT
    service,
    ROUND(AVG(patient_satisfaction), 2)
        AS average_satisfaction
FROM services_weekly
GROUP BY service
ORDER BY average_satisfaction ASC;

-- Query 07: SQL Query 7: Department-wise Staff Morale
SELECT
    service,
    ROUND(AVG(staff_morale), 2)
        AS average_staff_morale
FROM services_weekly
GROUP BY service
ORDER BY average_staff_morale ASC;

-- Query 08: SQL Query 8: Identifying High Patient Refusal Records
SELECT
    week,
    service,
    patients_request,
    patients_admitted,
    patients_refused
FROM services_weekly
WHERE patients_refused > 50
ORDER BY patients_refused DESC;

-- Query 09: SQL Query 9: Department-wise High Refusal Records
SELECT
    service,
    COUNT(*) AS high_refusal_records
FROM services_weekly
WHERE patients_refused > 50
GROUP BY service
ORDER BY high_refusal_records DESC;

-- Query 10: SQL Query 10: Department-wise Bed Availability
SELECT
    service,
    ROUND(AVG(available_beds), 2) AS average_beds,
    MIN(available_beds) AS minimum_beds,
    MAX(available_beds) AS maximum_beds
FROM services_weekly
GROUP BY service
ORDER BY average_beds DESC;

-- Query 11: SQL Query 11: Patient Demand and Bed Availability
SELECT
    service,
    ROUND(AVG(patients_request), 2)
        AS average_weekly_requests,
    ROUND(AVG(available_beds), 2)
        AS average_available_beds,
    ROUND(
        1.0 * SUM(patients_request) /
        NULLIF(SUM(available_beds), 0),
        2
    ) AS demand_bed_ratio
FROM services_weekly
GROUP BY service
ORDER BY demand_bed_ratio DESC;

-- Query 12: SQL Query 12: Patient Refusals and Staff Availability
SELECT
    s.week,
    s.service,
    s.patients_refused,
    COUNT(*) AS scheduled_staff_records,
    SUM(
        CASE WHEN sch.present = 1
        THEN 1 ELSE 0 END
    ) AS staff_present
FROM services_weekly AS s
INNER JOIN staff_schedule AS sch
    ON s.week = sch.week
    AND s.service = sch.service
GROUP BY
    s.week,
    s.service,
    s.patients_refused
ORDER BY s.patients_refused DESC
LIMIT 10;

