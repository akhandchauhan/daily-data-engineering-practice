-- 3358. Books with NULL Ratings 
-- Description
-- Table: books
-- ++
-- \| Column Name    \| Type    \|
-- ++
-- \| book_id        \| int     \|
-- \| title          \| varchar \|
-- \| author         \| varchar \|
-- \| published_year \| int     \|
-- \| rating         \| decimal \|

-- book_id is the unique key for this table.
-- Each row of this table contains information about a book including its unique ID, 
-- title, author, publication year, and rating.
-- rating can be NULL, indicating that the book hasn't been rated yet.
-- Write a solution to find all books that have not been rated yet (i.e., have a NULL rating).
-- Return the result table ordered by book_id in ascending order.
-- books table:
-- +-+--+
-- \| book_id \| title                  \| author           \| published_year \| rating \|
-- +-+--+
-- \| 1       \| The Great Gatsby       \| F. Scott         \| 1925           \| 4.5    \|
-- \| 2       \| To Kill a Mockingbird  \| Harper Lee       \| 1960           \| NULL   \|
-- \| 3       \| Pride and Prejudice    \| Jane Austen      \| 1813           \| 4.8    \|
-- \| 4       \| The Catcher in the Rye \| J.D. Salinger    \| 1951           \| NULL   \|
-- \| 5       \| Animal Farm            \| George Orwell    \| 1945           \| 4.2    \|
-- \| 6       \| Lord of the Flies      \| William Golding  \| 1954           \| NULL   \|
-- +-+--+
-- Output:
-- +-+
-- \| book_id \| title                  \| author           \| published_year \|
-- +-+
-- \| 2       \| To Kill a Mockingbird  \| Harper Lee       \| 1960           \|
-- \| 4       \| The Catcher in the Rye \| J.D. Salinger    \| 1951           \|
-- \| 6       \| Lord of the Flies      \| William Golding  \| 1954           \|

Create table books (
    book_id int,
    title varchar(255),
    author varchar(100),
    published_year int,
    rating decimal(3,1)
)
Truncate table books;

INSERT INTO books (book_id, title, author, published_year, rating)
VALUES
(1, 'The Great Gatsby', 'F. Scott', 1925, 4.5),
(2, 'To Kill a Mockingbird', 'Harper Lee', 1960, NULL),
(3, 'Pride and Prejudice', 'Jane Austen', 1813, 4.8),
(4, 'The Catcher in the Rye', 'J.D. Salinger', 1951, NULL),
(5, 'Animal Farm', 'George Orwell', 1945, 4.2),
(6, 'Lord of the Flies', 'William Golding', 1954, NULL);

SELECT book_id, title, author, published_year
FROM books
WHERE rating IS NULL
ORDER BY 1;