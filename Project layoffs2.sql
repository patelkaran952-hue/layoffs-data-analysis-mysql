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


-- Standardise Data

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


-- Replace empty values with NULL

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


-- Standardise Dates

select `date`
from layoffsgpt3;

UPDATE layoffsgpt3
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

CREATE TABLE layoffsgpt4 AS
SELECT DISTINCT *
FROM layoffsgpt3;

select `date`
from layoffsgpt4;

UPDATE layoffsgpt4
SET `date` = STR_TO_DATE(`date`, '%m/%d/%Y');

alter table layoffsgpt4
drop row_num;

delete
from layoffsgpt4
where row_num > 1;

select *
from layoffsgpt4;

CREATE TABLE layoffsgpt_cleaned AS
SELECT *
FROM layoffsgpt4;

select *
from layoffsgpt_cleaned
where total_laid_off is null;

delete
from layoffsgpt_cleaned
where total_laid_off is null;

UPDATE layoffsgpt_cleaned
SET location = REPLACE(location, ', Non-U.S.', '');

UPDATE layoffsgpt_cleaned
SET total_laid_off = TRUNCATE(total_laid_off, 0);

ALTER TABLE layoffsgpt_cleaned
MODIFY COLUMN total_laid_off INT;

update layoffsgpt_cleaned
SET date_added = STR_TO_DATE(date_added, '%m/%d/%Y');

select *
from layoffsgpt_cleaned;


-- Exploratory Data Cleaning

SELECT company, total_laid_off
FROM layoffsgpt_cleaned
ORDER BY total_laid_off DESC;

SELECT company, country, total_laid_off
from layoffsgpt_cleaned
WHERE company = 'Meta';

SELECT company, MIN(date), MAX(date) 
FROM layoffsgpt_cleaned
group by company;

SELECT industry, SUM(total_laid_off) AS total_layoffs
FROM layoffsgpt_cleaned
GROUP BY industry
ORDER BY total_layoffs DESC;

SELECT country, SUM(total_laid_off) AS total_layoffs
FROM layoffsgpt_cleaned
GROUP BY country
ORDER BY total_layoffs DESC;

SELECT stage, SUM(total_laid_off) AS total_layoffs
FROM layoffsgpt_cleaned
GROUP BY stage
ORDER BY total_layoffs DESC;

-- Total layoffs per year 
SELECT YEAR(`date`) AS year,
       SUM(total_laid_off) AS total_layoffs
FROM layoffsgpt_cleaned
GROUP BY YEAR(`date`)
ORDER BY year;

-- Total layoffs per month
SELECT DATE_FORMAT(`date`, '%Y-%m') AS month, country,
       SUM(total_laid_off) AS total_layoffs
FROM layoffsgpt_cleaned
GROUP BY month, country
ORDER BY total_layoffs DESC;


-- Rolling total per month
with Rolling_Total as 
(
select substring(`date`,1,7) as `Month`, sum(total_laid_off) as total_off
from layoffsgpt_cleaned
where substring(`date`,1,7) is not null
group by `Month`
order by 1
)
select `Month`, total_off, sum(total_off) over(order by `Month`) as rolling_total
from Rolling_Total;


-- Rolling total by Year
with Rolling_Total as 
(
select substring(`date`,1,4) as `Year`, sum(total_laid_off) as total_off
from layoffsgpt_cleaned
where substring(`date`,1,4) is not null
group by `Year`
order by 1
)
select `Year`, total_off, sum(total_off) over(order by `Year`) as rolling_total
from Rolling_Total;


select company, year(`date`), sum(total_laid_off)
from layoffsgpt_cleaned
group by company, year(`date`)
order by 3 desc;


-- Top 5 companies with layoffs in each year
with Company_Year (Company, Years, total_laid_off) as
(
select company, year(`date`), sum(total_laid_off)
from layoffsgpt_cleaned
group by company, year(`date`)
), Company_Year_Rank as
(select *,
dense_rank() over (partition by years order by total_laid_off desc) as Ranking
from Company_Year
where years is not null
)
select *
from Company_Year_Rank
where Ranking <= 5;





































