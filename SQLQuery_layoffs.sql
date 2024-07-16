
-- Looking at the data in the table
select * from 
layoffs



-------------------------------------------------------------------------------
-- Copy the data from the original_table to another trmp_table 
select * 
into temp_layoffs
from layoffs




-------------------------------------------------------------------------------
-- Removing the duplicates rows 
select * ,
ROW_NUMBER () OVER (partition by company,location, industry,
date, total_laid_off, stage, funds_raised_millions, percentage_laid_off	order by date) 
from layoffs



-------------------------------------------------------------------------------
-- Ctreate a Column to add the row numbers at it 
alter table temp_layoffs 
add row_num int 




-------------------------------------------------------------------------------
--Creating a CTE to deletw the duplicate rowstheat are going ti be remove 
WITH duplicate
AS 
(
select * ,
ROW_NUMBER () OVER (partition by company,location, industry,country,
date, total_laid_off, stage, funds_raised_millions, percentage_laid_off	order by date)as d_row
from temp_layoffs
)
delete 
from duplicate
where d_row > 1 




-------------------------------------------------------------------------------
-- Update the temp table and add the row number column with the values from CTE 
WITH duplicate
AS 
(
select * ,
ROW_NUMBER () OVER (partition by company,location, industry,country,
date, total_laid_off, stage, funds_raised_millions, percentage_laid_off	order by date)as d_row
from temp_layoffs
)
update temp_layoffs
set temp_layoffs.row_num= duplicate.d_row
from duplicate
select * from temp_layoffs
where row_num >1




-------------------------------------------------------------------------------
-- Standrize the data 


-- Transform company column 
select trim (company)
from temp_layoffs

update temp_layoffs
set company = trim (company) 



-- Transform Location column 
select distinct trim (location)
from temp_layoffs
order by 1

update temp_layoffs
set location = trim ( location ) 


-- Transform Location column 
select distinct ( industry)
from temp_layoffs
order by 1

update temp_layoffs
set industry = 'Crypto'
where industry like 'Crypto%'

select industry
from temp_layoffs
where industry like 'Crypto%'



-- Transform country column 
select  country, trim(trailing '.' from country)
from temp_layoffs
order by 1

update temp_layoffs
set country = trim(trailing '.' from country)
where country like 'United States%'



-- Transform date column 
select date, 
convert ( date, date ) as New_date 
from temp_layoffs

alter table temp_layoffs 
add New_date date 

update temp_layoffs
set New_date = convert ( date, date )  


-- Delete unused column 
alter table temp_layoffs
drop column date


select *
from temp_layoffs


----------------------------------------------------------------------
-- Fixing and removing blank and null values 

select *
from temp_layoffs
where industry is null or industry = ''
or industry = ''

SELECT	*
FROM temp_layoffs t1
INNER JOIN temp_layoffs t2 
	ON t1.company = t2.company
	AND t1.location = t2.location
where t1.industry IS NULL OR t1.industry =''
	AND t1.industry	is not null 

update temp_layoffs
set industry = null 
where industry = '' 


UPDATE  t1
SET t1.industry = t2.industry
FROM temp_layoffs t1
INNER JOIN temp_layoffs t2 ON t1.industry = t2.industry AND t1.location = t2.location
WHERE t1.industry IS NULL 
  AND t2.industry IS NOT NULL;

