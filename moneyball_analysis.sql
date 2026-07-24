CREATE DATABASE Football_analysis;
USE Football_analysis;

create table players(
player_id varchar(50) primary key,
player_name varchar(100),
age int,
nationality varchar(50),
position varchar(50),
club_name varchar(100),
market_value_eur bigint
);


 create table matches(
match_id VARCHAR(10) primary key,
match_date date,
stadium varchar (100),
city varchar (50),
tournament_stage varchar (50)
);

create table match_performances(
player_id varchar(50),
match_id varchar(10),
team varchar(50),
opponent_team VARCHAR(50),
match_result VARCHAR(5),
minutes_played INT,
goals INT,
assists INT,
expected_goals_xg DECIMAL(4,2),
total_passes INT,
pass_accuracy DECIMAL(4,2),
tackles INT,
yellow_cards INT,
red_cards INT,
player_rating DECIMAL(4,2),
foreign key (player_id) references players (player_id),
foreign key (match_id) references matches (match_id)
);

START TRANSACTION;

INSERT INTO players (player_id, player_name, age, nationality, position, club_name, market_value_eur)
SELECT DISTINCT 
player_id, 
player_name, 
age, 
nationality, 
position, 
club_name, 
market_value_eur
FROM fifa;	

INSERT INTO matches (match_id, match_date, stadium, city, tournament_stage)
SELECT DISTINCT 
match_id, 
STR_TO_DATE(match_date, '%d-%m-%Y'), 
stadium, 
city, 
tournament_stage 
FROM fifa;


INSERT INTO match_performances (player_id, match_id, team, opponent_team, match_result, minutes_played, goals, assists, expected_goals_xg, total_passes, pass_accuracy, tackles, yellow_cards, red_cards, player_rating)
SELECT 
player_id, 
match_id, 
team, 
opponent_team, 
match_result, 
minutes_played, 
goals, 
assists, 
expected_goals_xg, 
total_passes, 
pass_accuracy, 
tackles, 
yellow_cards, 
red_cards, 
player_rating  
FROM fifa;

COMMIT;


-- 1. Write a query to find the names, market values, and match ratings of players whose market value is less than 5,000,000 and who have a match rating greater than 8.0.
SELECT DISTINCT
    p.player_name,
    p.market_value_eur AS player_value,
    mp.player_rating
FROM
    players AS p
        INNER JOIN
    match_performances AS mp ON p.player_id = mp.player_id
WHERE
    p.market_value_eur < 5000000
        AND mp.player_rating > 8.0;	

-- 2. Write a query to find the names, market values, and match ratings of players whose market value is greater than 50,000,000 and who have a match rating less than 6.5.
SELECT DISTINCT
    p.player_name,
    p.market_value_eur AS player_value,
    mp.player_rating
FROM
    players AS p
        INNER JOIN
    match_performances AS mp ON p.player_id = mp.player_id
WHERE
    p.market_value_eur > 50000000
        AND mp.player_rating < 6.5;

-- 3. Calculate the average market value and average player rating for each club. Return the top 10 clubs sorted by their average rating in descending order.
SELECT 
    p.club_name,
    AVG(p.market_value_eur) AS average_club_value,
    AVG(mp.player_rating) AS average_club_rating
FROM
    players AS p
        INNER JOIN
    match_performances AS mp ON p.player_id = mp.player_id
GROUP BY p.club_name
ORDER BY average_club_rating DESC
LIMIT 10;

-- 4. Categorize players into performance tiers based on the following rules: Ratings >= 8.0 are 'Elite', ratings >= 6.5 are 'Solid', and everything else is 'Underperforming'.
SELECT DISTINCT
    p.player_name,
    mp.player_rating,
    CASE
        WHEN mp.player_rating >= 8.0 THEN 'Elite'
        WHEN mp.player_rating >= 6.5 THEN 'Solid'
        ELSE 'Underperforming'
    END AS performance_tier
FROM
    players AS p
        INNER JOIN
    match_performances AS mp ON p.player_id = mp.player_id;

-- 5. Find the names, tournament stages, stadiums, goals, and ratings of players who scored more than 0 goals in matches where the tournament stage includes the word 'Final'. Order by rating descending.
SELECT 
    p.player_name,
    m.tournament_stage,
    m.stadium,
    mp.goals,
    mp.player_rating
FROM
    players AS p
        INNER JOIN
    match_performances AS mp ON p.player_id = mp.player_id
        INNER JOIN
    matches AS m ON m.match_id = mp.match_id
WHERE
    m.tournament_stage LIKE '%Final%'
        AND mp.goals > 0
ORDER BY mp.player_rating DESC;

 -- 6. Retrieve the names and market values of all players in the database.
SELECT 
    player_name, market_value_eur
FROM
    players;

-- 7. Retrieve all details of players who belong to a club whose name contains 'Real Madrid'.
SELECT 
    *
FROM
    players
WHERE
    club_name LIKE '%Real Madrid%';

-- 8. Retrieve the names and market values of players whose market value is strictly greater than 80,000,000.
SELECT 
    player_name, market_value_eur
FROM
    players
WHERE
    market_value_eur > 80000000;

-- 9. Retrieve all match performance details where the player rating is 9.40 or higher.
SELECT 
    *
FROM
    match_performances
WHERE
    player_rating >= 9.40;

-- 10. Find the names, clubs, and market values of players whose market value is less than 5,000,000 and whose club name contains 'Manchester City'.
SELECT 
    player_name, club_name, market_value_eur
FROM
    players
WHERE
    market_value_eur < 5000000
        AND club_name LIKE '%Manchester City%';

-- 11. Retrieve the names and market values of the top 5 most expensive players.
SELECT 
    player_name, market_value_eur
FROM
    players
ORDER BY market_value_eur DESC
LIMIT 5;

-- 12. Retrieve the player IDs and match ratings for the 10 lowest recorded player ratings, sorted in ascending order.
SELECT DISTINCT
    player_id, player_rating
FROM
    match_performances
ORDER BY player_rating ASC
LIMIT 10;

-- 13. Count the total number of matches played.
SELECT 
    COUNT(match_id) AS total_matches_played
FROM
    matches;

-- 14. Calculate the average market value of all players.
SELECT 
    AVG(market_value_eur) AS average_player_value
FROM
    players;

-- 15. Calculate the total combined market value of all players.
SELECT 
    SUM(market_value_eur) AS total_league_value
FROM
    players;

-- 16. Find the highest recorded player rating in any match.
SELECT 
    MAX(player_rating) AS highest_rating
FROM
    match_performances;

-- 17. Find the maximum (most expensive) and minimum (cheapest) player market values.
SELECT 
    MAX(market_value_eur) AS most_expensive_player_value,
    MIN(market_value_eur) AS cheapest_player_value
FROM
    players;

-- 18. Count the total number of players registered to each club.
SELECT 
    COUNT(player_id) AS total_players, club_name
FROM
    players
GROUP BY club_name;

-- 19. Count the number of matches played on each specific match date.
SELECT 
    COUNT(match_id) AS number_of_matches_played, match_date
FROM
    matches
GROUP BY match_date;

-- 20. Find the player IDs of players who have an average match rating greater than 4.5.
SELECT 
    player_id, AVG(player_rating) AS average_player_rating
FROM
    match_performances
GROUP BY player_id
HAVING AVG(player_rating) > 4.5;

-- 21. Find the match dates that had a heavy schedule, featuring more than 2 matches played.
SELECT 
    COUNT(match_id) AS number_of_matches_played, match_date
FROM
    matches
GROUP BY match_date
HAVING COUNT(match_id) > 2;

-- 22. Write an INNER JOIN query to retrieve the player name, club name, and match rating for all recorded performances.
SELECT DISTINCT
    p.player_name, p.club_name, mp.player_rating
FROM
    players AS p
        INNER JOIN
    match_performances AS mp ON p.player_id = mp.player_id;

-- 23. Write an INNER JOIN query to retrieve the match date, player ID, and player rating.
SELECT DISTINCT
    m.match_date, mp.player_id, mp.player_rating
FROM
    matches AS m
        INNER JOIN
    match_performances AS mp ON m.match_id = mp.match_id;

-- 24. Write an INNER JOIN query combining all three tables to retrieve the match date, player name, and player rating.
SELECT DISTINCT
    m.match_date, p.player_name, mp.player_rating
FROM
    players AS p
        INNER JOIN
    match_performances AS mp ON p.player_id = mp.player_id
        INNER JOIN
    matches AS m ON m.match_id = mp.match_id;

-- 25. Write an INNER JOIN query to calculate the average player rating for each club.
SELECT 
    p.club_name, AVG(mp.player_rating) AS average_club_rating
FROM
    players AS p
        INNER JOIN
    match_performances AS mp ON p.player_id = mp.player_id
GROUP BY p.club_name;

-- 26. Write an INNER JOIN query to retrieve the player name, market value, and match rating for players whose market value is greater than 50,000,000.
SELECT DISTINCT
    player_name, p.market_value_eur, mp.player_rating
FROM
    players AS p
        INNER JOIN
    match_performances AS mp ON p.player_id = mp.player_id
WHERE
    p.market_value_eur > 50000000;

-- 27. Using a subquery, find the names and market values of players whose market value is greater than the overall average market value.
SELECT 
    player_name, market_value_eur
FROM
    players
WHERE
    market_value_eur > (SELECT 
            AVG(market_value_eur)
        FROM
            players);

-- 28. Using a subquery, find the dates of matches where a player achieved a rating greater than 9.
SELECT 
    match_date
FROM
    matches
WHERE
    match_id IN (SELECT 
            match_id
        FROM
            match_performances
        WHERE
            player_rating > 9);

-- 29. Using a nested subquery, retrieve all match details for performances by the single most expensive player in the database.
SELECT 
    *
FROM
    matches
WHERE
    match_id IN (SELECT 
            match_id
        FROM
            match_performances
        WHERE
            player_id = (SELECT 
                    player_id
                FROM
                    players
                ORDER BY market_value_eur DESC
                LIMIT 1));

-- 30. Using a subquery, find the names and clubs of players who play for the same club as the single most expensive player.
SELECT 
    player_name, club_name
FROM
    players
WHERE
    club_name = (SELECT 
            club_name
        FROM
            players
        ORDER BY market_value_eur DESC
        LIMIT 1);

-- 31. Segment players into Market Value Tiers using these specific thresholds: Tier 1 (> 100,000,000), Tier 2 (Between 50,000,000 and 100,000,000), and Tier 3 (everything else).
SELECT 
    player_name,
    market_value_eur,
    CASE
        WHEN market_value_eur > 100000000 THEN 'Tier 1'
        WHEN market_value_eur BETWEEN 50000000 AND 100000000 THEN 'Tier 2'
        ELSE 'Tier 3'
    END AS Value_Tier
FROM
    players;

-- 32. Using a LEFT JOIN, find the names of players who do not have any recorded match performances (where the performance ID is NULL).
SELECT 
    p.player_name
FROM
    players AS p
        LEFT JOIN
    match_performances AS mp ON p.player_id = mp.player_id
WHERE
    mp.player_id IS NULL;

-- 33. Using a Common Table Expression (CTE), calculate the average match rating for each club and return only the clubs with an average rating greater than 7.5.
WITH ClubAverages AS
(
    SELECT
        p.club_name,
        AVG(mp.player_rating) AS average_rating
    FROM players p
    JOIN match_performances mp
        ON p.player_id = mp.player_id
    GROUP BY p.club_name
)
SELECT
    club_name,
    average_rating
FROM ClubAverages
WHERE average_rating > 7.5;

-- 34. Using a Window Function, rank the players by their market value in descending order, partitioned strictly within their own club name.
SELECT
    player_name,
    club_name,
    market_value_eur,
    RANK() OVER (
        PARTITION BY club_name
        ORDER BY market_value_eur DESC
    ) AS player_rank
FROM players;

















 