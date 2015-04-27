 
/* DISCLAIMER - TABLE ONLY-  I Reformated the script for the tables so that it will work in MS SQL Server,
if you try running it in SQLite it wont work. The answers will still work in both SQL Server and SQLite. */
 
 --Delete the tables if they already exist */
If object_id('Movie') Is Not NUll
	Drop Table Movie
If object_id('Reviewer') Is Not Null
	Drop Table Reviewer
If object_id('Rating') Is Not Null
	Drop Table Rating

/* Create the schema for our tables */
create table Movie(mID int, title varchar(40), year int, director varchar(40));
create table Reviewer(rID int, name varchar(40));
create table Rating(rID int, mID int, stars int, ratingDate date);

/* Populate the tables with our data */
insert into Movie values(101, 'Gone with the Wind', 1939, 'Victor Fleming');
insert into Movie values(102, 'Star Wars', 1977, 'George Lucas');
insert into Movie values(103, 'The Sound of Music', 1965, 'Robert Wise');
insert into Movie values(104, 'E.T.', 1982, 'Steven Spielberg');
insert into Movie values(105, 'Titanic', 1997, 'James Cameron');
insert into Movie values(106, 'Snow White', 1937, null);
insert into Movie values(107, 'Avatar', 2009, 'James Cameron');
insert into Movie values(108, 'Raiders of the Lost Ark', 1981, 'Steven Spielberg');

insert into Reviewer values(201, 'Sarah Martinez');
insert into Reviewer values(202, 'Daniel Lewis');
insert into Reviewer values(203, 'Brittany Harris');
insert into Reviewer values(204, 'Mike Anderson');
insert into Reviewer values(205, 'Chris Jackson');
insert into Reviewer values(206, 'Elizabeth Thomas');
insert into Reviewer values(207, 'James Cameron');
insert into Reviewer values(208, 'Ashley White');

insert into Rating values(201, 101, 2, '2011-01-22');
insert into Rating values(201, 101, 4, '2011-01-27');
insert into Rating values(202, 106, 4, null);
insert into Rating values(203, 103, 2, '2011-01-20');
insert into Rating values(203, 108, 4, '2011-01-12');
insert into Rating values(203, 108, 2, '2011-01-30');
insert into Rating values(204, 101, 3, '2011-01-09');
insert into Rating values(205, 103, 3, '2011-01-27');
insert into Rating values(205, 104, 2, '2011-01-22');
insert into Rating values(205, 108, 4, null);
insert into Rating values(206, 107, 3, '2011-01-15');
insert into Rating values(206, 106, 5, '2011-01-19');
insert into Rating values(207, 107, 5, '2011-01-20');
insert into Rating values(208, 104, 3, '2011-01-02');

/* Excercise Questions */
/* DISCLAIMER: These answers will work in BOTH SQLite and SQL SERVER without changing anything */

--Question 1 Find the titles of all movies directed by Steven Spielberg. 
--Answer
SELECT title FROM Movie
WHERE director = 'Steven Spielberg'

--Question 2 Find all years that have a movie that received a rating of 4 or 5, and sort them in increasing order. 
--Answer
SELECT Distinct year FROM Movie AS M JOIN Rating AS R
ON M.mID = R.mID
WHERE stars >= '4'
order by year

--Question 3 
--Answer Find the titles of all movies that have no ratings. 
SELECT title FROM Movie AS M LEFT JOIN Rating AS R
ON M.mID = R.mID
WHERE stars IS NULL

--Question 4
--Answer Some reviewers didn't provide a date with their rating. Find the names of all reviewers who have ratings with a NULL value for the date
SELECT name FROM Rating AS Ra JOIN Reviewer AS R
ON Ra.rID = R.rID
WHERE ratingDate IS NULL

--Question 5 Write a query to return the ratings data in a more readable format: reviewer name,
--movie title, stars, and ratingDate. Also, sort the data, first by reviewer name, 
--then by movie title, and lastly by number of stars. 
--Answer
SELECT R.name, M.title, Ra.stars,Ra.ratingDate
FROM Movie M JOIN Rating Ra 
ON M.mID=Ra.mID JOIN Reviewer R
ON Ra.rID = R.rID
order by R.name, M.title, Ra.stars

--Question 6 For all cases where the same reviewer rated the same movie twice and gave it a higher rating the second time,
-- return the reviewer's name and the title of the movie.
SELECT name, title 
FROM Movie M JOIN Rating Ra1 ON M.mID = Ra1.mID
JOIN Reviewer R ON Ra1.rID = R.rID
JOIN Rating Ra2 ON Ra1.rID = Ra2.rID
WHERE Ra1.ratingDate > Ra2.ratingDate and Ra1.stars > Ra2.stars and Ra1.mID = Ra2.mID


--Question 7 For each movie that has at least one rating, find the highest number of stars that movie received. 
--Return the movie title and number of stars. Sort by movie title. 
SELECT title, max(Ra.stars) AS [Highest Rating] FROM
Movie M JOIN Rating Ra ON M.mID = Ra.mID
GROUP by title
ORDER by title


--Question 8 For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie.
-- Sort by rating spread from highest to lowest, then by movie title
SELECT M.title , (max(Ra.stars)-min(Ra.stars)) AS [Rating Spread]
FROM Movie M JOIN Rating Ra ON M.mID = Ra.mID
GROUP by title
ORDER by [Rating Spread] DESC

--Question 9 Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980.
--(Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after.
--Don't just calculate the overall average rating before and after 1980.)
SELECT AVG(B.avrg)-AVG(A.avrg) 
FROM (
SELECT AVG(stars) AS avrg
FROM Movie M JOIN Rating Ra ON M.mID = Ra.mID
WHERE year < 1980
GROUP by title) AS B,
(SELECT AVG(stars) AS avrg 
FROM Movie M JOIN Rating Ra ON M.mID = Ra.mID
WHERE year > 1980
GROUP by title) AS A


---------------Added the Movie-Rating Query Extra Exercises----------------

--Question 1 Find the names of all reviewers who rated Gone with the Wind
SELECT DISTINCT name FROM 
Movie M JOIN Rating Ra on M.mID = Ra.mID
JOIN Reviewer R on Ra.rID = R.rID
WHERE title = 'Gone with the Wind'

--Quetsion 2 For any rating where the reviewer is the same as the director of the movie,
--return the reviewer name, movie title, and number of stars.
SELECT name, title, stars FROM 
Movie M JOIN Rating Ra on M.mID = Ra.mID
JOIN Reviewer R on Ra.rID = R.rID
WHERE name = director 

--Question 3 Return all reviewer names and movie names together in a single list, alphabetized.
--Sorting by the first name of the reviewer and first word in the title is fine;
--no need for special processing on last names or removing "The".) 
SELECT name FROM Reviewer
UNION
SELECT title FROM Movie
Order by name, title

--Question 4 Find the titles of all movies not reviewed by Chris Jackson. 
SELECT title FROM Movie
WHERE mID NOT IN (SELECT mID
FROM Rating
WHERE rID IN 
(select rID
FROM Reviewer
WHERE name = "Chris Jackson") )

--Question 5 For all pairs of reviewers such that both reviewers gave a rating to the same movie,
--return the names of both reviewers. Eliminate duplicates, don't pair reviewers with themselves,
--and include each pair only once. For each pair, return the names in the pair in alphabetical order. 

--Question 6 For each rating that is the lowest (fewest stars) currently in the database, return the reviewer name,
--movie title, and number of stars. 


--Quesetion 7 List movie titles and average ratings, from highest-rated to lowest-rated. 
--If two or more movies have the same average rating, list them in alphabetical order

--Question 8 Find the names of all reviewers who have contributed three or more ratings.
--(As an extra challenge, try writing the query without HAVING or without COUNT.) 

--Question 9 Some directors directed more than one movie. For all such directors, return the titles of all movies directed
--by them, along with the director name. Sort by director name, then movie title.
--(As an extra challenge, try writing the query both with and without COUNT.) 

--Question 10

--Question 11

--Question 12
