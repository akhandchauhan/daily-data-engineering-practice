
# -- 1821. Find Customers With Positive Revenue this Year
# -- SQL Schema
# -- Table: Customers
# -- +--------------+------+
# -- | Column Name  | Type |
# -- +--------------+------+
# -- | customer_id  | int  |
# -- | year         | int  |
# -- | revenue      | int  |
# -- +--------------+------+
# -- (customer_id, year) is the primary key for this table.
# -- This table contains the customer ID and the revenue of customers in different years.
# -- Note that this revenue can be negative.
# -- Write an  SQL query to report the customers with postive revenue in the year 2021.
# -- Return the result table in any order.
# -- The query result format is in the following example
# -- Customers
# -- +-------------+------+---------+
# -- | customer_id | year | revenue |
# -- +-------------+------+---------+
# -- | 1           | 2018 | 50      |
# -- | 1           | 2021 | 30      |
# -- | 1           | 2020 | 70      |
# -- | 2           | 2021 | -50     |
# -- | 3           | 2018 | 10      |
# -- | 3           | 2016 | 50      |
# -- | 4           | 2021 | 20      |
# -- +-------------+------+---------+
# -- Result table:
# -- +-------------+
# -- | customer_id |
# -- +-------------+
# -- | 1           |
# -- | 4           |
# -- +-------------+
# -- Customer 1 has revenue equal to 50 in year 2021.
# -- Customer 2 has revenue equal to -50 in year 2021.
# -- Customer 3 has no revenue in year 2021.
# -- Customer 4 has revenue equal to 20 in year 2021.
# -- Thus only customers 1 and 4 have postive revenue in year 2021.

# import pandas as pd
# # Sample data
# data = {
#     'customer_id': [1, 1, 1, 2, 3, 3, 4],
#     'year': [2018, 2021, 2020, 2021, 2018, 2016, 2021],
#     'revenue': [50, 30, 70, -50, 10, 50, 20]
# }

# # Create DataFrame
# df = pd.DataFrame(data)
# df_der = df[(df['year'] == 2021) & (df['revenue'] > 0)][['customer_id']]
# print(df_der)

################################################################################################


# -- 2026. Low-Quality Problems
# -- Description
# -- Table: Problems
# -- +-------------+------+
# -- | Column Name | Type |
# -- +-------------+------+
# -- | problem_id  | int  |
# -- | likes       | int  |
# -- | dislikes    | int  |
# -- +-------------+------+
# -- problem_id is the primary key column for this table.
# -- Each row of this table indicates the number of likes and dislikes for a LeetCode problem.

# -- Write an  SQL query to report the IDs of the low-quality problems. A LeetCode problem is 
# --low-quality if the like percentage of the problem (number of likes divided by the total number of votes
# -- is strictly less than 60%.
# -- Return the result table ordered by problem_id in ascending order.
# -- The query result format is in the following example.
# -- Example 1:
# -- Input: 
# -- Problems table:
# -- +------------+-------+----------+
# -- | problem_id | likes | dislikes |
# -- +------------+-------+----------+
# -- | 6          | 1290  | 425      |
# -- | 11         | 2677  | 8659     |
# -- | 1          | 4446  | 2760     |
# -- | 7          | 8569  | 6086     |
# -- | 13         | 2050  | 4164     |
# -- | 10         | 9002  | 7446     |
# -- +------------+-------+----------+
# -- Output: 
# -- +------------+
# -- | problem_id |
# -- +------------+
# -- | 7          |
# -- | 10         |
# -- | 11         |
# -- | 13         |
# -- +------------+
# -- Explanation: The like percentages are as follows:
# -- - Problem 1: (4446 / (4446 + 2760)) * 100 = 61.69858%
# -- - Problem 6: (1290 / (1290 + 425)) * 100 = 75.21866%
# -- - Problem 7: (8569 / (8569 + 6086)) * 100 = 58.47151%
# -- - Problem 10: (9002 / (9002 + 7446)) * 100 = 54.73006%
# -- - Problem 11: (2677 / (2677 + 8659)) * 100 = 23.61503%
# -- - Problem 13: (2050 / (2050 + 4164)) * 100 = 32.99002%
# -- Problems 7, 10, 11, and 13 are low-quality problems because their like percentages are less than 60%.4

# import pandas as pd

# # Sample data
# data = {
#     'problem_id': [6, 11, 1, 7, 13, 10],
#     'likes': [1290, 2677, 4446, 8569, 2050, 9002],
#     'dislikes': [425, 8659, 2760, 6086, 4164, 7446]
# }

# Create DataFrame
# df = pd.DataFrame(data)

# m1
# df['ratio'] = df['likes']/(df['likes']+ (df['dislikes']))
# df = df[df['ratio'] < 0.60]
# df = df[['problem_id']].sort_values(by ='problem_id')
# print(df)

 # m2
#df_selected = df[(df['likes'])/(df['likes']+df['dislikes']) < 0.6][['problem_id']].sort_values(by ='problem_id')
#print(df_selected)


################################################################################################


# -- 2082. The Number of Rich Customers
# -- Description
# -- Table: Store
# -- +-------------+------+
# -- | Column Name | Type |
# -- +-------------+------+
# -- | bill_id     | int  |
# -- | customer_id | int  |
# -- | amount      | int  |
# -- +-------------+------+
# -- bill_id is the primary key for this table.
# -- Each row contains information about the amount of one bill and the customer associated with it.
# -- Write an  SQL query to report the number of customers who had at least one bill
# -- with an amount strictly greater than 500.
# -- Example 1:
# -- Input: 
# -- Store table:
# -- +---------+-------------+--------+
# -- | bill_id | customer_id | amount |
# -- +---------+-------------+--------+
# -- | 6       | 1           | 549    |
# -- | 8       | 1           | 834    |
# -- | 4       | 2           | 394    |
# -- | 11      | 3           | 657    |
# -- | 13      | 3           | 257    |
# -- +---------+-------------+--------+
# -- Output: 
# -- +------------+
# -- | rich_count |
# -- +------------+
# -- | 2          |
# -- +------------+
# -- Explanation: 
# -- Customer 1 has two bills with amounts strictly greater than 500.
# -- Customer 2 does not have any bills with an amount strictly greater than 500.
# -- Customer 3 has one bill with an amount strictly greater than 500.


import pandas as pd
data = {
    'bill_id': [6, 8, 4, 11, 13],
    'customer_id': [1, 1, 2, 3, 3],
    'amount': [549, 834, 394, 657, 257]
}

df2 = pd.DataFrame(data)


# df1 = df1.query('amount > 500')[['customer_id']]
# df1 = df1.drop_duplicates().shape[0]
# print(df1)  # problem not giving row

rich_count = df2.query('amount > 500')['customer_id'].nunique()
result_df = pd.DataFrame({'rich_count': [rich_count]})

print(result_df)


################################################################################################

# 3358. Books with NULL Ratings 
# Description
# Table: books
# ++
# \| Column Name    \| Type    \|
# ++
# \| book_id        \| int     \|
# \| title          \| varchar \|
# \| author         \| varchar \|
# \| published_year \| int     \|
# \| rating         \| decimal \|

# book_id is the unique key for this table.
# Each row of this table contains information about a book including its unique ID, 
# title, author, publication year, and rating.
# rating can be NULL, indicating that the book hasn't been rated yet.
# Write a solution to find all books that have not been rated yet (i.e., have a NULL rating).
# Return the result table ordered by book_id in ascending order.
# books table:
# +-+--+
# \| book_id \| title                  \| author           \| published_year \| rating \|
# +-+--+
# \| 1       \| The Great Gatsby       \| F. Scott         \| 1925           \| 4.5    \|
# \| 2       \| To Kill a Mockingbird  \| Harper Lee       \| 1960           \| NULL   \|
# \| 3       \| Pride and Prejudice    \| Jane Austen      \| 1813           \| 4.8    \|
# \| 4       \| The Catcher in the Rye \| J.D. Salinger    \| 1951           \| NULL   \|
# \| 5       \| Animal Farm            \| George Orwell    \| 1945           \| 4.2    \|
# \| 6       \| Lord of the Flies      \| William Golding  \| 1954           \| NULL   \|
# +-+--+
# Output:
# +-+
# \| book_id \| title                  \| author           \| published_year \|
# +-+
# \| 2       \| To Kill a Mockingbird  \| Harper Lee       \| 1960           \|
# \| 4       \| The Catcher in the Rye \| J.D. Salinger    \| 1951           \|
# \| 6       \| Lord of the Flies      \| William Golding  \| 1954           \|


import pandas as pd

data = {
    'book_id': [1, 2, 3, 4, 5, 6],
    'title': [
        'The Great Gatsby',
        'To Kill a Mockingbird',
        'Pride and Prejudice',
        'The Catcher in the Rye',
        'Animal Farm',
        'Lord of the Flies'
    ],
    'author': [
        'F. Scott',
        'Harper Lee',
        'Jane Austen',
        'J.D. Salinger',
        'George Orwell',
        'William Golding'
    ],
    'published_year': [1925, 1960, 1813, 1951, 1945, 1954],
    'rating': [4.5, None, 4.8, None, 4.2, None]
}

# books = pd.DataFrame(data)


# result = (
#     books[books['rating'].isnull()]
#     [['book_id', 'title', 'author', 'published_year']]
#     .sort_values('book_id')
# )

# print(result)
