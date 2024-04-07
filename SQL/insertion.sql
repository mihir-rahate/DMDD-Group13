USE master;
GO
DROP DATABASE IF EXISTS ttms2;
GO
CREATE DATABASE ttms2;
GO
USE ttms2;
GO

--- 0. About Encryption
IF EXISTS (
    SELECT name KeyName,
    symmetric_key_id KeyID,
    key_length KeyLength,
    algorithm_desc KeyAlgorithm
    FROM sys.symmetric_keys
)
BEGIN
    DROP SYMMETRIC KEY UserPasswordKey;
    DROP CERTIFICATE UserPasswordCertificate;
    DROP MASTER KEY;
END

CREATE MASTER KEY ENCRYPTION BY PASSWORD = 'v%c*S_%&1CLH%$Srr-FvQ6cCN~>hVh_Jp0VKaSnc7/lWeBz{V,[>IRNMj*]kPFMH';

 
CREATE CERTIFICATE UserPasswordCertificate
    WITH SUBJECT = 'User Passwords For TTMS';
GO

CREATE SYMMETRIC KEY UserPasswordKey
    WITH ALGORITHM = AES_256
    ENCRYPTION BY CERTIFICATE UserPasswordCertificate;
GO

--- 1. About Users

DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id INT PRIMARY KEY IDENTITY(1,1),
    username VARCHAR(50) NOT NULL UNIQUE,
    displayName VARCHAR(50) NOT NULL,
    password_encrypted VARBINARY(512) NOT NULL,
    phone VARCHAR(15) NOT NULL,
    [role] VARCHAR(25) NOT NULL CONSTRAINT role_ck CHECK (role IN ('Customer', 'Clerk', 'Manager')),
    isActivated BIT NOT NULL DEFAULT 1 -- 0: not activated, 1: activated
);
OPEN SYMMETRIC KEY UserPasswordKey 
DECRYPTION BY CERTIFICATE UserPasswordCertificate;


-- Insert 10 Customers
INSERT INTO users (username, displayName, password_encrypted, phone, [role]) VALUES
('customer01', 'Customer One', EncryptByKey(Key_GUID('UserPasswordKey'), 'custPass01'), '555-2001', 'Customer'),
('customer02', 'Customer Two', EncryptByKey(Key_GUID('UserPasswordKey'), 'custPass02'), '555-2002', 'Customer'),
('customer03', 'Customer Three', EncryptByKey(Key_GUID('UserPasswordKey'), 'custPass03'), '555-2003', 'Customer'),
('customer04', 'Customer four', EncryptByKey(Key_GUID('UserPasswordKey'), 'custPass04'), '555-2004', 'Customer'),
('customer05', 'Customer five', EncryptByKey(Key_GUID('UserPasswordKey'), 'custPass05'), '555-2005', 'Customer'),
('customer06', 'Customer six', EncryptByKey(Key_GUID('UserPasswordKey'), 'custPass06'), '555-2006', 'Customer'),
('customer07', 'Customer seven', EncryptByKey(Key_GUID('UserPasswordKey'), 'custPass07'), '555-2007', 'Customer'),
('customer08', 'Customer eight', EncryptByKey(Key_GUID('UserPasswordKey'), 'custPass08'), '555-2008', 'Customer'),
('customer09', 'Customer nine', EncryptByKey(Key_GUID('UserPasswordKey'), 'custPass09'), '555-2009', 'Customer'),
('customer10', 'Customer ten', EncryptByKey(Key_GUID('UserPasswordKey'), 'custPass10'), '555-2010', 'Customer'),

-- Add similar lines for customers 03 to 10

-- Insert 10 Clerks
('clerk01', 'Clerk One', EncryptByKey(Key_GUID('UserPasswordKey'), 'clerkPass01'), '555-3001', 'Clerk'),
('clerk02', 'Clerk Two', EncryptByKey(Key_GUID('UserPasswordKey'), 'clerkPass02'), '555-3002', 'Clerk'),
('clerk03', 'Clerk Three', EncryptByKey(Key_GUID('UserPasswordKey'), 'clerkPass03'), '555-3003', 'Clerk'),
('clerk04', 'Clerk four', EncryptByKey(Key_GUID('UserPasswordKey'), 'clerkPass04'), '555-3004', 'Clerk'),
('clerk05', 'Clerk five', EncryptByKey(Key_GUID('UserPasswordKey'), 'clerkPass05'), '555-3005', 'Clerk'),
('clerk06', 'Clerk six', EncryptByKey(Key_GUID('UserPasswordKey'), 'clerkPass06'), '555-3006', 'Clerk'),
('clerk07', 'Clerk seven', EncryptByKey(Key_GUID('UserPasswordKey'), 'clerkPass07'), '555-3007', 'Clerk'),
('clerk08', 'Clerk eight', EncryptByKey(Key_GUID('UserPasswordKey'), 'clerkPass08'), '555-3008', 'Clerk'),
('clerk09', 'Clerk nine', EncryptByKey(Key_GUID('UserPasswordKey'), 'clerkPass09'), '555-3009', 'Clerk'),
('clerk10', 'Clerk ten', EncryptByKey(Key_GUID('UserPasswordKey'), 'clerkPass10'), '555-3010', 'Clerk'),

-- Add similar lines for clerks 03 to 10

-- Insert 10 Managers
('manager01', 'Manager One', EncryptByKey(Key_GUID('UserPasswordKey'), 'managerPass01'), '555-4001', 'Manager'),
('manager02', 'Manager Two', EncryptByKey(Key_GUID('UserPasswordKey'), 'managerPass02'), '555-4002', 'Manager'),
('manager03', 'Manager Three', EncryptByKey(Key_GUID('UserPasswordKey'), 'managerPass03'), '555-4003', 'Manager'),
('manager04', 'Manager four', EncryptByKey(Key_GUID('UserPasswordKey'), 'managerPass04'), '555-4004', 'Manager'),
('manager05', 'Manager five', EncryptByKey(Key_GUID('UserPasswordKey'), 'managerPass05'), '555-4005', 'Manager'),
('manager06', 'Manager six', EncryptByKey(Key_GUID('UserPasswordKey'), 'managerPass06'), '555-4006', 'Manager'),
('manager07', 'Manager seven', EncryptByKey(Key_GUID('UserPasswordKey'), 'managerPass07'), '555-4007', 'Manager'),
('manager08', 'Manager eight', EncryptByKey(Key_GUID('UserPasswordKey'), 'managerPass08'), '555-4008', 'Manager'),
('manager09', 'Manager nine', EncryptByKey(Key_GUID('UserPasswordKey'), 'managerPass09'), '555-4009', 'Manager'),
('manager10', 'Manager ten', EncryptByKey(Key_GUID('UserPasswordKey'), 'managerPass10'), '555-4010', 'Manager')

-- Add similar lines for managers 03 to 10

-- Close the symmetric key after use
CLOSE SYMMETRIC KEY UserPasswordKey;





SELECT * FROM users




DROP TABLE IF EXISTS users_customers;
CREATE TABLE users_customers (
    customer_id INT PRIMARY KEY FOREIGN KEY (customer_id) REFERENCES users(id),
    isVIP BIT NOT NULL DEFAULT 0, -- 0: not VIP, 1: VIP
    dateOfMembership DATE NOT NULL DEFAULT GETDATE()
);

INSERT INTO users_customers (customer_id, isVIP, dateOfMembership) VALUES
(5, 0, '2023-04-01'), -- Non-VIP, Membership starts April 1, 2023
(6, 1, '2023-04-02'), -- VIP, Membership starts April 2, 2023
(7, 0, '2023-04-03'),
(8, 1, '2023-04-04'),
(9, 0, '2023-04-05'),
(10, 1, '2023-04-06'),
(11, 0, '2023-04-07'),
(12, 1, '2023-04-08'),
(13, 0, '2023-04-09'),
(14, 1, '2023-04-10'); -- Alternating VIP status for demonstration

SELECT * FROM users_customers

DROP TABLE IF EXISTS users_managers;
CREATE TABLE users_managers (
    manager_id INT PRIMARY KEY FOREIGN KEY (manager_id) REFERENCES users(id),
    salary FLOAT NOT NULL,
    dateOfEmployment DATE NOT NULL DEFAULT GETDATE()
);

INSERT INTO users_managers (manager_id, salary, dateOfEmployment) VALUES
(25, 60000, '2023-01-01'),
(26, 62000, '2023-01-02'),
(27, 63000, '2023-01-03'),
(28, 64000, '2023-01-04'),
(29, 65000, '2023-01-05'),
(30, 66000, '2023-01-06'),
(31, 67000, '2023-01-07'),
(32, 68000, '2023-01-08'),
(33, 69000, '2023-01-09'),
(34, 70000, '2023-01-10');


SELECT * FROM users_managers


DROP TABLE IF EXISTS users_clerks;
CREATE TABLE users_clerks (
    customer_id INT PRIMARY KEY FOREIGN KEY (customer_id) REFERENCES users(id),
    dateOfEmployment DATE NOT NULL DEFAULT GETDATE(),
    salary FLOAT NOT NULL,
    answersToManagerID INT FOREIGN KEY (answersToManagerID) REFERENCES users_managers(manager_id)
);

INSERT INTO users_clerks (customer_id, dateOfEmployment, salary, answersToManagerID) VALUES
(5, '2023-02-01', 45000, 25),
(6, '2023-02-02', 45500, 26),
(7, '2023-02-03', 46000, 27),
(8, '2023-02-04', 46500, 28),
(9, '2023-02-05', 47000, 29),
(10, '2023-02-06', 47500, 30),
(11, '2023-02-07', 48000, 31),
(12, '2023-02-08', 48500, 32),
(13, '2023-02-09', 49000, 33),
(14, '2023-02-10', 49500, 34);


SELECT * FROM users_clerks


--- 2. About Movies
DROP TABLE IF EXISTS movies;
CREATE TABLE movies (
    movie_id INT PRIMARY KEY IDENTITY(1,1),
    movie_name VARCHAR(255) NOT NULL,
    duration INT NOT NULL, -- in minutes
    age_rating VARCHAR(10) NOT NULL CONSTRAINT age_rating_ck CHECK (age_rating IN ('G', 'PG', 'PG-13', 'R', 'NC-17'))
);

INSERT INTO movies (movie_name, duration, age_rating) VALUES
('Inception', 148, 'PG-13'),
('The Shawshank Redemption', 142, 'R'),
('Toy Story', 81, 'G'),
('The Godfather', 175, 'R'),
('The Dark Knight', 152, 'PG-13'),
('The Lion King', 88, 'G'),
('Pulp Fiction', 154, 'R'),
('Forrest Gump', 142, 'PG-13'),
('Spirited Away', 125, 'PG'),
('Interstellar', 169, 'PG-13');


SELECT * from movies

--- 2.1 About Actors
DROP TABLE IF EXISTS actors;
CREATE TABLE actors (
    actor_id INT PRIMARY KEY IDENTITY(1,1),
    actor_name VARCHAR(255) NOT NULL,
    bio TEXT
);

INSERT INTO actors (actor_name, bio) VALUES
('Leonardo DiCaprio', 'An American actor known for his versatile performances in various film genres.'),
('Meryl Streep', 'An acclaimed American actress known for her ability in adapting to a wide range of roles.'),
('Tom Hanks', 'An American actor and filmmaker, recognized for both his comedic and dramatic roles.'),
('Denzel Washington', 'An American actor, director, and producer, known for his performances in drama films.'),
('Kate Winslet', 'A British actress known for her work in independent films, particularly period dramas, and for her portrayal of strong-willed women.'),
('Morgan Freeman', 'An American actor, director, and narrator known for his distinctive deep voice and authoritative presence in a variety of roles.'),
('Cate Blanchett', 'An Australian actress known for her roles in both blockbusters and independent films.'),
('Daniel Day-Lewis', 'A retired English actor known for his method acting and dedication to his roles.'),
('Natalie Portman', 'An actress and filmmaker with dual Israeli and American citizenship, known for her versatility and roles in both blockbusters and independent films.'),
('Christian Bale', 'An English actor known for his intense method acting and ability to physically transform for his roles.');


SELECT * FROM actors

DROP TABLE IF EXISTS movies_actors;
CREATE TABLE movies_actors (
    movie_id INT FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
    actor_id INT FOREIGN KEY (actor_id) REFERENCES actors(actor_id),
    PRIMARY KEY (movie_id, actor_id)
);

INSERT INTO movies_actors (movie_id, actor_id) VALUES
-- Assuming 'Inception' has movie_id 1 and 'Leonardo DiCaprio' has actor_id 1
(1, 1),
-- Assuming 'The Iron Lady' might be movie_id 2 for demonstration and 'Meryl Streep' has actor_id 2
(2, 2),
-- 'Forrest Gump' might be movie_id 8 and 'Tom Hanks' has actor_id 3
(8, 3),
-- Adding more pairings based on fictional movie_id values and the inserted actor_id values
(3, 4), -- 'Training Day' with 'Denzel Washington'
(5, 5), -- 'Titanic' with 'Kate Winslet'
(4, 6), -- 'Shawshank Redemption' with 'Morgan Freeman'
(6, 7), -- 'Elizabeth' with 'Cate Blanchett'
(7, 8), -- 'Lincoln' with 'Daniel Day-Lewis'
(9, 9), -- 'Black Swan' with 'Natalie Portman'
(10, 10); -- 'The Machinist' with 'Christian Bale'


SELECT * FROM movies_actors

--- 2.2 About Genres
DROP TABLE IF EXISTS genres;
CREATE TABLE genres (
    genre_id INT PRIMARY KEY IDENTITY(1,1),
    genre_name VARCHAR(255) NOT NULL
);

INSERT INTO genres (genre_name) VALUES
('Action'),
('Comedy'),
('Drama'),
('Fantasy'),
('Horror'),
('Romance'),
('Science Fiction'),
('Thriller'),
('Documentary'),
('Animation');


select * from genres

DROP TABLE IF EXISTS movies_genres;
CREATE TABLE movies_genres (
    movie_id INT FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
    genre_id INT FOREIGN KEY (genre_id) REFERENCES genres(genre_id),
    PRIMARY KEY (movie_id, genre_id)
);

INSERT INTO movies_genres (movie_id, genre_id) VALUES
-- Assuming 'Inception' is movie_id 1 and 'Science Fiction' is genre_id 7
(1, 7),
-- 'The Shawshank Redemption' as movie_id 2 and 'Drama' as genre_id 3
(2, 3),
-- 'Toy Story' as movie_id 3 and 'Animation' as genre_id 10
(3, 10),
-- 'The Godfather' as movie_id 4 and 'Drama' as genre_id 3
(4, 3),
-- 'The Dark Knight' as movie_id 5 and 'Action' as genre_id 1
(5, 1),
-- 'The Lion King' as movie_id 6 and 'Animation' as genre_id 10
(6, 10),
-- 'Pulp Fiction' as movie_id 7 and 'Thriller' as genre_id 8
(7, 8),
-- 'Forrest Gump' as movie_id 8 and 'Drama' as genre_id 3
(8, 3),
-- 'Spirited Away' as movie_id 9 and 'Fantasy' as genre_id 4
(9, 4),
-- 'Interstellar' as movie_id 10 and 'Science Fiction' as genre_id 7
(10, 7);


select * from movies_genres


--- 3. About Studios
DROP TABLE IF EXISTS studios;
CREATE TABLE studios (
    studio_id INT PRIMARY KEY IDENTITY(1,1),
    studio_name VARCHAR(255) NOT NULL,
    screen_type VARCHAR(255) NOT NULL CONSTRAINT screen_type_ck CHECK (screen_type IN ('2D', '3D', '4D')),
);

INSERT INTO studios (studio_name, screen_type) VALUES
('Grand Palace Cinema', '2D'),
('OrbitView Theater', '3D'),
('Immersive Experience Arena', '4D'),
('Classic Cinema Hall', '2D'),
('Future Films Complex', '3D'),
('Virtual Reality Pavilion', '4D'),
('Downtown Movie House', '2D'),
('Panoramic Views Studio', '3D'),
('Retro Film Center', '2D'),
('NextGen Cinematic Sphere', '4D');

select * from studios


--- 3.1 About Seats
DROP TABLE IF EXISTS seats;
CREATE TABLE seats (
    seat_id INT PRIMARY KEY IDENTITY(1,1),
    studio_id INT FOREIGN KEY (studio_id) REFERENCES studios(studio_id),
    seat_row INT NOT NULL,
    seat_column INT NOT NULL,
);

INSERT INTO seats (studio_id, seat_row, seat_column) VALUES
-- For Studio 1
(1, 1, 1), (1, 1, 2), (1, 1, 3), (1, 1, 4), (1, 1, 5), (1, 1, 6), (1, 1, 7), (1, 1, 8), (1, 1, 9), (1, 1, 10),
(1, 2, 1), (1, 2, 2), (1, 2, 3), (1, 2, 4), (1, 2, 5), (1, 2, 6), (1, 2, 7), (1, 2, 8), (1, 2, 9), (1, 2, 10),
(1, 3, 1), (1, 3, 2), (1, 3, 3), (1, 3, 4), (1, 3, 5), (1, 3, 6), (1, 3, 7), (1, 3, 8), (1, 3, 9), (1, 3, 10),
(1, 4, 1), (1, 4, 2), (1, 4, 3), (1, 4, 4), (1, 4, 5), (1, 4, 6), (1, 4, 7), (1, 4, 8), (1, 4, 9), (1, 4, 10),
(1, 5, 1), (1, 5, 2), (1, 5, 3), (1, 5, 4), (1, 5, 5), (1, 5, 6), (1, 5, 7), (1, 5, 8), (1, 5, 9), (1, 5, 10),
-- Repeat similar INSERT statements for other studios, adjusting the studio_id for each
-- For Studio 2
-- Continuing for Studio 2
(2, 1, 1), (2, 1, 2), (2, 1, 3), (2, 1, 4), (2, 1, 5), (2, 1, 6), (2, 1, 7), (2, 1, 8), (2, 1, 9), (2, 1, 10),
(2, 2, 1), (2, 2, 2), (2, 2, 3), (2, 2, 4), (2, 2, 5), (2, 2, 6), (2, 2, 7), (2, 2, 8), (2, 2, 9), (2, 2, 10),
(2, 3, 1), (2, 3, 2), (2, 3, 3), (2, 3, 4), (2, 3, 5), (2, 3, 6), (2, 3, 7), (2, 3, 8), (2, 3, 9), (2, 3, 10),
(2, 4, 1), (2, 4, 2), (2, 4, 3), (2, 4, 4), (2, 4, 5), (2, 4, 6), (2, 4, 7), (2, 4, 8), (2, 4, 9), (2, 4, 10),
(2, 5, 1), (2, 5, 2), (2, 5, 3), (2, 5, 4), (2, 5, 5), (2, 5, 6), (2, 5, 7), (2, 5, 8), (2, 5, 9), (2, 5, 10),

-- Starting point for Studio 3
(3, 1, 1), (3, 1, 2), (3, 1, 3), (3, 1, 4), (3, 1, 5), (3, 1, 6), (3, 1, 7), (3, 1, 8), (3, 1, 9), (3, 1, 10),
(3, 2, 1), (3, 2, 2), (3, 2, 3), (3, 2, 4), (3, 2, 5), (3, 2, 6), (3, 2, 7), (3, 2, 8), (3, 2, 9), (3, 2, 10),
(3, 3, 1), (3, 3, 2), (3, 3, 3), (3, 3, 4), (3, 3, 5), (3, 3, 6), (3, 3, 7), (3, 3, 8), (3, 3, 9), (3, 3, 10),
(3, 4, 1), (3, 4, 2), (3, 4, 3), (3, 4, 4), (3, 4, 5), (3, 4, 6), (3, 4, 7), (3, 4, 8), (3, 4, 9), (3, 4, 10),
(3, 5, 1), (3, 5, 2), (3, 5, 3), (3, 5, 4), (3, 5, 5), (3, 5, 6), (3, 5, 7), (3, 5, 8), (3, 5, 9), (3, 5, 10),

--Studio 4
(4, 1, 1), (4, 1, 2), (4, 1, 3), (4, 1, 4), (4, 1, 5), (4, 1, 6), (4, 1, 7), (4, 1, 8), (4, 1, 9), (4, 1, 10),
(4, 2, 1), (4, 2, 2), (4, 2, 3), (4, 2, 4), (4, 2, 5), (4, 2, 6), (4, 2, 7), (4, 2, 8), (4, 2, 9), (4, 2, 10),
(4, 3, 1), (4, 3, 2), (4, 3, 3), (4, 3, 4), (4, 3, 5), (4, 3, 6), (4, 3, 7), (4, 3, 8), (4, 3, 9), (4, 3, 10),
(4, 4, 1), (4, 4, 2), (4, 4, 3), (4, 4, 4), (4, 4, 5), (4, 4, 6), (4, 4, 7), (4, 4, 8), (4, 4, 9), (4, 4, 10),
(4, 5, 1), (4, 5, 2), (4, 5, 3), (4, 5, 4), (4, 5, 5), (4, 5, 6), (4, 5, 7), (4, 5, 8), (4, 5, 9), (4, 5, 10),

--Studio 5
(5, 1, 1), (5, 1, 2), (5, 1, 3), (5, 1, 4), (5, 1, 5), (5, 1, 6), (5, 1, 7), (5, 1, 8), (5, 1, 9), (5, 1, 10),
(5, 2, 1), (5, 2, 2), (5, 2, 3), (5, 2, 4), (5, 2, 5), (5, 2, 6), (5, 2, 7), (5, 2, 8), (5, 2, 9), (5, 2, 10),
(5, 3, 1), (5, 3, 2), (5, 3, 3), (5, 3, 4), (5, 3, 5), (5, 3, 6), (5, 3, 7), (5, 3, 8), (5, 3, 9), (5, 3, 10),
(5, 4, 1), (5, 4, 2), (5, 4, 3), (5, 4, 4), (5, 4, 5), (5, 4, 6), (5, 4, 7), (5, 4, 8), (5, 4, 9), (5, 4, 10),
(5, 5, 1), (5, 5, 2), (5, 5, 3), (5, 5, 4), (5, 5, 5), (5, 5, 6), (5, 5, 7), (5, 5, 8), (5, 5, 9), (5, 5, 10),

-- For Studio 6
(6, 1, 1), (6, 1, 2), (6, 1, 3), (6, 1, 4), (6, 1, 5), (6, 1, 6), (6, 1, 7), (6, 1, 8), (6, 1, 9), (6, 1, 10),
(6, 2, 1), (6, 2, 2), (6, 2, 3), (6, 2, 4), (6, 2, 5), (6, 2, 6), (6, 2, 7), (6, 2, 8), (6, 2, 9), (6, 2, 10),
(6, 3, 1), (6, 3, 2), (6, 3, 3), (6, 3, 4), (6, 3, 5), (6, 3, 6), (6, 3, 7), (6, 3, 8), (6, 3, 9), (6, 3, 10),
(6, 4, 1), (6, 4, 2), (6, 4, 3), (6, 4, 4), (6, 4, 5), (6, 4, 6), (6, 4, 7), (6, 4, 8), (6, 4, 9), (6, 4, 10),
(6, 5, 1), (6, 5, 2), (6, 5, 3), (6, 5, 4), (6, 5, 5), (6, 5, 6), (6, 5, 7), (6, 5, 8), (6, 5, 9), (6, 5, 10),

-- For Studio 7
(7, 1, 1), (7, 1, 2), (7, 1, 3), (7, 1, 4), (7, 1, 5), (7, 1, 6), (7, 1, 7), (7, 1, 8), (7, 1, 9), (7, 1, 10),
(7, 2, 1), (7, 2, 2), (7, 2, 3), (7, 2, 4), (7, 2, 5), (7, 2, 6), (7, 2, 7), (7, 2, 8), (7, 2, 9), (7, 2, 10),
(7, 3, 1), (7, 3, 2), (7, 3, 3), (7, 3, 4), (7, 3, 5), (7, 3, 6), (7, 3, 7), (7, 3, 8), (7, 3, 9), (7, 3, 10),
(7, 4, 1), (7, 4, 2), (7, 4, 3), (7, 4, 4), (7, 4, 5), (7, 4, 6), (7, 4, 7), (7, 4, 8), (7, 4, 9), (7, 4, 10),
(7, 5, 1), (7, 5, 2), (7, 5, 3), (7, 5, 4), (7, 5, 5), (7, 5, 6), (7, 5, 7), (7, 5, 8), (7, 5, 9), (7, 5, 10),
-- For Studio 8
(8, 1, 1), (8, 1, 2), (8, 1, 3), (8, 1, 4), (8, 1, 5), (8, 1, 6), (8, 1, 7), (8, 1, 8), (8, 1, 9), (8, 1, 10),
(8, 2, 1), (8, 2, 2), (8, 2, 3), (8, 2, 4), (8, 2, 5), (8, 2, 6), (8, 2, 7), (8, 2, 8), (8, 2, 9), (8, 2, 10),
(8, 3, 1), (8, 3, 2), (8, 3, 3), (8, 3, 4), (8, 3, 5), (8, 3, 6), (8, 3, 7), (8, 3, 8), (8, 3, 9), (8, 3, 10),
(8, 4, 1), (8, 4, 2), (8, 4, 3), (8, 4, 4), (8, 4, 5), (8, 4, 6), (8, 4, 7), (8, 4, 8), (8, 4, 9), (8, 4, 10),
(8, 5, 1), (8, 5, 2), (8, 5, 3), (8, 5, 4), (8, 5, 5), (8, 5, 6), (8, 5, 7), (8, 5, 8), (8, 5, 9), (8, 5, 10),
-- For Studio 9
(9, 1, 1), (9, 1, 2), (9, 1, 3), (9, 1, 4), (9, 1, 5), (9, 1, 6), (9, 1, 7), (9, 1, 8), (9, 1, 9), (9, 1, 10),
(9, 2, 1), (9, 2, 2), (9, 2, 3), (9, 2, 4), (9, 2, 5), (9, 2, 6), (9, 2, 7), (9, 2, 8), (9, 2, 9), (9, 2, 10),
(9, 3, 1), (9, 3, 2), (9, 3, 3), (9, 3, 4), (9, 3, 5), (9, 3, 6), (9, 3, 7), (9, 3, 8), (9, 3, 9), (9, 3, 10),
(9, 4, 1), (9, 4, 2), (9, 4, 3), (9, 4, 4), (9, 4, 5), (9, 4, 6), (9, 4, 7), (9, 4, 8), (9, 4, 9), (9, 4, 10),
(9, 5, 1), (9, 5, 2), (9, 5, 3), (9, 5, 4), (9, 5, 5), (9, 5, 6), (9, 5, 7), (9, 5, 8), (9, 5, 9), (9, 5, 10),
-- For Studio 10
(10, 1, 1), (10, 1, 2), (10, 1, 3), (10, 1, 4), (10, 1, 5), (10, 1, 6), (10, 1, 7), (10, 1, 8), (10, 1, 9), (10, 1, 10),
(10, 2, 1), (10, 2, 2), (10, 2, 3), (10, 2, 4), (10, 2, 5), (10, 2, 6), (10, 2, 7), (10, 2, 8), (10, 2, 9), (10, 2, 10),
(10, 3, 1), (10, 3, 2), (10, 3, 3), (10, 3, 4), (10, 3, 5), (10, 3, 6), (10, 3, 7), (10, 3, 8), (10, 3, 9), (10, 3, 10),
(10, 4, 1), (10, 4, 2), (10, 4, 3), (10, 4, 4), (10, 4, 5), (10, 4, 6), (10, 4, 7), (10, 4, 8), (10, 4, 9), (10, 4, 10),
(10, 5, 1), (10, 5, 2), (10, 5, 3), (10, 5, 4), (10, 5, 5), (10, 5, 6), (10, 5, 7), (10, 5, 8), (10, 5, 9), (10, 5, 10);



select * from seats

--- 4. About Transactions
DROP TABLE IF EXISTS transactions;
CREATE TABLE transactions (
    payment_id INT PRIMARY KEY IDENTITY(1,1),
    user_id INT FOREIGN KEY (user_id) REFERENCES users(id),
    amount FLOAT NOT NULL,
    payment_method VARCHAR(255) NOT NULL CONSTRAINT payment_method_ck CHECK (payment_method IN ('Credit Card', 'Debit Card', 'Cash')),
    payment_time DATETIME NOT NULL DEFAULT GETDATE()
);

INSERT INTO transactions (user_id, amount, payment_method, payment_time) VALUES
(5, 15.99, 'Credit Card', '2023-10-01 14:00:00'),
(6, 9.99, 'Debit Card', '2023-10-01 14:30:00'),
(7, 19.99, 'Cash', '2023-10-02 10:00:00'),
(8, 12.99, 'Credit Card', '2023-10-02 11:00:00'),
(9, 22.50, 'Debit Card', '2023-10-03 15:45:00'),
(10, 18.25, 'Cash', '2023-10-04 09:30:00'),
(11, 5.99, 'Credit Card', '2023-10-04 16:15:00'),
(12, 29.99, 'Debit Card', '2023-10-05 17:00:00'),
(13, 3.50, 'Cash', '2023-10-06 08:20:00'),
(14, 10.00, 'Credit Card', '2023-10-07 13:50:00');


select * from transactions


--- 5. About Schedules and Tickets
DROP TABLE IF EXISTS schedules;
CREATE TABLE schedules (
    schedule_id INT PRIMARY KEY IDENTITY(1,1),
    movie_id INT FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
    studio_id INT FOREIGN KEY (studio_id) REFERENCES studios(studio_id),
    start_time DATETIME NOT NULL,
    end_time DATETIME NOT NULL,
    price FLOAT NOT NULL,
);

INSERT INTO schedules (movie_id, studio_id, start_time, end_time, price) VALUES
(1, 1, '2023-10-10 12:00:00', '2023-10-10 14:30:00', 10.00),
(2, 2, '2023-10-10 15:00:00', '2023-10-10 17:30:00', 12.50),
(3, 3, '2023-10-11 12:00:00', '2023-10-11 14:00:00', 9.00),
(4, 4, '2023-10-11 15:00:00', '2023-10-11 17:45:00', 11.00),
(5, 5, '2023-10-12 12:00:00', '2023-10-12 14:20:00', 10.50),
(6, 1, '2023-10-12 15:00:00', '2023-10-12 16:50:00', 8.50),
(7, 2, '2023-10-13 12:00:00', '2023-10-13 14:15:00', 12.00),
(8, 3, '2023-10-13 15:00:00', '2023-10-13 17:30:00', 13.00),
(9, 4, '2023-10-14 12:00:00', '2023-10-14 14:10:00', 9.50),
(10, 5, '2023-10-14 15:00:00', '2023-10-14 17:40:00', 14.00);


select * from schedules


DROP TABLE IF EXISTS tickets;
CREATE TABLE tickets (
    ticket_id INT PRIMARY KEY IDENTITY(1,1),
    schedule_id INT FOREIGN KEY (schedule_id) REFERENCES schedules(schedule_id),
    seat_id INT FOREIGN KEY (seat_id) REFERENCES seats(seat_id),
    user_id INT FOREIGN KEY (user_id) REFERENCES users(id), -- if customer_id, then it is booked by customer, if clerk_id, then it is booked by clerk, if manager_id, then it is booked by manager
    ticket_status VARCHAR(255) NOT NULL CONSTRAINT ticket_status_ck CHECK (ticket_status IN ('Booked', 'Cancelled', 'Available')),
    payment_id INT FOREIGN KEY (payment_id) REFERENCES transactions(payment_id),
);

INSERT INTO tickets (schedule_id, seat_id, user_id, ticket_status, payment_id) VALUES
(1, 1, 5, 'Booked', 1),
(1, 2, 6, 'Booked', 2),
(2, 11,7, 'Cancelled', NULL),
(2, 12, 8, 'Booked', 3),
(3, 21, 9, 'Available', NULL),
(3, 22, 10, 'Booked', 4),
(4, 31, 11, 'Cancelled', NULL),
(4, 32, 12, 'Booked', 5),
(5, 41, 13, 'Available', NULL),
(5, 42, 14, 'Booked', 6);


select * from tickets


--- 6. About Customer's Special Functionalities
DROP TABLE IF EXISTS customer_feedbacks;
CREATE TABLE customer_feedbacks (
    id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT FOREIGN KEY (customer_id) REFERENCES users_customers(customer_id),
    comment VARCHAR(255) NOT NULL,
    dateAndTime DATETIME NOT NULL
);

INSERT INTO customer_feedbacks (customer_id, comment, dateAndTime) VALUES
(5, 'Great movie experience, very comfortable seats!', '2023-10-12 14:30:00'),
(6, 'The sound system was incredible, felt like being part of the movie.', '2023-10-13 16:45:00'),
(7, 'Loved the friendly staff and the clean environment.', '2023-10-14 17:00:00'),
(8, 'The selection of movies is fantastic. Found all my favorites and more.', '2023-10-15 18:20:00'),
(9, 'Could use more variety in the concession stand.', '2023-10-16 19:30:00'),
(10, 'Appreciate the attention to cleanliness in the restrooms.', '2023-10-17 20:00:00'),
(11, 'Online ticketing was a breeze. Very user-friendly.', '2023-10-18 21:15:00'),
(12, 'The 3D glasses were a bit uncomfortable and could be improved.', '2023-10-19 22:30:00'),
(13, 'Excellent value for money, especially the combo deals.', '2023-10-20 23:45:00'),
(14, 'More indie films, please! Love the selection but always looking for more.', '2023-10-21 08:00:00');


select * from customer_feedbacks

DROP TABLE IF EXISTS customer_MovieReviews;
CREATE TABLE customer_MovieReviews (
    id INT PRIMARY KEY IDENTITY(1,1),
    customer_id INT FOREIGN KEY (customer_id) REFERENCES users_customers(customer_id),
    movie_id INT FOREIGN KEY (movie_id) REFERENCES movies(movie_id),
    rating INT NOT NULL CONSTRAINT rating_ck CHECK (rating BETWEEN 1 AND 5),
    comment TEXT,
    dateAndTime DATETIME NOT NULL
);

INSERT INTO customer_MovieReviews (customer_id, movie_id, rating, comment, dateAndTime) VALUES
(5, 1, 5, 'Absolutely loved it! Brilliant storytelling and amazing visuals.', '2023-10-12 20:00:00'),
(6, 2, 4, 'Great movie, but felt a bit long in parts. Still, highly recommend!', '2023-10-13 18:30:00'),
(7, 3, 3, 'Good movie, but not what I was expecting. Worth a watch though.', '2023-10-14 19:45:00'),
(8, 4, 5, 'A masterpiece. Acting and direction were top-notch.', '2023-10-15 17:15:00'),
(9, 5, 4, 'Really enjoyed it, especially the soundtrack and the intense scenes.', '2023-10-16 20:30:00'),
(10, 6, 2, 'Not my cup of tea. Found it a bit boring and predictable.', '2023-10-17 21:00:00'),
(11,7, 5, 'An absolute thrill ride from start to finish. Must watch!', '2023-10-18 18:00:00'),
(12, 8, 3, 'Decent watch but nothing groundbreaking. The plot was a bit thin.', '2023-10-19 22:15:00'),
(13, 9, 4, 'Visually stunning and deeply emotional. The story stayed with me.', '2023-10-20 19:00:00'),
(14, 10, 1, 'Disappointing. Expected a lot more based on the hype.', '2023-10-21 20:45:00');

select * from customer_MovieReviews

--- 7. About Manager's Special Functionalities
DROP TABLE IF EXISTS events;
CREATE TABLE events (
    event_id INT PRIMARY KEY IDENTITY(1,1),
    event_name VARCHAR(255) NOT NULL,
    event_description TEXT,
    event_start_time DATETIME NOT NULL,
    event_end_time DATETIME NOT NULL,
    studio_id INT FOREIGN KEY (studio_id) REFERENCES studios(studio_id),
    event_revenue FLOAT NOT NULL,
    manager_id INT FOREIGN KEY (manager_id) REFERENCES users_managers(manager_id)
);

INSERT INTO events (event_name, event_description, event_start_time, event_end_time, studio_id, event_revenue, manager_id) VALUES
('Sci-Fi Marathon', 'A weekend-long marathon of classic and new sci-fi movies.', '2023-11-05 10:00:00', '2023-11-07 22:00:00', 1, 5000.00, 25),
('Horror Night', 'An overnight event showcasing the best in horror cinema.', '2023-10-31 20:00:00', '2023-11-01 04:00:00', 2, 3000.00, 26),
('Family Fun Day', 'A day of family-friendly films and activities.', '2023-12-01 09:00:00', '2023-12-01 17:00:00', 3, 4000.00, 27),
('Film Festival', 'A week-long festival celebrating independent and international films.', '2023-10-10 09:00:00', '2023-10-17 23:00:00', 4, 8000.00, 28),
('Classic Cinema Weekend', 'A celebration of classic films from the golden age of cinema.', '2023-09-15 12:00:00', '2023-09-17 22:00:00', 5, 2500.00, 29);


select * from events




