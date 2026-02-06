
# # -- 3056. Snapshot Analysis 
# # -- Title Description
# # -- surface:Activities
# # -- +---------------+---------+
# # -- | Column Name | Type |
# # -- +---------------+---------+
# # -- | activity_id | int |
# # -- | user_id | int |
# # -- | activity_type | enum |
# # -- | time_spent | decimal |
# # -- +---------------+---------+
# # -- activity_id is the column in this table where the values ​​are unique.
# # -- activity_type is an ENUM (category) of ('send', 'open').
# # -- This table contains activity id, user id, activity type and time spent.

# # -- surface:Age
# # -- +-------------+------+
# # -- | Column Name | Type |
# # -- +-------------+------+
# # -- | user_id | int |
# # -- | age_bucket | enum |
# # -- +-------------+------+
# # -- user_id is a column in this table that has distinct values.
# # -- age_bucket is an ENUM (category) of ('21-25', '26-30', '31-35').
# # -- This table contains user id and age groups.
# # -- Write a solution to calculate the percentage of total time spent sending and opening 
# # --snapshots for each age group . The percentages should be rounded to decimal places.2
# # -- Returns a table of results in any order.
# # -- The resulting format is as follows.
# # -- enter: 
# # -- Activities table:
# # -- +-------------+---------+---------------+--------- ---+
# # -- | activity_id | user_id | activity_type | time_spent |
# # -- +-------------+---------+---------------+--------- ---+
# # -- | 7274 | 123 | open | 4.50 |
# # -- | 2425 | 123 | send | 3.50 |
# # -- | 1413 | 456 | send | 5.67 |
# # -- | 2536 | 456 | open | 3.00 |
# # -- | 8564 | 456 | send | 8.24 |
# # -- | 5235 | 789 | send | 6.24 |
# # -- | 4251 | 123 | open | 1.25 |
# # -- | 1435 | 789 | open | 5.25 |
# # -- +-------------+---------+---------------+--------- ---+
# # -- Age table:
# # -- +---------+------------+
# # -- | user_id | age_bucket |
# # -- +---------+------------+
# # -- | 123 | 31-35 |
# # -- | 789 | 21-25 |
# # -- | 456 | 26-30 |
# # -- +---------+------------+
# # -- Output: 
# # -- +----------------+-----------+-----------+
# # -- | age_bucket | send_perc | open_perc |
# # -- +----------------+-----------+-----------+
# # -- | 31-35 | 37.84 | 62.16 |
# # -- | 26-30 | 82.26 | 17.74 |
# # -- | 21-25 | 54.31 | 45.69 |
# # -- +----------------+-----------+-----------+
# # -- explain: 
# # -- For age group 31-35:
# # --   - There is only one user belonging to this group, with user ID 123.
# # --   - The total time this user spent sending snaps was 3.50, and the time spent opening 
# # --snaps was 4.50 + 1.25 = 5.75.
# # --   - The total time spent by the user is 3.50 + 5.75 = 9.25.
# # --   - Therefore, the sent snapshot percentage is (3.50 / 9.25) * 100 = 37.84, and the 
# # --opened snapshot percentage is (5.75 / 9.25) * 100 = 62.16.
# # -- For age group 26-30:
# # --   - There is only one user belonging to this group, user ID 456.
# # --   - The total time this user spent sending snaps was 5.67 + 8.24 = 13.91, and the time 
# # --spent opening snaps was 3.00.
# # --   - The total time spent by the user is 13.91 + 3.00 = 16.91.
# # --   - Therefore, the sent snapshot percentage is (13.91 / 16.91) * 100 = 82.26, and the 
# # --opened snapshot percentage is (3.00 / 16.91) * 100 = 17.74.
# # -- For age group 21-25:
# # --   - There is only one user belonging to this group, user ID 789.
# # --   - The total time this user spent sending snaps was 6.24, and the time spent opening 
# # --snaps was 5.25.
# # --   - The total time spent by the user is 6.24 + 5.25 = 11.49.
# # --   - Therefore, the sent snapshot percentage is (6.24 / 11.49) * 100 = 54.31, and the 
# # --opened snapshot percentage is (5.25 / 11.49) * 100 = 45.69.
# # -- All percentages in the output table are rounded to two digits.


# import pandas as pd
# data = [[7274, 123, 'open', 4.5], [2425, 123, 'send', 3.5], [1413, 456, 'send', 5.67], [2536, 456, 'open', 3.0], [8564, 456, 'send', 8.24], [5235, 789, 'send', 6.24], [4251, 123, 'open', 1.25], [1435, 789, 'open', 5.25]]
# activities = pd.DataFrame(data, columns=['activity_id', 'user_id', 'activity_type', 'time_spent']).astype({'activity_id':'Int64', 'user_id':'Int64', 'activity_type':'object', 'time_spent':'Float64'})

# data = [[123, '31-35'], [789, '21-25'], [456, '26-30']]
# age = pd.DataFrame(data, columns=['user_id', 'age_bucket']).astype({'user_id':'Int64', 'age_bucket':'object'})


# df = pd.merge(age,activities, on ='user_id',how ='left')

# result = df.groupby(['age_bucket', 'activity_type'])['time_spent'].sum().unstack(fill_value=0)
# result['total_time'] = result['send'] + result['open']

# result['send_perc'] = (result['send'] / result['total_time']) * 100
# result['open_perc'] = (result['open'] / result['total_time']) * 100

# result = result[['send_perc', 'open_perc']].round(2)
# result = result.reset_index()
# print(result)



# -- 3050. Pizza Toppings Cost Analysis 
# -- Description
# -- Table: Toppings
# -- +--------------+---------+ 
# -- | Column Name  | Type    | 
# -- +--------------+---------+ 
# -- | topping_name | varchar | 
# -- | cost         | decimal |
# -- +--------------+---------+
# -- topping_name is the primary key for this table.
# -- Each row of this table contains topping name and the cost of the topping. 
# -- Write a solution to calculate the total cost of all possible 3-topping pizza 
# --combinations from a given list of toppings. The total cost of toppings must be rounded to 2 decimal places.
# -- Note:
# -- Do not include the pizzas where a topping is repeated. For example, ‘Pepperoni, Pepperoni, Onion Pizza’.
# -- Toppings must be listed in alphabetical order. For example, 'Chicken, Onions, Sausage'. 'Onion, Sausage, 
# --Chicken' is not acceptable.
# -- Return the result table ordered by total cost in descending order and combination of toppings in ascending 
# --order.
# -- The result format is in the following example.
# -- Example 1:
# -- Input: 
# -- Toppings table:
# -- +--------------+------+
# -- | topping_name | cost |
# -- +--------------+------+
# -- | Pepperoni    | 0.50 |
# -- | Sausage      | 0.70 |
# -- | Chicken      | 0.55 |
# -- | Extra Cheese | 0.40 |
# -- +--------------+------+
# -- Output: 
# -- +--------------------------------+------------+
# -- | pizza                          | total_cost | 
# -- +--------------------------------+------------+
# -- | Chicken,Pepperoni,Sausage      | 1.75       |  
# -- | Chicken,Extra Cheese,Sausage   | 1.65       |
# -- | Extra Cheese,Pepperoni,Sausage | 1.60       |
# -- | Chicken,Extra Cheese,Pepperoni | 1.45       | 
# -- +--------------------------------+------------+
# -- Explanation: 
# -- There are only four different combinations possible with the three topings:
# -- - Chicken, Pepperoni, Sausage: Total cost is $1.75 (Chicken $0.55, Pepperoni $0.50, Sausage $0.70).
# -- - Chicken, Extra Cheese, Sausage: Total cost is $1.65 (Chicken $0.55, Extra Cheese $0.40, Sausage $0.70).
# -- - Extra Cheese, Pepperoni, Sausage: Total cost is $1.60 (Extra Cheese $0.40, Pepperoni $0.50, Sausage $0.70).
# -- - Chicken, Extra Cheese, Pepperoni: Total cost is $1.45 (Chicken $0.55, Extra Cheese $0.40, Pepperoni $0.50).
# -- Output table is ordered by the total cost in descending order.


import pandas as pd

data = [
    ['Pepperoni', 0.50],
    ['Sausage', 0.70],
    ['Chicken', 0.55],
    ['Extra Cheese', 0.40]
]

toppings = pd.DataFrame(data, columns=['topping_name', 'cost'])

df = pd.merge(toppings,toppings,how ='cross')
df = pd.merge(df,toppings,how ='cross')
df = df.query("'topping_name_x' < 'topping_name_y' and 'topping_name_y' < 'topping_name'")
print(df)