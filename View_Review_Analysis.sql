-- Determining any bias towards reviews 
-- that were written as part of the Vine program.
-- Determine having a paid Vine review 
-- makes a difference in the percentage of 5-stars

-- vine table
CREATE TABLE vine_table (
  review_id TEXT PRIMARY KEY,
  star_rating INTEGER,
  helpful_votes INTEGER,
  total_votes INTEGER,
  vine TEXT,
  verified_purchase TEXT
);

SELECT * FROM vine_table;

-- create new table with total_votes >= 20
SELECT review_id, star_rating, helpful_votes,
total_votes, vine, verified_purchase
INTO total_20plus_votes
FROM vine_table
WHERE total_votes >= 20;

SELECT * FROM total_20plus_votes

-- filter data helpful/total >= 0.5
SELECT review_id, star_rating, helpful_votes,
total_votes, vine, verified_purchase
INTO helpful_total_great50
FROM total_20plus_votes
WHERE CAST(helpful_votes AS FLOAT)/CAST(total_votes AS FLOAT) >=0.5;

SELECT * FROM helpful_total_great50

-- Vine yes
SELECT review_id, star_rating, helpful_votes,
total_votes, vine, verified_purchase
INTO vine_yes
FROM helpful_total_great50
WHERE vine = 'Y';

-- Vine no
SELECT review_id, star_rating, helpful_votes,
total_votes, vine, verified_purchase
INTO vine_no
FROM helpful_total_great50
WHERE vine = 'N';

SELECT * FROM vine_yes
SELECT * FROM vine_no

-- purchased vine, 5 star reviews
SELECT CAST(COUNT(review_id) AS FLOAT) AS total_reviews, 
CAST(COUNT(CASE WHEN star_rating=5 THEN 1 END) AS FLOAT) AS five_star_count,
CAST(CAST(COUNT(CASE WHEN star_rating=5 THEN 1 END) AS FLOAT)/CAST(COUNT(review_id) AS FLOAT) AS FLOAT) * 100 AS
five_star_percentage
INTO vine_yes_fivestar
FROM vine_yes;

-- did not purchase vine, 5 star reviews
SELECT CAST(COUNT(review_id) AS FLOAT) AS total_reviews, 
CAST(COUNT(CASE WHEN star_rating=5 THEN 1 END) AS FLOAT) AS five_star_count,
(CAST(CAST(COUNT(CASE WHEN star_rating=5 THEN 1 END) AS FLOAT)/CAST(COUNT(review_id) AS FLOAT) AS FLOAT) * 100) AS
five_star_percentage
INTO vine_no_fivestar
FROM vine_no;

SELECT * FROM vine_yes_fivestar
SELECT * FROM vine_no_fivestar

-- lowering total votes = 15
SELECT review_id, star_rating, helpful_votes,
total_votes, vine, verified_purchase
INTO total_15plus_votes
FROM vine_table
WHERE total_votes >= 10;

SELECT review_id, star_rating, helpful_votes,
total_votes, vine, verified_purchase
--INTO helpful_total_great50
FROM total_15plus_votes
WHERE CAST(helpful_votes AS FLOAT)/CAST(total_votes AS FLOAT) >=0.5;

-- lowering total votes = 10
SELECT review_id, star_rating, helpful_votes,
total_votes, vine, verified_purchase
INTO total_10plus_votes
FROM vine_table
WHERE total_votes >= 10;

SELECT review_id, star_rating, helpful_votes,
total_votes, vine, verified_purchase
--INTO helpful_total_great50
FROM total_10plus_votes
WHERE CAST(helpful_votes AS FLOAT)/CAST(total_votes AS FLOAT) >=0.5;

-- Breakdown by star rating
-- vine yes
SELECT COUNT(review_id), star_rating
FROM vine_yes
GROUP BY(star_rating)
ORDER BY star_rating

SELECT COUNT(review_id), star_rating
FROM vine_no
GROUP BY(star_rating)
ORDER BY star_rating

