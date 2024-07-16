
# SQL Operations on Layoffs Data

This repository contains SQL scripts to manipulate and clean data from a table named `layoffs`. The scripts are designed to copy data, remove duplicates, add row numbers, standardize data fields, and clean null or blank values. Below is a breakdown of each SQL operation:

## Table of Contents

1. [Copy Data to Temporary Table](#copy-data-to-temporary-table)
2. [Remove Duplicate Rows](#remove-duplicate-rows)
3. [Add Row Numbers](#add-row-numbers)
4. [Standardize Data](#standardize-data)
5. [Fix Null and Blank Values](#fix-null-and-blank-values)

---

## Copy Data to Temporary Table

```sql
-- Copy the data from the original_table to another temp_table 
SELECT * 
INTO temp_layoffs
FROM layoffs;
```

---

## Remove Duplicate Rows

```sql
-- Removing the duplicates rows 
WITH duplicate AS (
    SELECT *,
           ROW_NUMBER() OVER (PARTITION BY company, location, industry, date, total_laid_off, 
                              stage, funds_raised_millions, percentage_laid_off
                              ORDER BY date) AS d_row
    FROM temp_layoffs
)
DELETE FROM duplicate
WHERE d_row > 1;
```

---

## Add Row Numbers

```sql
-- Create a Column to add the row numbers at it 
ALTER TABLE temp_layoffs 
ADD row_num INT;
```

---

## Standardize Data

### Transform Company Column

```sql
-- Transform company column 
UPDATE temp_layoffs
SET company = TRIM(company);
```

### Transform Location Column

```sql
-- Transform Location column 
UPDATE temp_layoffs
SET location = TRIM(location);
```

### Transform Industry Column

```sql
-- Transform Industry column 
UPDATE temp_layoffs
SET industry = 'Crypto'
WHERE industry LIKE 'Crypto%';
```

### Transform Country Column

```sql
-- Transform country column 
UPDATE temp_layoffs
SET country = TRIM(TRAILING '.' FROM country)
WHERE country LIKE 'United States%';
```

### Transform Date Column

```sql
-- Transform date column 
ALTER TABLE temp_layoffs 
ADD New_date DATE;

UPDATE temp_layoffs
SET New_date = CONVERT(DATE, date);

ALTER TABLE temp_layoffs
DROP COLUMN date;
```

---

## Fix Null and Blank Values

```sql
-- Fixing and removing blank and null values 
DELETE FROM temp_layoffs
WHERE industry IS NULL OR industry = '';

UPDATE temp_layoffs
SET industry = NULL 
WHERE industry = '';

UPDATE t1
SET t1.industry = t2.industry
FROM temp_layoffs t1
INNER JOIN temp_layoffs t2 ON t1.industry = t2.industry AND t1.location = t2.location
WHERE t1.industry IS NULL 
  AND t2.industry IS NOT NULL;
```

---

This README file provides a structured overview of the SQL operations performed on the `layoffs` table data, explaining each step along with the corresponding SQL script. You can copy and paste this content into your GitHub repository's README.md file to document your SQL operations effectively. Adjust the descriptions and headings as needed to fit your specific context and repository setup.
