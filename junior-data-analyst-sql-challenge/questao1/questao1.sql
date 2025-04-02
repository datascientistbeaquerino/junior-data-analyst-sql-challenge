-- Questão 1: Consultas de matrículas e indicadores por escola com médias móveis

SELECT
    s.name AS school_name,
    st.enrolled_at::date AS enrollment_date,
    COUNT(st.id) AS total_students,
    SUM(c.price) AS total_amount
FROM students st
JOIN courses c ON st.course_id = c.id
JOIN schools s ON c.school_id = s.id
GROUP BY s.name, st.enrolled_at::date
ORDER BY enrollment_date DESC;

WITH daily_enrollments AS (
    SELECT
        s.name AS school_name,
        st.enrolled_at::date AS enrollment_date,
        COUNT(st.id) AS total_students
    FROM students st
    JOIN courses c ON st.course_id = c.id
    JOIN schools s ON c.school_id = s.id
    GROUP BY s.name, st.enrolled_at::date
)
SELECT
    school_name,
    enrollment_date,
    total_students,
    AVG(total_students) OVER (
        PARTITION BY school_name
        ORDER BY enrollment_date
        ROWS BETWEEN 6 PRECEDING AND CURRENT ROW
    ) AS moving_avg_7_days,
    AVG(total_students) OVER (
        PARTITION BY school_name
        ORDER BY enrollment_date
        ROWS BETWEEN 29 PRECEDING AND CURRENT ROW
    ) AS moving_avg_30_days
FROM daily_enrollments
ORDER BY school_name, enrollment_date DESC;
