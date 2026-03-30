select *
from layoffsgpt;

create table layoffsgpt2
like layoffsgpt;

insert layoffsgpt2
select *
from layoffsgpt;

select *
from layoffsgpt2;


-- Remove Duplicates

SELECT *,
ROW_NUMBER() OVER(
    PARTITION BY company, location, total_laid_off, percentage_laid_off, industry, stage, funds_raised, country
) AS row_num
FROM layoffsgpt2;

with duplicate_cte as
(
select *,
ROW_NUMBER() OVER(
    PARTITION BY company, location, total_laid_off, percentage_laid_off, industry, stage, funds_raised, country
) AS row_num
FROM layoffsgpt2
)
select * 
from duplicate_cte
where row_num > 1;

select *
from layoffsgpt2
where company = '2U';

CREATE TABLE `layoffsgpt3` (
  `company` text,
  `location` text,
  `total_laid_off` text,
  `date` text,
  `percentage_laid_off` text,
  `industry` text,
  `source` text,
  `stage` text,
  `funds_raised` int DEFAULT NULL,
  `country` text,
  `date_added` text,
  `row_num` int
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_0900_ai_ci;

insert into layoffsgpt3
select *,
ROW_NUMBER() OVER(
    PARTITION BY company, location, total_laid_off, percentage_laid_off, industry, stage, funds_raised, country
) AS row_num
FROM layoffsgpt2;

delete
from layoffsgpt3
where row_num > 1;

select *
from layoffsgpt3;


-- Standardize Data

select company, trim(company)
from layoffsgpt3;

UPDATE layoffsgpt3
SET 
    company = TRIM(company),
    location = TRIM(location),
    industry = TRIM(industry),
    country = TRIM(country),
    stage = TRIM(stage);
    
select *
from layoffsgpt3;


-- Remove null and blank values

select *
from layoffsgpt3
where total_laid_off = ''
and percentage_laid_off = '';

update layoffsgpt3
set total_laid_off = null
where total_laid_off = '';

select *
from layoffsgpt3
where country = '';

update layoffsgpt3
set country = 'Canada'
where company = 'Ludia';

select *
from layoffsgpt3
where industry = '';

update layoffsgpt3
set industry = null
where industry = '';

select *
from layoffsgpt3
where stage = '';

update layoffsgpt3
set stage = null
where stage = '';


















