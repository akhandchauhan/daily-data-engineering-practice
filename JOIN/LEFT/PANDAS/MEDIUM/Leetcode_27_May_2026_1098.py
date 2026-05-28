# 1098. Unpopular Books

# Table: Books
# +----------------+---------+
# | Column Name    | Type    |
# +----------------+---------+
# | book_id        | int     |
# | name           | varchar |
# | available_from | date    |
# +----------------+---------+
# book_id is the primary key of this table.

# Table: Orders
# +----------------+---------+
# | Column Name    | Type    |
# +----------------+---------+
# | order_id       | int     |
# | book_id        | int     |
# | quantity       | int     |
# | dispatch_date  | date    |
# +----------------+---------+
# order_id is the primary key of this table.
# book_id is a foreign key to the Books table.

# Write an SQL query that reports the books that have sold less than 10 
# copies in the last year,
# excluding books that have been available for less than 1 month from today.
# Assume today is 2019-06-23.

# Books table:
# +---------+--------------------+----------------+
# | book_id | name               | available_from |
# +---------+--------------------+----------------+
# | 1       | "Kalila And Demna" | 2010-01-01     |
# | 2       | "28 Letters"       | 2012-05-12     |
# | 3       | "The Hobbit"       | 2019-06-10     |
# | 4       | "13 Reasons Why"   | 2019-06-01     |
# | 5       | "The Hunger Games" | 2008-09-21     |
# +---------+--------------------+----------------+
# Orders table:
# +----------+---------+----------+---------------+
# | order_id | book_id | quantity | dispatch_date |
# +----------+---------+----------+---------------+
# | 1        | 1       | 2        | 2018-07-26    |
# | 2        | 1       | 1        | 2018-11-05    |
# | 3        | 3       | 8        | 2019-06-11    |
# | 4        | 4       | 6        | 2019-06-05    |
# | 5        | 4       | 5        | 2019-06-20    |
# | 6        | 5       | 9        | 2009-02-02    |
# | 7        | 5       | 8        | 2010-04-13    |
# +----------+---------+----------+---------------+
# Result table:
# +-----------+--------------------+
# | book_id   | name               |
# +-----------+--------------------+
# | 1         | "Kalila And Demna" |
# | 2         | "28 Letters"       |
# | 5         | "The Hunger Games" |
# +-----------+--------------------+

import pandas as pd

books = pd.DataFrame({
    'book_id': [1, 2, 3, 4, 5],
    'name': [
        'Kalila And Demna',
        '28 Letters',
        'The Hobbit',
        '13 Reasons Why',
        'The Hunger Games'
    ],
    'available_from': [
        '2010-01-01',
        '2012-05-12',
        '2019-06-10',
        '2019-06-01',
        '2008-09-21'
    ]
})

orders = pd.DataFrame({
    'order_id': [1, 2, 3, 4, 5, 6, 7],
    'book_id': [1, 1, 3, 4, 4, 5, 5],
    'quantity': [2, 1, 8, 6, 5, 9, 8],
    'dispatch_date': [
        '2018-07-26',
        '2018-11-05',
        '2019-06-11',
        '2019-06-05',
        '2019-06-20',
        '2009-02-02',
        '2010-04-13'
    ]
})

books['available_from'] = pd.to_datetime(books['available_from'])
orders['dispatch_date'] = pd.to_datetime(orders['dispatch_date'])

end_date = pd.to_datetime('2019-06-23')
start_date = end_date - pd.DateOffset(years=1)

orders_df = (
    orders[orders['dispatch_date'].between(start_date, end_date)]
    .groupby('book_id', as_index = False)['quantity'].sum()
    [['book_id','quantity']]
)

book_available_end = pd.to_datetime('2019-06-23')
book_available_start = book_available_end - pd.DateOffset(months=1)

books_df = books[~books['available_from'].between(book_available_start,book_available_end)][['book_id','name']]

merged_df = (
    books_df.merge(orders_df, how ='left', on ='book_id')
    .loc[lambda d: (d['quantity'].isna()) | (d['quantity'] < 10)]
    [['book_id','name']]
)

print(merged_df)