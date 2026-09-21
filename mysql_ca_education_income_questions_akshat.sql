/*
======================================================================
MYSQL DATA ANALYTICS PROJECT — QUESTIONS ONLY
California Educational Attainment & Personal Income (2008-2014)
======================================================================*/

/*
======================================================================
Table: ca_education_income

Columns:
`Year`, `Age`, `Gender`, `Educational Attainment`,
`Personal Income`, `Population Count`

MySQL 8.0+
Focus: JOINs / SELF JOINs, Window Functions, CTEs, Subqueries
Measure: Population Count
======================================================================

/*

/*
======================================================================
Q1. Compare 2008 and 2014 population for every combination of Age,
Gender, Educational Attainment and Personal Income. Show population
in both years and the change.
======================================================================*/

select a.Age, a.Gender, a.`Educational Attainment`, a.`Personal Income`,
       a.`Population Count` as population_2008,
       b.`Population Count` as population_2014,
       b.`Population Count` - a.`Population Count` as population_change
from edu_inc a join edu_inc b
    on a.Age = b.Age
    and a.Gender = b.Gender
    and a.`Educational Attainment` = b.`Educational Attainment`
    and a.`Personal Income` = b.`Personal Income`
where a.Year = '01-01-2008'
    and b.Year = '01-01-2014';


/*
======================================================================
Q2. Find demographic segments whose population increased by more than
10,000 people between 2008 and 2014. Use a SELF JOIN.
======================================================================
*/

select a.Age, a.Gender, a.`Educational Attainment`, a.`Personal Income`,
       a.`Population Count` as population_2008,
       b.`Population Count` as population_2014,
       b.`Population Count` - a.`Population Count` as population_change
from edu_inc a join edu_inc b
    on a.Age = b.Age
    and a.Gender = b.Gender
    and a.`Educational Attainment` = b.`Educational Attainment`
    and a.`Personal Income` = b.`Personal Income`
where a.Year = '01-01-2008'
    and b.Year = '01-01-2014'
    and b.`Population Count` - a.`Population Count` > 10000;




/*
======================================================================
Q3. Compare the population for each Gender + Educational Attainment
combination between 2008 and 2014, aggregating across Age and
Personal Income.
======================================================================*/
SELECT
    a.Gender,
    a.`Educational Attainment`,
    SUM(a.`Population Count`) AS population_2008,
    SUM(b.`Population Count`) AS population_2014,
    SUM(b.`Population Count`) - SUM(a.`Population Count`) AS population_change
FROM edu_inc a
JOIN edu_inc b
    ON a.Gender = b.Gender
    AND a.`Educational Attainment` = b.`Educational Attainment`
    AND a.Age = b.Age
    AND a.`Personal Income` = b.`Personal Income`
WHERE a.Year = '01-01-2008'
    AND b.Year = '01-01-2014'
GROUP BY a.Gender, a.`Educational Attainment`;


/*
======================================================================
Q4. Compare Male and Female population for each Educational Attainment
and Personal Income combination in 2014. Show the gender difference.
======================================================================*/
SELECT
    a.`Educational Attainment`,
    a.`Personal Income`,
    a.`Population Count` AS male_population,
    b.`Population Count` AS female_population,
    a.`Population Count` - b.`Population Count` AS gender_difference
FROM edu_inc a
JOIN edu_inc b
    ON a.Age = b.Age
    AND a.`Educational Attainment` = b.`Educational Attainment`
    AND a.`Personal Income` = b.`Personal Income`
WHERE a.Year = '01-01-2014'
    AND b.Year = '01-01-2014'
    AND a.Gender = 'Male'
    AND b.Gender = 'Female';


/*
======================================================================
Q5. Compare 2013 and 2014 population for every Age + Gender segment,
aggregating across Education and Income. Find segments that declined.
======================================================================*/
SELECT
    a.Age,
    a.Gender,
    SUM(a.`Population Count`) AS population_2013,
    SUM(b.`Population Count`) AS population_2014,
    SUM(b.`Population Count`) - SUM(a.`Population Count`) AS population_change
FROM edu_inc a
JOIN edu_inc b
    ON a.Age = b.Age
    AND a.Gender = b.Gender
    AND a.`Educational Attainment` = b.`Educational Attainment`
    AND a.`Personal Income` = b.`Personal Income`
WHERE a.Year = '01-01-2013'
    AND b.Year = '01-01-2014'
GROUP BY a.Age, a.Gender
HAVING SUM(b.`Population Count`) - SUM(a.`Population Count`) < 0;


/*
======================================================================
Q6. For each Personal Income band, compare total population in 2008
versus 2014, aggregating across Age, Gender and Education.
======================================================================*/
SELECT
    a.`Personal Income`,
    SUM(a.`Population Count`) AS population_2008,
    SUM(b.`Population Count`) AS population_2014,
    SUM(b.`Population Count`) - SUM(a.`Population Count`) AS population_change
FROM edu_inc a
JOIN edu_inc b
    ON a.`Personal Income` = b.`Personal Income`
    AND a.Age = b.Age
    AND a.Gender = b.Gender
    AND a.`Educational Attainment` = b.`Educational Attainment`
WHERE a.Year = '01-01-2008'
    AND b.Year = '01-01-2014'
GROUP BY a.`Personal Income`;


/*
======================================================================
Q7. Rank Educational Attainment categories by total population within
each year using RANK().
======================================================================*/
SELECT
    Year,
    `Educational Attainment`,
    SUM(`Population Count`) AS total_population,
    RANK() OVER(
        PARTITION BY Year
        ORDER BY SUM(`Population Count`) DESC
    ) AS population_rank
FROM edu_inc
GROUP BY Year, `Educational Attainment`;


/*
======================================================================
Q8. Rank Personal Income bands by population within each year using
DENSE_RANK().
======================================================================*/
SELECT
    Year,
    `Personal Income`,
    SUM(`Population Count`) AS total_population,
    DENSE_RANK() OVER(
        PARTITION BY Year
        ORDER BY SUM(`Population Count`) DESC
    ) AS population_rank
FROM edu_inc
GROUP BY Year, `Personal Income`;


/*
======================================================================
Q9. Find the top 3 Educational Attainment categories by population for
every year using ROW_NUMBER().
======================================================================*/
SELECT
    Year,
    `Educational Attainment`,
    total_population
FROM (
    SELECT
        Year,
        `Educational Attainment`,
        SUM(`Population Count`) AS total_population,
        ROW_NUMBER() OVER(
            PARTITION BY Year
            ORDER BY SUM(`Population Count`) DESC
        ) AS rn
    FROM edu_inc
    GROUP BY Year, `Educational Attainment`
) a
WHERE rn <= 3;


/*
======================================================================
Q10. Calculate previous-year population for every Gender +
Educational Attainment combination using LAG(), and calculate the
population change.
======================================================================*/
SELECT
    Year,
    Gender,
    `Educational Attainment`,
    total_population,
    LAG(total_population) OVER(
        PARTITION BY Gender, `Educational Attainment`
        ORDER BY Year
    ) AS previous_population,
    total_population - LAG(total_population) OVER(
        PARTITION BY Gender, `Educational Attainment`
        ORDER BY Year
    ) AS population_change
FROM (
    SELECT
        Year,
        Gender,
        `Educational Attainment`,
        SUM(`Population Count`) AS total_population
    FROM edu_inc
    GROUP BY Year, Gender, `Educational Attainment`
) a;


/*
======================================================================
Q11. Calculate year-over-year population growth percentage for every
Age + Gender combination using LAG().
======================================================================*/
SELECT
    Year,
    Age,
    Gender,
    total_population,
    LAG(total_population) OVER(
        PARTITION BY Age, Gender
        ORDER BY Year
    ) AS previous_population,
    ROUND(
        (
            total_population -
            LAG(total_population) OVER(
                PARTITION BY Age, Gender
                ORDER BY Year
            )
        )
        /
        LAG(total_population) OVER(
            PARTITION BY Age, Gender
            ORDER BY Year
        ) * 100,
        2
    ) AS growth_percentage
FROM (
    SELECT
        Year,
        Age,
        Gender,
        SUM(`Population Count`) AS total_population
    FROM edu_inc
    GROUP BY Year, Age, Gender
) a;


/*
======================================================================
Q12. Calculate cumulative population for each Educational Attainment
category from 2008 through 2014.
======================================================================*/
SELECT
    Year,
    `Educational Attainment`,
    SUM(total_population) OVER(
        PARTITION BY `Educational Attainment`
        ORDER BY Year
    ) AS cumulative_population
FROM (
    SELECT
        Year,
        `Educational Attainment`,
        SUM(`Population Count`) AS total_population
    FROM edu_inc
    GROUP BY Year, `Educational Attainment`
) a;


/*
======================================================================
Q13. Calculate each Personal Income band's percentage share of total
population within each year.
======================================================================*/
SELECT
    Year,
    `Personal Income`,
    SUM(`Population Count`) AS total_population,
    ROUND(
        SUM(`Population Count`)
        /
        SUM(SUM(`Population Count`)) OVER(PARTITION BY Year) * 100,
        2
    ) AS population_share
FROM edu_inc
GROUP BY Year, `Personal Income`;


/*
======================================================================
Q14. For every year, identify the most populated Gender + Age segment
using ROW_NUMBER().
======================================================================*/
SELECT
    Year,
    Gender,
    Age,
    total_population
FROM (
    SELECT
        Year,
        Gender,
        Age,
        SUM(`Population Count`) AS total_population,
        ROW_NUMBER() OVER(
            PARTITION BY Year
            ORDER BY SUM(`Population Count`) DESC
        ) AS rn
    FROM edu_inc
    GROUP BY Year, Gender, Age
) a
WHERE rn = 1;


/*
======================================================================
Q15. Find the year in which each Educational Attainment category had
its highest population.
======================================================================*/
SELECT
    `Educational Attainment`,
    Year,
    total_population
FROM (
    SELECT
        `Educational Attainment`,
        Year,
        SUM(`Population Count`) AS total_population,
        ROW_NUMBER() OVER(
            PARTITION BY `Educational Attainment`
            ORDER BY SUM(`Population Count`) DESC
        ) AS rn
    FROM edu_inc
    GROUP BY `Educational Attainment`, Year
) a
WHERE rn = 1;


/*
======================================================================
Q16. Compare each year's total population with the previous year using
LAG(), and identify the largest annual increase.
======================================================================*/
SELECT
    Year,
    total_population,
    LAG(total_population) OVER(
        ORDER BY Year
    ) AS previous_population,
    total_population -
    LAG(total_population) OVER(
        ORDER BY Year
    ) AS population_change
FROM (
    SELECT
        Year,
        SUM(`Population Count`) AS total_population
    FROM edu_inc
    GROUP BY Year
) a
ORDER BY population_change DESC
LIMIT 1;


/*
======================================================================
Q17. Using CTEs, calculate total population by year and classify each
year as High Population or Low Population based on the overall average.
======================================================================*/
WITH yearly_population AS (
    SELECT
        Year,
        SUM(`Population Count`) AS total_population
    FROM edu_inc
    GROUP BY Year
),
average_population AS (
    SELECT
        AVG(total_population) AS avg_population
    FROM yearly_population
)
SELECT
    y.Year,
    y.total_population,
    CASE
        WHEN y.total_population > a.avg_population
            THEN 'High Population'
        ELSE 'Low Population'
    END AS population_category
FROM yearly_population y
CROSS JOIN average_population a;


/*
======================================================================
Q18. Using CTEs, calculate Educational Attainment population in 2008
and 2014 and return the top 5 categories by absolute change.
======================================================================*/
WITH education_population AS (
    SELECT
        `Educational Attainment`,
        SUM(
            CASE
                WHEN Year = '01-01-2008'
                    THEN `Population Count`
                ELSE 0
            END
        ) AS population_2008,
        SUM(
            CASE
                WHEN Year = '01-01-2014'
                    THEN `Population Count`
                ELSE 0
            END
        ) AS population_2014
    FROM edu_inc
    GROUP BY `Educational Attainment`
)
SELECT
    `Educational Attainment`,
    population_2008,
    population_2014,
    population_2014 - population_2008 AS population_change,
    ABS(population_2014 - population_2008) AS absolute_change
FROM education_population
ORDER BY absolute_change DESC
LIMIT 5;


/*
======================================================================
Q19. Using CTEs, calculate population by Gender and Year and find
which gender had the larger population in each year.
======================================================================*/
WITH gender_population AS (
    SELECT
        Year,
        Gender,
        SUM(`Population Count`) AS total_population
    FROM edu_inc
    GROUP BY Year, Gender
)
SELECT
    Year,
    Gender,
    total_population
FROM (
    SELECT
        Year,
        Gender,
        total_population,
        ROW_NUMBER() OVER(
            PARTITION BY Year
            ORDER BY total_population DESC
        ) AS rn
    FROM gender_population
) a
WHERE rn = 1;


/*
======================================================================
Q20. Using CTEs, calculate average annual population for each Age
group and identify the Age group with the highest average.
======================================================================*/
WITH age_population AS (
    SELECT
        Age,
        Year,
        SUM(`Population Count`) AS total_population
    FROM edu_inc
    GROUP BY Age, Year
)
SELECT
    Age,
    AVG(total_population) AS average_population
FROM age_population
GROUP BY Age
ORDER BY average_population DESC
LIMIT 1;


/*
======================================================================
Q21. Using CTEs, identify Educational Attainment categories whose
population increased in at least 4 of the 6 year-to-year transitions.
======================================================================*/
WITH education_population AS (
    SELECT
        `Educational Attainment`,
        Year,
        SUM(`Population Count`) AS total_population
    FROM edu_inc
    GROUP BY `Educational Attainment`, Year
),
changes AS (
    SELECT
        `Educational Attainment`,
        Year,
        total_population,
        LAG(total_population) OVER(
            PARTITION BY `Educational Attainment`
            ORDER BY Year
        ) AS previous_population
    FROM education_population
)
SELECT
    `Educational Attainment`
FROM changes
GROUP BY `Educational Attainment`
HAVING SUM(
    CASE
        WHEN total_population > previous_population THEN 1
        ELSE 0
    END
) >= 4;


/*
======================================================================
Q22. Using CTEs, calculate the average yearly population share of each
Personal Income band and find bands whose average share exceeds 10%.
======================================================================*/
WITH income_share AS (
    SELECT
        Year,
        `Personal Income`,
        SUM(`Population Count`)
        /
        SUM(SUM(`Population Count`)) OVER(PARTITION BY Year) * 100
        AS population_share
    FROM edu_inc
    GROUP BY Year, `Personal Income`
)
SELECT
    `Personal Income`,
    AVG(population_share) AS average_share
FROM income_share
GROUP BY `Personal Income`
HAVING AVG(population_share) > 10;


/*
======================================================================
Q23. Find Educational Attainment categories whose 2014 population was
greater than the average 2014 population across all education
categories. Use a subquery.
======================================================================*/
SELECT
    `Educational Attainment`,
    SUM(`Population Count`) AS total_population
FROM edu_inc
WHERE Year = '01-01-2014'
GROUP BY `Educational Attainment`
HAVING SUM(`Population Count`) > (
    SELECT AVG(total_population)
    FROM (
        SELECT
            SUM(`Population Count`) AS total_population
        FROM edu_inc
        WHERE Year = '01-01-2014'
        GROUP BY `Educational Attainment`
    ) a
);


/*
======================================================================
Q24. Find Personal Income bands whose 2014 population was greater than
the average income-band population in 2014. Use a subquery.
======================================================================*/
SELECT
    `Personal Income`,
    SUM(`Population Count`) AS total_population
FROM edu_inc
WHERE Year = '01-01-2014'
GROUP BY `Personal Income`
HAVING SUM(`Population Count`) > (
    SELECT AVG(total_population)
    FROM (
        SELECT
            SUM(`Population Count`) AS total_population
        FROM edu_inc
        WHERE Year = '01-01-2014'
        GROUP BY `Personal Income`
    ) a
);


/*
======================================================================
Q25. Find the most populated Age + Gender combination in 2014 using
a subquery.
======================================================================*/
SELECT
    Age,
    Gender,
    SUM(`Population Count`) AS total_population
FROM edu_inc
WHERE Year = '01-01-2014'
GROUP BY Age, Gender
HAVING SUM(`Population Count`) = (
    SELECT MAX(total_population)
    FROM (
        SELECT
            SUM(`Population Count`) AS total_population
        FROM edu_inc
        WHERE Year = '01-01-2014'
        GROUP BY Age, Gender
    ) a
);


/*
======================================================================
Q26. Find the second-highest Educational Attainment category by
population in 2014 using subqueries.
======================================================================*/
SELECT
    `Educational Attainment`,
    SUM(`Population Count`) AS total_population
FROM edu_inc
WHERE Year = '01-01-2014'
GROUP BY `Educational Attainment`
HAVING SUM(`Population Count`) = (
    SELECT MAX(total_population)
    FROM (
        SELECT
            SUM(`Population Count`) AS total_population
        FROM edu_inc
        WHERE Year = '01-01-2014'
        GROUP BY `Educational Attainment`
    ) a
    WHERE total_population < (
        SELECT MAX(total_population)
        FROM (
            SELECT
                SUM(`Population Count`) AS total_population
            FROM edu_inc
            WHERE Year = '01-01-2014'
            GROUP BY `Educational Attainment`
        ) b
    )
);


/*
======================================================================
Q27. Find Age + Gender combinations whose average annual population
from 2008-2014 is above the overall average annual population across
all Age + Gender combinations.
======================================================================*/
SELECT
    Age,
    Gender,
    AVG(total_population) AS average_population
FROM (
    SELECT
        Age,
        Gender,
        Year,
        SUM(`Population Count`) AS total_population
    FROM edu_inc
    GROUP BY Age, Gender, Year
) a
GROUP BY Age, Gender
HAVING AVG(total_population) > (
    SELECT AVG(total_population)
    FROM (
        SELECT
            Age,
            Gender,
            Year,
            SUM(`Population Count`) AS total_population
        FROM edu_inc
        GROUP BY Age, Gender, Year
    ) b
);


/*
======================================================================
Q28. Find Educational Attainment categories whose 2014 population was
higher than their own average population across 2008-2014.
======================================================================*/
SELECT
    `Educational Attainment`,
    SUM(
        CASE
            WHEN Year = '01-01-2014'
                THEN `Population Count`
            ELSE 0
        END
    ) AS population_2014
FROM edu_inc
GROUP BY `Educational Attainment`
HAVING SUM(
    CASE
        WHEN Year = '01-01-2014'
            THEN `Population Count`
        ELSE 0
    END
) > (
    SELECT AVG(total_population)
    FROM (
        SELECT
            Year,
            `Educational Attainment`,
            SUM(`Population Count`) AS total_population
        FROM edu_inc
        GROUP BY Year, `Educational Attainment`
    ) a
    WHERE a.`Educational Attainment` =
          edu_inc.`Educational Attainment`
);
