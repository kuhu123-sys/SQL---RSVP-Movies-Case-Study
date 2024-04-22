USE imdb;

/* Now that you have imported the data sets, let’s explore some of the tables. 
 To begin with, it is beneficial to know the shape of the tables and whether any column has null values.
 Further in this segment, you will take a look at 'movies' and 'genre' tables.*/


-- Segment 1:



-- Q1. Find the total number of rows in each table of the schema?

SELECT COUNT(*) AS count_director_mapping FROM director_mapping; -- After running this command, got count of rows as 3867
SELECT COUNT(*) AS count_genre FROM genre; -- After running this command, got count of rows as 14662
SELECT COUNT(*) AS count_movie FROM movie; -- After running this command, got count of rows as 7997
SELECT COUNT(*) AS count_names FROM names; -- After running this command, got count of rows as 25735
SELECT COUNT(*) AS count_ratings FROM ratings; -- After running this command, got count of rows as 7997
SELECT COUNT(*) AS count_role_mapping FROM role_mapping; -- After running this command, got count of rows as 15615


-- Q2. Which columns in the movie table have null values?

-- Total number of rows in movies table is 7997 as we saw when we solved the earlier question so let's check
-- the count of each column in order to find columns which have null values.

SELECT COUNT(id) FROM movie; -- 7997 is the count
SELECT COUNT(title) FROM movie; -- 7997 is the count
SELECT COUNT(year) FROM movie; -- 7997 is the count
SELECT COUNT(date_published) FROM movie; -- 7997 is the count
SELECT COUNT(duration) FROM movie; -- 7997 is the count
SELECT COUNT(country) FROM movie; -- 7977 is the count
SELECT COUNT(worlwide_gross_income) FROM movie; -- 4273 is the count
SELECT COUNT(languages) FROM movie; -- 7803 is the count
SELECT COUNT(production_company) FROM movie; -- 7469 is the count

-- As per above queries, columns like country, worlwide_gross_income, lanuguages and production_company have null values.

-- Now as you can see four columns of the movie table has null values. Let's look at the at the movies released each year. 
-- Q3. Find the total number of movies released each year? How does the trend look month wise? (Output expected)

/* Output format for the first part:

+---------------+-------------------+
| Year			|	number_of_movies|
+-------------------+----------------
|	2017		|	2134			|
|	2018		|		.			|
|	2019		|		.			|
+---------------+-------------------+


Output format for the second part of the question:
+---------------+-------------------+
|	month_num	|	number_of_movies|
+---------------+----------------
|	1			|	 134			|
|	2			|	 231			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT year, COUNT(id) AS number_of_movies
FROM movie
GROUP BY year;

-- The highest number of movies were produced in the year of 2017

SELECT MONTH(date_published) AS month_num, COUNT(id) AS number_of_movies
FROM movie
GROUP BY MONTH(date_published)
ORDER BY MONTH(date_published);

-- The highest number of movies were produced in month of March


/*The highest number of movies is produced in the month of March.
So, now that you have understood the month-wise trend of movies, let’s take a look at the other details in the movies table. 
We know USA and India produces huge number of movies each year. Lets find the number of movies produced by USA or India for the last year.*/
  
-- Q4. How many movies were produced in the USA or India in the year 2019??
-- Type your code below:

SELECT COUNT(id) AS number_of_movies
FROM movie
WHERE (country LIKE "%USA%" OR country LIKE "%India%") AND year = 2019;

-- 1059 movies were produced in USA or India in 2019

/* USA and India produced more than a thousand movies(you know the exact number!) in the year 2019.
Exploring table Genre would be fun!! 
Let’s find out the different genres in the dataset.*/

-- Q5. Find the unique list of the genres present in the data set?
-- Type your code below:

SELECT DISTINCT genre
FROM genre;

-- There are total 13 unique genres

/* So, RSVP Movies plans to make a movie of one of these genres.
Now, wouldn’t you want to know which genre had the highest number of movies produced in the last year?
Combining both the movie and genres table can give more interesting insights. */

-- Q6.Which genre had the highest number of movies produced overall?
-- Type your code below:

SELECT DISTINCT genre, COUNT(movie_id) AS number_of_movies
FROM genre
GROUP BY genre
ORDER BY COUNT(movie_id) DESC
LIMIT 1;

-- Drama genre has highest number of movies i.e. 4285

/* So, based on the insight that you just drew, RSVP Movies should focus on the ‘Drama’ genre. 
But wait, it is too early to decide. A movie can belong to two or more genres. 
So, let’s find out the count of movies that belong to only one genre.*/

-- Q7. How many movies belong to only one genre?
-- Type your code below:

WITH genre_summary AS(
SELECT movie_id, COUNT(genre) AS genre_count
FROM genre
GROUP BY movie_id
) SELECT COUNT(movie_id) AS number_of_movies_belonging_to_single_genre
FROM genre_summary
WHERE genre_count = 1;

-- There are 3289 movies which only belong to a single genre

/* There are more than three thousand movies which has only one genre associated with them.
So, this figure appears significant. 
Now, let's find out the possible duration of RSVP Movies’ next project.*/

-- Q8.What is the average duration of movies in each genre? 
-- (Note: The same movie can belong to multiple genres.)


/* Output format:

+---------------+-------------------+
| genre			|	avg_duration	|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT g.genre, ROUND(AVG(m.duration),2) AS avg_duration
FROM movie m 
INNER JOIN genre g 
ON m.id = g.movie_id
GROUP BY g.genre
ORDER BY ROUND(AVG(m.duration),2);

-- Drama has an average duration of 106.77 mins and after rounding it 107 mins.

/* Now you know, movies of genre 'Drama' (produced highest in number in 2019) has the average duration of 106.77 mins.
Lets find where the movies of genre 'thriller' on the basis of number of movies.*/

-- Q9.What is the rank of the ‘thriller’ genre of movies among all the genres in terms of number of movies produced? 
-- (Hint: Use the Rank function)

/* Output format:
+---------------+-------------------+---------------------+
| genre			|		movie_count	|		genre_rank    |	
+---------------+-------------------+---------------------+
|drama			|	2312			|			2		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT genre, 
	   COUNT(movie_id) AS movie_count,
       RANK() OVER (ORDER BY COUNT(movie_id) DESC) AS genre_rank
FROM genre
GROUP BY genre;

-- The rank of the thriller genre is 3

/*Thriller movies is in top 3 among all genres in terms of number of movies
 In the previous segment, you analysed the movies and genres tables. 
 In this segment, you will analyse the ratings table as well.
To start with lets get the min and max values of different columns in the table*/



-- Segment 2:



-- Q10.  Find the minimum and maximum values in  each column of the ratings table except the movie_id column?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
| min_avg_rating|	max_avg_rating	|	min_total_votes   |	max_total_votes 	 |min_median_rating|min_median_rating|
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+
|		0		|			5		|	       177		  |	   2000	    		 |		0	       |	8			 |
+---------------+-------------------+---------------------+----------------------+-----------------+-----------------+*/
-- Type your code below:

SELECT ROUND(MIN(avg_rating)) AS min_avg_rating, ROUND(MAX(avg_rating)) AS max_avg_rating, MIN(total_votes) AS min_total_votes, MAX(total_votes) AS max_total_votes, MIN(median_rating) AS min_median_rating, MAX(median_rating) AS max_median_rating 
FROM ratings;
    

/* So, the minimum and maximum values in each column of the ratings table are in the expected range. 
This implies there are no outliers in the table. 
Now, let’s find out the top 10 movies based on average rating.*/

-- Q11. Which are the top 10 movies based on average rating?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		movie_rank    |
+---------------+-------------------+---------------------+
| Fan			|		9.6			|			5	  	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:
-- It's ok if RANK() or DENSE_RANK() is used too

WITH rating_summary AS 
(
SELECT m.title, 
	   r.avg_rating,
       DENSE_RANK() OVER (ORDER BY r.avg_rating DESC) AS movie_rank
FROM
	movie m
    INNER JOIN ratings r ON m.id = r.movie_id
) SELECT *
  FROM rating_summary
  WHERE movie_rank <= 10;
  
  -- Kirket and Love in Kilnerry share the same rank as 1  based on average rating

/* Do you find you favourite movie FAN in the top 10 movies with an average rating of 9.6? If not, please check your code again!!
So, now that you know the top 10 movies, do you think character actors and filler actors can be from these movies?
Summarising the ratings table based on the movie counts by median rating can give an excellent insight.*/

-- Q12. Summarise the ratings table based on the movie counts by median ratings.
/* Output format:

+---------------+-------------------+
| median_rating	|	movie_count		|
+-------------------+----------------
|	1			|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:
-- Order by is good to have

SELECT median_rating, COUNT(movie_id) AS movie_count
FROM ratings
GROUP BY median_rating
ORDER BY COUNT(movie_id) DESC;

-- Median rating of 7 has highest number of movies

/* Movies with a median rating of 7 is highest in number. 
Now, let's find out the production house with which RSVP Movies can partner for its next project.*/

-- Q13. Which production house has produced the most number of hit movies (average rating > 8)??
/* Output format:
+------------------+-------------------+---------------------+
|production_company|movie_count	       |	prod_company_rank|
+------------------+-------------------+---------------------+
| The Archers	   |		1		   |			1	  	 |
+------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company, 
	   COUNT(id) AS movie_count,
       RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_company_rank
FROM movie m INNER JOIN ratings r
	 ON m.id = r.movie_id
WHERE r.avg_rating > 8 AND production_company IS NOT NULL -- In production company there were some null values, hence wrote this condition to ignore those nulls
GROUP BY production_company;

-- Both Dream Warrior Pictures and National Theatre Live production houses have the most number of hits (average rating > 8)

-- It's ok if RANK() or DENSE_RANK() is used too
-- Answer can be Dream Warrior Pictures or National Theatre Live or both

-- Q14. How many movies released in each genre during March 2017 in the USA had more than 1,000 votes?
/* Output format:

+---------------+-------------------+
| genre			|	movie_count		|
+-------------------+----------------
|	thriller	|		105			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT genre, COUNT(id) AS movie_count
FROM genre g INNER JOIN movie m ON g.movie_id = m.id INNER JOIN ratings r ON m.id = r.movie_id
WHERE MONTH(date_published) = 3 AND year = 2017 AND country LIKE "%USA%" AND r.total_votes > 1000
GROUP BY genre
ORDER BY COUNT(id) DESC;

-- Drama genre has maximum number of movies released during March 2017 in the USA with more than 1,000 votes

-- Lets try to analyse with a unique problem statement.
-- Q15. Find movies of each genre that start with the word ‘The’ and which have an average rating > 8?
/* Output format:
+---------------+-------------------+---------------------+
| title			|		avg_rating	|		genre	      |
+---------------+-------------------+---------------------+
| Theeran		|		8.3			|		Thriller	  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
|	.			|		.			|			.		  |
+---------------+-------------------+---------------------+*/
-- Type your code below:

SELECT title, avg_rating, genre
FROM movie m INNER JOIN ratings r ON m.id = r.movie_id INNER JOIN genre g ON m.id = g.movie_id
WHERE title LIKE "The%" AND avg_rating > 8
ORDER BY title;

-- There are close to 9 movies which start with "The" and have an avg_rating>8. We got 15 entries as these movies belong to multi genres.

-- You should also try your hand at median rating and check whether the ‘median rating’ column gives any significant insights.

-- Q16. Of the movies released between 1 April 2018 and 1 April 2019, how many were given a median rating of 8?
-- Type your code below:

SELECT COUNT(*) AS count_of_movies
FROM movie m INNER JOIN ratings r ON m.id = r.movie_id
WHERE date_published BETWEEN '2018-04-01' AND '2019-04-01' AND median_rating = 8;

-- 361 movies were released between 1 April 2018 and 1 April 2019 with a median rating of 8

-- Once again, try to solve the problem given below.
-- Q17. Do German movies get more votes than Italian movies? 
-- Hint: Here you have to find the total number of votes for both German and Italian movies.
-- Type your code below:

SELECT country, SUM(total_votes) AS count_of_votes
FROM movie m INNER JOIN ratings r ON m.id = r.movie_id
GROUP BY country
HAVING country IN ('Germany', 'Italy');

-- Germany movies got 106710 votes which is more than what Italy got i.e. 77965 votes

-- Answer is Yes

/* Now that you have analysed the movies, genres and ratings tables, let us now analyse another table, the names table. 
Let’s begin by searching for null values in the tables.*/



-- Segment 3:



-- Q18. Which columns in the names table have null values??
/*Hint: You can find null values for individual columns or follow below output format
+---------------+-------------------+---------------------+----------------------+
| name_nulls	|	height_nulls	|date_of_birth_nulls  |known_for_movies_nulls|
+---------------+-------------------+---------------------+----------------------+
|		0		|			123		|	       1234		  |	   12345	    	 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

SELECT COUNT(*) - COUNT(name) AS name_nulls, COUNT(*) - COUNT(height) AS height_nulls, COUNT(*) - COUNT(date_of_birth) AS date_of_birth_nulls, COUNT(*) - COUNT(known_for_movies) AS known_for_movies_nulls 
FROM names;


/* There are no Null values in the column 'name'.

The director is the most important person in a movie crew. 

Let’s find out the top three directors in the top three genres who can be hired by RSVP Movies.*/

-- Q19. Who are the top three directors in the top three genres whose movies have an average rating > 8?
-- (Hint: The top three genres would have the most number of movies with an average rating > 8.)
/* Output format:

+---------------+-------------------+
| director_name	|	movie_count		|
+---------------+-------------------|
|James Mangold	|		4			|
|	.			|		.			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

-- Below query is for finding top 3 genres
SELECT genre, count(m.id) AS m_count
FROM genre g INNER JOIN movie m ON g.movie_id = m.id INNER JOIN ratings r ON m.id = r.movie_id
WHERE avg_rating>8
GROUP BY genre
ORDER BY count(m.id) DESC
LIMIT 3;     -- We got Drama, action and comedy as top 3 genres as output


-- Below query is for finding the top 3 directors in the top three genres whose movies have an average rating > 8
SELECT name AS director_name, COUNT(m.id) AS movie_count
FROM names n INNER JOIN director_mapping d ON n.id = d.name_id
	 INNER JOIN movie m ON d.movie_id = m.id
     INNER JOIN ratings r ON m.id = r.movie_id
     INNER JOIN genre g ON m.id = g.movie_id
WHERE avg_rating > 8 AND genre IN ("Drama", "Action", "Comedy")
GROUP BY name
ORDER BY COUNT(m.id) DESC, name
LIMIT 3;

-- James Mangold, Anthony Russo and Joe Russo are the top 3 directors in "Drama", "Action", "Comedy" genres with average rating > 8

/* James Mangold can be hired as the director for RSVP's next project. Do you remember his movies, 'Logan' and 'The Wolverine'. 
Now, let’s find out the top two actors.*/

-- Q20. Who are the top two actors whose movies have a median rating >= 8?
/* Output format:

+---------------+-------------------+
| actor_name	|	movie_count		|
+-------------------+----------------
|Christain Bale	|		10			|
|	.			|		.			|
+---------------+-------------------+ */
-- Type your code below:

SELECT name AS actor_name, COUNT(m.id) AS movie_count
FROM names n INNER JOIN role_mapping ro ON n.id = ro.name_id
	 INNER JOIN movie m ON ro.movie_id = m.id
     INNER JOIN ratings r ON m.id = r.movie_id
WHERE median_rating >= 8 AND category = "actor"
GROUP BY name
ORDER BY COUNT(m.id) DESC
LIMIT 2;

-- Mammootty and Mohanlal are the top two actors whose movies have a median rating >= 8

/* Have you find your favourite actor 'Mohanlal' in the list. If no, please check your code again. 
RSVP Movies plans to partner with other global production houses. 
Let’s find out the top three production houses in the world.*/

-- Q21. Which are the top three production houses based on the number of votes received by their movies?
/* Output format:
+------------------+--------------------+---------------------+
|production_company|vote_count			|		prod_comp_rank|
+------------------+--------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

WITH production_summary AS
(
SELECT production_company, 
	   SUM(total_votes) AS vote_count,
       RANK() OVER(ORDER BY SUM(total_votes) DESC) AS prod_comp_rank
FROM movie m INNER JOIN ratings r
		   ON m.id = r.movie_id
WHERE production_company IS NOT NULL
GROUP BY production_company
) SELECT *
  FROM production_summary
  WHERE prod_comp_rank <= 3;
  
  -- Marvel studios, Twentieth Century Fox and Warner Bros. are the top three production houses based on the number of votes received by their movies

/*Yes Marvel Studios rules the movie world.
So, these are the top three production houses based on the number of votes received by the movies they have produced.

Since RSVP Movies is based out of Mumbai, India also wants to woo its local audience. 
RSVP Movies also wants to hire a few Indian actors for its upcoming project to give a regional feel. 
Let’s find who these actors could be.*/

-- Q22. Rank actors with movies released in India based on their average ratings. Which actor is at the top of the list?
-- Note: The actor should have acted in at least five Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actor_name	|	total_votes		|	movie_count		  |	actor_avg_rating 	 |actor_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Yogi Babu	|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT name AS actor_name, 
	   SUM(total_votes) AS total_votes, 
       COUNT(m.id) AS movie_count, 
       ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) AS actor_avg_rating,
       RANK() OVER(ORDER BY ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) DESC) AS actor_rank
FROM names n INNER JOIN role_mapping ro ON n.id = ro.name_id
	 INNER JOIN movie m ON ro.movie_id = m.id
     INNER JOIN ratings r ON m.id = r.movie_id
WHERE country LIKE "%India%" AND category = "actor"
GROUP BY name
HAVING COUNT(m.id) >= 5;

-- Top actor is Vijay Sethupathi

-- Q23.Find out the top five actresses in Hindi movies released in India based on their average ratings? 
-- Note: The actresses should have acted in at least three Indian movies. 
-- (Hint: You should use the weighted average based on votes. If the ratings clash, then the total number of votes should act as the tie breaker.)
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |	actress_avg_rating 	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Tabu		|			3455	|	       11		  |	   8.42	    		 |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

SELECT name AS actress_name, 
	   SUM(total_votes) AS total_votes,
       COUNT(m.id) AS movie_count,
       ROUND(SUM(avg_rating * total_votes) / SUM(total_votes),2) AS actress_avg_rating,
       RANK() OVER(ORDER BY ROUND(SUM(avg_rating * total_votes) / SUM(total_votes), 2) DESC) AS actress_rank
FROM names n INNER JOIN role_mapping ro ON n.id = ro.name_id
	 INNER JOIN movie m ON ro.movie_id = m.id
     INNER JOIN ratings r ON m.id = r.movie_id
WHERE country LIKE "%India%" AND languages LIKE "%Hindi%" AND category = "actress"
GROUP BY name
HAVING COUNT(m.id) >= 3
LIMIT 5;

-- Taapsee Pannu tops with average rating 7.74.
 
-- Now let us divide all the thriller movies in the following categories and find out their numbers.*/

/* Q24. Select thriller movies as per avg rating and classify them in the following category: 

			Rating > 8: Superhit movies
			Rating between 7 and 8: Hit movies
			Rating between 5 and 7: One-time-watch movies
			Rating < 5: Flop movies
--------------------------------------------------------------------------------------------*/
-- Type your code below:

SELECT DISTINCT title,
	   avg_rating,
	   CASE 
			WHEN avg_rating > 8 THEN "Superhit movies"
            WHEN avg_rating > 7 AND avg_rating <= 8 THEN "Hit movies"
            WHEN avg_rating > 5 AND avg_rating <= 7 THEN "One-time-watch movies"
            ELSE "Flop movies"
		END AS movie_category
FROM genre g INNER JOIN movie m ON g.movie_id = m.id
	         INNER JOIN ratings r ON m.id = r.movie_id
WHERE genre = "thriller";


/* Until now, you have analysed various tables of the data set. 
Now, you will perform some tasks that will give you a broader understanding of the data in this segment.*/



-- Segment 4:



-- Q25. What is the genre-wise running total and moving average of the average movie duration? 
-- (Note: You need to show the output table in the question.) 
/* Output format:
+---------------+-------------------+---------------------+----------------------+
| genre			|	avg_duration	|running_total_duration|moving_avg_duration  |
+---------------+-------------------+---------------------+----------------------+
|	comdy		|			145		|	       106.2	  |	   128.42	    	 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
|		.		|			.		|	       .		  |	   .	    		 |
+---------------+-------------------+---------------------+----------------------+*/
-- Type your code below:

WITH genre_summary AS
(
SELECT genre,
	   AVG(duration) AS avg_duration,
       SUM((AVG(duration))) OVER(ORDER BY genre ROWS UNBOUNDED PRECEDING) AS running_total_duration,
       AVG((AVG(duration))) OVER(ORDER BY genre ROWS 5 PRECEDING) AS moving_avg_duration 
FROM genre g INNER JOIN movie m 
	 ON g.movie_id = m.id
GROUP BY genre
ORDER BY genre
) SELECT genre,
		 ROUND(avg_duration) AS avg_duration,
         ROUND(running_total_duration, 1) AS running_total_duration,
         ROUND(moving_avg_duration, 2) AS moving_avg_duration
  FROM genre_summary;


-- Round is good to have and not a must have; Same thing applies to sorting

-- Let us find top 5 movies of each year with top 3 genres.

-- Q26. Which are the five highest-grossing movies of each year that belong to the top three genres? 
-- (Note: The top 3 genres would have the most number of movies.)

/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| genre			|	year			|	movie_name		  |worldwide_gross_income|movie_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	comedy		|			2017	|	       indian	  |	   $103244842	     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

-- Query for Top 3 Genres based on most number of movies is as follows:
SELECT genre, count(m.id) AS m_count
FROM genre g INNER JOIN movie m ON g.movie_id = m.id INNER JOIN ratings r ON m.id = r.movie_id
GROUP BY genre
ORDER BY count(m.id) DESC
LIMIT 3;     -- We got Drama, comedy and thriller as top 3 genres as output

-- Query for the five highest-grossing movies of each year that belong to the top three genres is as follows:
WITH gross_summary AS
(
SELECT genre,
	   year,
       title as movie_name,
       worlwide_gross_income,
       RANK() OVER(PARTITION BY year ORDER BY worlwide_gross_income DESC) AS movie_rank
FROM genre g INNER JOIN movie m ON g.movie_id = m.id
WHERE genre IN ("Drama", "Comedy", "thriller")
) SELECT *
  FROM gross_summary
  WHERE movie_rank <= 5;
  
-- Finally, let’s find out the names of the top two production houses that have produced the highest number of hits among multilingual movies.

-- Q27.  Which are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies?
/* Output format:
+-------------------+-------------------+---------------------+
|production_company |movie_count		|		prod_comp_rank|
+-------------------+-------------------+---------------------+
| The Archers		|		830			|		1	  		  |
|	.				|		.			|			.		  |
|	.				|		.			|			.		  |
+-------------------+-------------------+---------------------+*/
-- Type your code below:

SELECT production_company,
	   COUNT(id) AS movie_count,
       RANK() OVER(ORDER BY COUNT(id) DESC) AS prod_comp_rank
FROM movie m INNER JOIN ratings r
			 ON m.id = r.movie_id
WHERE median_rating >= 8 AND production_company IS NOT NULL AND POSITION(',' IN languages) > 0
GROUP BY production_company
LIMIT 2;

-- Star Cinema and Twentieth Century Fox are the top two production houses that have produced the highest number of hits (median rating >= 8) among multilingual movies

-- Multilingual is the important piece in the above question. It was created using POSITION(',' IN languages)>0 logic
-- If there is a comma, that means the movie is of more than one language


-- Q28. Who are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre?
/* Output format:
+---------------+-------------------+---------------------+----------------------+-----------------+
| actress_name	|	total_votes		|	movie_count		  |actress_avg_rating	 |actress_rank	   |
+---------------+-------------------+---------------------+----------------------+-----------------+
|	Laura Dern	|			1016	|	       1		  |	   9.60			     |		1	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
|		.		|			.		|	       .		  |	   .	    		 |		.	       |
+---------------+-------------------+---------------------+----------------------+-----------------+*/
-- Type your code below:

WITH actress_summary AS
(
SELECT name AS actress_name,
	   SUM(total_votes) AS total_votes,
       COUNT(m.id) AS movie_count,
       ROUND(AVG(avg_rating),2) AS actress_avg_rating,
       ROW_NUMBER() OVER(ORDER BY COUNT(m.id) DESC) AS actress_rank
FROM names n INNER JOIN role_mapping ro ON n.id = ro.name_id
			 INNER JOIN movie m ON ro.movie_id = m.id
             INNER JOIN ratings r ON m.id = r.movie_id
             INNER JOIN genre g ON m.id = g.movie_id
WHERE genre = "drama" AND category = "actress"
GROUP BY name
HAVING AVG(avg_rating) > 8
) SELECT *
  FROM actress_summary
  WHERE actress_rank <= 3;
  
-- Parvathy Thiruvothu, Adriana Matoshi and Susan Brown are the top 3 actresses based on number of Super Hit movies (average rating >8) in drama genre
  
/* Q29. Get the following details for top 9 directors (based on number of movies)
Director id
Name
Number of movies
Average inter movie duration in days
Average movie ratings
Total votes
Min rating
Max rating
total movie durations

Format:
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
| director_id	|	director_name	|	number_of_movies  |	avg_inter_movie_days |	avg_rating	| total_votes  | min_rating	| max_rating | total_duration |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+
|nm1777967		|	A.L. Vijay		|			5		  |	       177			 |	   5.65	    |	1754	   |	3.7		|	6.9		 |		613		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
|	.			|		.			|			.		  |	       .			 |	   .	    |	.		   |	.		|	.		 |		.		  |
+---------------+-------------------+---------------------+----------------------+--------------+--------------+------------+------------+----------------+

--------------------------------------------------------------------------------------------*/
-- Type you code below:

WITH director_summary AS
(
SELECT name_id,
	   name,
       m.id,
       date_published,
       avg_rating,
       total_votes,
       duration
FROM names n INNER JOIN director_mapping d ON n.id = d.name_id
			 INNER JOIN movie m ON d.movie_id = m.id
             INNER JOIN ratings r ON m.id = r.movie_id
) , final_director_summary AS 
( SELECT *,  DATEDIFF(LEAD(date_published, 1) OVER(PARTITION BY name_id ORDER BY date_published, id), date_published) AS inter_movie_days
	FROM director_summary
) SELECT name_id AS director_id,
		 name AS director_name,
         COUNT(id) AS number_of_movies,
         ROUND(AVG(inter_movie_days)) AS avg_inter_movie_days,
         ROUND(AVG(avg_rating),2) AS avg_rating,
         SUM(total_votes) AS total_votes,
		 MIN(avg_rating) AS min_rating,
         MAX(avg_rating) AS max_rating,
         SUM(duration) AS total_duration
	FROM final_director_summary
    GROUP BY name_id, name
	ORDER BY COUNT(id) DESC
	LIMIT 9;
    
    