# -- 2372. Calculate the Influence of Each Salesperson
# -- Description
# -- Table: Salesperson
# -- +----------------+---------+
# -- | Column Name    | Type    |
# -- +----------------+---------+
# -- | salesperson_id | int     |
# -- | name           | varchar |
# -- +----------------+---------+
# -- salesperson_id is the primary key for this table.
# -- Each row in this table shows the ID of a salesperson.
# -- Table: Customer
# -- +----------------+------+
# -- | Column Name    | Type |
# -- +----------------+------+
# -- | customer_id    | int  |
# -- | salesperson_id | int  |
# -- +----------------+------+
# -- customer_id is the primary key for this table.
# -- salesperson_id is a foreign key from the Salesperson table.
# -- Each row in this table shows the ID of a customer and the ID of the salesperson. 

# -- Table: Sales
# -- +-------------+------+
# -- | Column Name | Type |
# -- +-------------+------+
# -- | sale_id     | int  |
# -- | customer_id | int  |
# -- | price       | int  |
# -- +-------------+------+
# -- sale_id is the primary key for this table.
# -- customer_id is a foreign key from the Customer table.
# -- Each row in this table shows ID of a customer and the price they paid for the sale with sale_id.
# --  
# -- Write an  SQL query to report the sum of prices paid by the customers of each salesperson.
# -- If a salesperson does not have any customers, the total value should be 0.

# -- Return the result table in any order.

# -- Input: 
# -- Salesperson table:
# -- +----------------+-------+
# -- | salesperson_id | name  |
# -- +----------------+-------+
# -- | 1              | Alice |
# -- | 2              | Bob   |
# -- | 3              | Jerry |
# -- +----------------+-------+
# -- Customer table:
# -- +-------------+----------------+
# -- | customer_id | salesperson_id |
# -- +-------------+----------------+
# -- | 1           | 1              |
# -- | 2           | 1              |
# -- | 3           | 2              |
# -- +-------------+----------------+
# -- Sales table:
# -- +---------+-------------+-------+
# -- | sale_id | customer_id | price |
# -- +---------+-------------+-------+
# -- | 1       | 2           | 892   |
# -- | 2       | 1           | 354   |
# -- | 3       | 3           | 988   |
# -- | 4       | 3           | 856   |
# -- +---------+-------------+-------+

# -- Output: 
# -- +----------------+-------+-------+
# -- | salesperson_id | name  | total |
# -- +----------------+-------+-------+
# -- | 1              | Alice | 1246  |
# -- | 2              | Bob   | 1844  |
# -- | 3              | Jerry | 0     |
# -- +----------------+-------+-------+
# -- Explanation: 
# -- Alice is the salesperson for customers 1 and 2.
# --   - Customer 1 made one purchase with 354.
# --   - Customer 2 made one purchase with 892.
# -- The total for Alice is 354 + 892 = 1246.

# -- Bob is the salesperson for customers 3.
# --   - Customer 1 made one purchase with 988 and 856.
# -- The total for Bob is 988 + 856 = 1844.

# -- Jerry is not the salesperson of any customer.
# -- The total for Jerry is 0.

# import pandas as pd

# salesperson_data = {
#     'salesperson_id': [1, 2, 3],
#     'name': ['Alice', 'Bob', 'Jerry']
# }

# customer_data = {
#     'customer_id': [1, 2, 3],
#     'salesperson_id': [1, 1, 2]
# }

# sales_data = {
#     'sale_id': [1, 2, 3, 4],
#     'customer_id': [2, 1, 3, 3],
#     'price': [892, 354, 988, 856]
# }

# salesperson_df = pd.DataFrame(salesperson_data)
# customer_df = pd.DataFrame(customer_data)
# sales_df = pd.DataFrame(sales_data)

# df = pd.merge(salesperson_df,customer_df,on ='salesperson_id',how ='left')
# df = pd.merge(df,sales_df,on ='customer_id',how ='left')
# df['price'] = df['price'].fillna(0)
# df = df.groupby(['salesperson_id','name'])['price'].sum().reset_index().rename(columns ={'price' :'total'})
# print(df)

# -- 1264. Page Recommendations
# -- SQL Schema 
# -- Table: Friendship
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | user1_id      | int     |
# -- | user2_id      | int     |
# -- +---------------+---------+
# -- (user1_id, user2_id) is the primary key for this table.
# -- Each row of this table indicates that there is a friendship relation between user1_id and user2_id.

# -- Table: Likes
# -- +-------------+---------+
# -- | Column Name | Type    |
# -- +-------------+---------+
# -- | user_id     | int     |
# -- | page_id     | int     |
# -- +-------------+---------+
# -- (user_id, page_id) is the primary key for this table.
# -- Each row of this table indicates that user_id likes page_id.

# -- Write an  SQL query to recommend pages to the user with user_id = 1 using the pages that your 
# --friends liked. It should not recommend pages you already liked.
# -- Return result table in any order without duplicates.
# -- Friendship table:
# -- +----------+----------+
# -- | user1_id | user2_id |
# -- +----------+----------+
# -- | 1        | 2        |
# -- | 1        | 3        |
# -- | 1        | 4        |
# -- | 2        | 3        |
# -- | 2        | 4        |
# -- | 2        | 5        |
# -- | 6        | 1        |
# -- +----------+----------+

# -- Likes table:
# -- +---------+---------+
# -- | user_id | page_id |
# -- +---------+---------+
# -- | 1       | 88      |
# -- | 2       | 23      |
# -- | 3       | 24      |
# -- | 4       | 56      |
# -- | 5       | 11      |
# -- | 6       | 33      |
# -- | 2       | 77      |
# -- | 3       | 77      |
# -- | 6       | 88      |
# -- +---------+---------+

# -- Result table:
# -- +------------------+
# -- | recommended_page |
# -- +------------------+
# -- | 23               |
# -- | 24               |
# -- | 56               |
# -- | 33               |
# -- | 77               |
# -- +------------------+
# -- User one is friend with users 2, 3, 4 and 6.
# -- Suggested pages are 23 from user 2, 24 from user 3, 56 from user 3 and 33 from user 6.
# -- Page 77 is suggested from both user 2 and user 3.
# -- Page 88 is not suggested because user 1 already likes it.

# import pandas as pd

# friendship_data = {
#     'user1_id': [1, 1, 1, 2, 2, 2, 6],
#     'user2_id': [2, 3, 4, 3, 4, 5, 1]
# }

# likes_data = {
#     'user_id': [1, 2, 3, 4, 5, 6, 2, 3, 6],
#     'page_id': [88, 23, 24, 56, 11, 33, 77, 77, 88]
# }
# friendship_df = pd.DataFrame(friendship_data)
# likes_df = pd.DataFrame(likes_data)

# friendship_df2 = friendship_df[['user2_id','user1_id']]
# df = pd.concat([friendship_df,friendship_df2])
# df = df[(df['user1_id'] == 1) | (df['user2_id'] == 1)]
# print(df)

# df = pd.merge(df,likes_df,left_on='user2_id',right_on ='user_id',how ='inner')
# df2 = likes_df.query('user_id == 1')[['page_id']]
# df = df[['page_id']].drop_duplicates()
# df = df[~df['page_id'].isin(df2['page_id'])]
# print(df)


# -- 612. Shortest Distance in a Plane
# -- Description
# -- Table: Point2D
# -- +-------------+------+
# -- | Column Name | Type |
# -- +-------------+------+
# -- | x           | int  |
# -- | y           | int  |
# -- +-------------+------+
# -- (x, y) is the primary key column (combination of columns with unique values) for this table.
# -- Each row of this table indicates the position of a point on the X-Y plane.
# -- The distance between two points p1(x1, y1) and p2(x2, y2) is sqrt((x2 - x1)2 + (y2 - y1)2).
# -- Write a solution to report the shortest distance between any two points from the Point2D table.
# -- Round the distance to two decimal points.
# -- Input: 
# -- Point2D table:
# -- +----+----+
# -- | x  | y  |
# -- +----+----+
# -- | -1 | -1 |
# -- | 0  | 0  |
# -- | -1 | -2 |
# -- +----+----+
# -- Output: 
# -- +----------+
# -- | shortest |
# -- +----------+
# -- | 1.00     |
# -- +----------+
# -- Explanation: The shortest distance is 1.00 from point (-1, -1) to (-1, 2).

# import pandas as pd
# import numpy as np

# data = {'x': [-1, 0, -1],
#         'y': [-1, 0, -2]}

# df = pd.DataFrame(data)
# df = pd.merge(df, df, how='cross')
# df = df.query('x_x != x_y or y_x != y_y')
# df['dist'] = np.sqrt(np.power(df['x_x'] - df['x_y'], 2) + np.power(df['y_x'] - df['y_y'], 2))

# shortest_distance = df['dist'].min()
# print(f"Shortest distance: {shortest_distance:.2f}")


# -- 1440. Evaluate Boolean Expression
# -- SQL Schema 
# -- Table Variables:
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | name          | varchar |
# -- | value         | int     |
# -- +---------------+---------+
# -- name is the primary key for this table.
# -- This table contains the stored variables and their values.
# -- Table Expressions:
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | left_operand  | varchar |
# -- | operator      | enum    |
# -- | right_operand | varchar |
# -- +---------------+---------+
# -- (left_operand, operator, right_operand) is the primary key for this table.
# -- This table contains a boolean expression that should be evaluated.
# -- operator is an enum that takes one of the values ('<', '>', '=')
# -- The values of left_operand and right_operand are guaranteed to be in the Variables table.
# -- Write an  SQL query to evaluate the boolean expressions in Expressions table.
# -- Return the result table in any order.
# -- Variables table:
# -- +------+-------+
# -- | name | value |
# -- +------+-------+
# -- | x    | 66    |
# -- | y    | 77    |
# -- +------+-------+
# -- Expressions table:
# -- +--------------+----------+---------------+
# -- | left_operand | operator | right_operand |
# -- +--------------+----------+---------------+
# -- | x            | >        | y             |
# -- | x            | <        | y             |
# -- | x            | =        | y             |
# -- | y            | >        | x             |
# -- | y            | <        | x             |
# -- | x            | =        | x             |
# -- +--------------+----------+---------------+
# -- Result table:
# -- +--------------+----------+---------------+-------+
# -- | left_operand | operator | right_operand | value |
# -- +--------------+----------+---------------+-------+
# -- | x            | >        | y             | false |
# -- | x            | <        | y             | true  |
# -- | x            | =        | y             | false |
# -- | y            | >        | x             | true  |
# -- | y            | <        | x             | false |
# -- | x            | =        | x             | true  |
# -- +--------------+----------+---------------+-------+
# -- As shown, you need find the value of each boolean exprssion in the table using the variables table.


# import pandas as pd

# variables_data = {'name': ['x', 'y'], 'value': [66, 77]}
# variables_df = pd.DataFrame(variables_data)

# expressions_data = {
#     'left_operand': ['x', 'x', 'x', 'y', 'y', 'x'],
#     'operator': ['>', '<', '=', '>', '<', '='],
#     'right_operand': ['y', 'y', 'y', 'x', 'x', 'x']
# }
# expressions_df = pd.DataFrame(expressions_data)

# df = pd.merge(expressions_df,variables_df,left_on ='left_operand',right_on ='name')
# df = pd.merge(df,variables_df,left_on ='right_operand',right_on ='name')

# def check(row):
#     if row['value_x'] > row['value_y'] and row['operator'] == '>':
#         return True
#     elif row['value_x'] < row['value_y'] and row['operator'] == '<':
#         return True
#     elif row['value_x'] == row['value_y'] and row['operator'] == '=':
#         return True
#     else:
#         return False
    

# df['value'] = df.apply(check, axis = 1)
# df = df[['left_operand', 'operator', 'right_operand','value']]
# print(df)

# -- 2159. Order Two Columns Independently
# -- Description
# -- Table: Data
# -- +-------------+------+
# -- | Column Name | Type |
# -- +-------------+------+
# -- | first_col   | int  |
# -- | second_col  | int  |
# -- +-------------+------+
# -- There is no primary key for this table and it may contain duplicates.
# -- Write an SQL query to independently:
# -- order first_col in ascending order.
# -- order second_col in descending order.
# -- The query result format is in the following example.
# -- Example 1:
# -- Input: 
# -- Data table:
# -- +-----------+------------+
# -- | first_col | second_col |
# -- +-----------+------------+
# -- | 4         | 2          |
# -- | 2         | 3          |
# -- | 3         | 1          |
# -- | 1         | 4          |
# -- +-----------+------------+
# -- Output: 
# -- +-----------+------------+
# -- | first_col | second_col |
# -- +-----------+------------+
# -- | 1         | 4          |
# -- | 2         | 3          |
# -- | 3         | 2          |
# -- | 4         | 1          |
# -- +-----------+------------+


import pandas as pd
data = {'first_col': [4, 2, 3, 1],
        'second_col': [2, 3, 1, 4]}
df = pd.DataFrame(data)

df_first_ordered = df[['first_col']].copy()
df_first_ordered['row_num'] = df_first_ordered['first_col'].rank(method='first', ascending=True).astype(int)

df_second_ordered = df[['second_col']].copy()
df_second_ordered['row_num'] = df_second_ordered['second_col'].rank(method='first', ascending=False).astype(int)
result_df = pd.merge(df_first_ordered, df_second_ordered, on='row_num')

result_df = result_df.sort_values(by='row_num').reset_index(drop=True)

result_df = result_df.drop(columns=['row_num'])

print(result_df)


