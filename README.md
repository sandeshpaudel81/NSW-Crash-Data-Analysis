# NSW Road Crash Analysis (2019–2023)

An end-to-end analytics project that turns NSW road crash records into an interactive Power BI report. It covers 93,420 crashes and shows when, where and under what conditions they happen.

## Workflow

1. **Clean (Python):** `Data_cleaning.ipynb` selects 23 of the 50 raw columns, standardises names and values, fills unknown lighting and time values where the data allows, removes 71 out-of-scope 2018 records, and adds a monthly date field.
2. **Query (SQL Server):** `nsw_road_crash.sql` explores yearly and monthly trends, peak times, injuries by LGA and weekday, school zones, top streets, and year-on-year change by LGA.
3. **Visualise (Power BI):** `dashboard_rec.pbix` uses DAX measures across three linked pages:
   - **Overview:** crash and casualty totals, trend, severity, weather, lighting and speed limit
   - **Temporal:** monthly patterns, time of day by weekday, and weekend vs weekday casualties
   - **Location:** crashes by LGA, street type, town and school zone

## Key figures

- 93,420 crashes, 1,533 deaths and 77,765 injuries
- Crashes fell 8.5%, from 20,355 in 2019 to 18,633 in 2023
- 28.6% of crashes occurred between 2 pm and 6 pm

## Run it

The data files are not included in this repo. To refresh the report, add `nsw_road_crash_data_2019-2023_crash.csv`, run the notebook, load `final_data.csv` into a SQL Server database named `nsw_crash` as `nsw_crash_data_clean`, and update the server name in Power BI. To simply view the report, open the `.pbix` file in Power BI Desktop.

**Tools:** Python (pandas), SQL Server (T-SQL), Power BI (DAX)
