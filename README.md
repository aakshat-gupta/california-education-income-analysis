# california-education-income-analysis
MySQL data analytics project analyzing California population, education, gender, age, and personal income trends from 2008–2014 using joins, window functions, CTEs, and subqueries.


# California Education & Income Analysis

## Project Overview

This project analyzes California population data from 2008 to 2014 across different demographic and socioeconomic dimensions.

The analysis covers:

- Age
- Gender
- Educational Attainment
- Personal Income
- Population Count

The project contains 28 analytical SQL questions and uses MySQL 8.0+ with advanced SQL techniques.

## Dataset

The dataset contains:

- 1,060 records
- 7 years of data (2008–2014)
- 3 age groups
- 2 genders
- 5 education levels
- 8 income bands

### Main Table

`ca_education_income`

### Columns

| Column | Description |
|---|---|
| Year | Year of the observation |
| Age | Age group |
| Gender | Gender category |
| Educational Attainment | Education level |
| Personal Income | Income band |
| Population Count | Population count |

## SQL Techniques Used

### 1. Self Joins

Used to compare population between different years and identify changes across demographic segments.

### 2. Window Functions

The project uses:

- `RANK()`
- `DENSE_RANK()`
- `ROW_NUMBER()`
- `LAG()`

These functions are used for ranking categories, calculating previous-year population, and analyzing population changes.

### 3. Common Table Expressions (CTEs)

CTEs are used to divide complex analytical problems into multiple logical steps.

### 4. Subqueries

Subqueries are used for:

- Average-based comparisons
- Above-average population analysis
- Top and second-highest categories
- Dynamic filtering

## Analysis Questions

The project contains 28 SQL analytical questions divided into four major sections:

### Self Joins
Questions 1–6

- Cross-year population comparisons
- Demographic segment growth
- Gender comparisons
- Education and income comparisons

### Window Functions
Questions 7–16

- Education rankings
- Income rankings
- Previous-year population
- Year-over-year growth
- Cumulative population
- Population shares

### CTEs
Questions 17–22

- Population classification
- Education changes
- Gender comparisons
- Age-group averages
- Population growth patterns
- Income-band population shares

### Subqueries
Questions 23–28

- Above-average education categories
- Above-average income bands
- Most populated demographic groups
- Second-highest education category
- Average population comparisons

## Key Insights

The analysis found several notable patterns between 2008 and 2014:

- Total population increased from approximately 26.5M to 28.2M.
- The male-female population gap decreased from approximately 265K to 32K.
- Bachelor's degree holders showed the largest population growth among education categories.
- The no-diploma category declined during the period.
- The 65–80+ age group experienced the fastest growth among the three age groups.
- The population share of the "No Income" category increased from 16.4% to 18.4%.
- Working-age adults with a Bachelor's degree or higher and income of $75,000+ represented some of the largest population gains.

## Visual Analysis

The project includes visual analysis of:

- Population by educational attainment
- Education population share
- Income distribution by education
- Education and income combinations
- $75,000+ income population
- Demographic population changes

## Project Structure

```text
california-education-income-analysis/
│
├── data/
│   └── ca_education_income.csv
│
├── sql/
│   ├── self_joins.sql
│   ├── window_functions.sql
│   ├── ctes.sql
│   └── subqueries.sql
│
├── screenshots/
│   └── query_results/
│
├── report/
│   └── California_Education_Income_Analysis.pdf
│
└── README.md
