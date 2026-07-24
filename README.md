# Football Moneyball: Value vs. Performance SQL Analysis

## 📌 Project Overview
An exploratory data analysis project investigating the relationship between player market values and actual pitch performance. This project analyzes a relational database of players, matches, and match performances to identify undervalued talent, team efficiency, and performance tiers. 

## 🗄️ Database Schema
The project relies on a three-table MySQL database structure:
* **`players`**: Demographics, club affiliations, and market value (`market_value_eur`).
* **`matches`**: Fixture details, locations, and tournament stages.
* **`match_performances`**: Individual player ratings, goals, expected goals (xG), and match statistics.

## 🧠 Key Business Questions Answered
* Which clubs extract the highest average match ratings from their squads?
* How are players categorized by market value tiers, and does tier correlate with pitch performance?
* Who are the highest-valued players within each specific club?
* Which players are delivering elite performances (Rating > 8.0) while remaining undervalued (Market Value < €5M)?

## 🛠️ Technical Skills Demonstrated
* **Advanced SQL**: Window Functions (`RANK()`), Common Table Expressions (`WITH`), and Control Flow (`CASE WHEN`).
* **Core SQL**: Multi-table `INNER JOIN` and `LEFT JOIN` operations, Aggregate functions (`AVG`, `COUNT`, `SUM`), and Subqueries.
* **Database Management**: Schema creation with Primary/Foreign Key constraints and transaction control (`START TRANSACTION`, `COMMIT`).
  
## 🚀 How to Use This Repository
All database creation and analysis queries are located in the moneyball_analysis.sql file.
The initial raw data was loaded from a master fifa dataset and normalized into the three-table schema using INSERT INTO ... SELECT statements.

## 💻 Featured Code Snippet
To identify the most valuable player strictly within the context of their own club, I utilized a Window Function to partition the rankings:

```sql
SELECT
    player_name,
    club_name,
    market_value_eur,
    RANK() OVER (
        PARTITION BY club_name
        ORDER BY market_value_eur DESC
    ) AS player_rank
FROM players;
