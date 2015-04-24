 
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


--Question 7 For each movie that has at least one rating, find the highest number of stars that movie received. 
--Return the movie title and number of stars. Sort by movie title. 

--Question 8 For each movie, return the title and the 'rating spread', that is, the difference between highest and lowest ratings given to that movie.
-- Sort by rating spread from highest to lowest, then by movie title

--Question 9 Find the difference between the average rating of movies released before 1980 and the average rating of movies released after 1980.
--(Make sure to calculate the average rating for each movie, then the average of those averages for movies before 1980 and movies after.
--Don't just calculate the overall average rating before and after 1980.)
