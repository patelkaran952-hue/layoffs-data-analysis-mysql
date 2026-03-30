# 📊 Layoffs Data Analysis using MySQL

## 📌 Project Overview
This project analyzes global layoffs data using MySQL. The goal is to clean raw data, standardize inconsistent values, and extract meaningful insights about layoffs trends across companies, industries, and countries.

---

## 🎯 Objectives
- Perform data cleaning and preprocessing
- Remove duplicates and handle missing values
- Standardize inconsistent data
- Analyze layoffs trends over time
- Generate business insights

---

## 🗂️ Dataset
- Source: Kaggle (Layoffs Dataset)
- Contains information on:
  - Company
  - Location
  - Industry
  - Total layoffs
  - Percentage laid off
  - Date
  - Stage
  - Country
  - Funds raised

---

## 🛠️ Tools Used
- MySQL
- SQL (Window Functions, CTEs, Aggregations)

---

## 🧹 Data Cleaning Steps

1. Removed duplicate records using `ROW_NUMBER()`
2. Trimmed extra spaces using `TRIM()`
3. Standardized categorical values (e.g., country, industry)
4. Converted date format using `STR_TO_DATE()`
5. Handled NULL and empty values
6. Cleaned inconsistent location entries (e.g., removed 'Non-U.S.')

---

## 📊 Exploratory Data Analysis (EDA)

### Key Analysis Performed:
- Total layoffs by company
- Layoffs by industry
- Layoffs by country
- Yearly and monthly trends
- Cumulative layoffs over time

---

## 📈 Key Insights

- Layoffs peaked in specific years indicating economic slowdown
- Certain industries were more affected than others
- The United States had the highest number of layoffs
- Monthly trends showed spikes during particular periods

---

## 📁 Project Structure
