# -- 1468. Calculate Salaries
# -- Description
# -- Table Salaries:
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | company_id    | int     |
# -- | employee_id   | int     |
# -- | employee_name | varchar |
# -- | salary        | int     |
# -- +---------------+---------+
# -- In SQL,(company_id, employee_id) is the primary key for this table.
# -- This table contains the company id, the id, the name, and the salary for an employee.
# -- Find the salaries of the employees after applying taxes. Round the salary to the nearest integer.
# -- The tax rate is calculated for each company based on the following criteria:

# -- 0% If the max salary of any employee in the company is less than $1000.
# -- 24% If the max salary of any employee in the company is in the range [1000, 10000] inclusive.
# -- 49% If the max salary of any employee in the company is greater than $10000.
# -- Return the result table in any order.
# -- The result format is in the following example.

# -- Example 1:
# -- Input: 
# -- Salaries table:
# -- +------------+-------------+---------------+--------+
# -- | company_id | employee_id | employee_name | salary |
# -- +------------+-------------+---------------+--------+
# -- | 1          | 1           | Tony          | 2000   |
# -- | 1          | 2           | Pronub        | 21300  |
# -- | 1          | 3           | Tyrrox        | 10800  |
# -- | 2          | 1           | Pam           | 300    |
# -- | 2          | 7           | Bassem        | 450    |
# -- | 2          | 9           | Hermione      | 700    |
# -- | 3          | 7           | Bocaben       | 100    |
# -- | 3          | 2           | Ognjen        | 2200   |
# -- | 3          | 13          | Nyancat       | 3300   |
# -- | 3          | 15          | Morninngcat   | 7777   |
# -- +------------+-------------+---------------+--------+
# -- Output: 
# -- +------------+-------------+---------------+--------+
# -- | company_id | employee_id | employee_name | salary |
# -- +------------+-------------+---------------+--------+
# -- | 1          | 1           | Tony          | 1020   |
# -- | 1          | 2           | Pronub        | 10863  |
# -- | 1          | 3           | Tyrrox        | 5508   |
# -- | 2          | 1           | Pam           | 300    |
# -- | 2          | 7           | Bassem        | 450    |
# -- | 2          | 9           | Hermione      | 700    |
# -- | 3          | 7           | Bocaben       | 76     |
# -- | 3          | 2           | Ognjen        | 1672   |
# -- | 3          | 13          | Nyancat       | 2508   |
# -- | 3          | 15          | Morninngcat   | 5911   |
# -- +------------+-------------+---------------+--------+

# import pandas as pd

# data = {
#     "company_id": [1, 1, 1, 2, 2, 2, 3, 3, 3, 3],
#     "employee_id": [1, 2, 3, 1, 7, 9, 7, 2, 13, 15],
#     "employee_name": ["Tony", "Pronub", "Tyrrox", "Pam", "Bassem", "Hermione", "Bocaben", "Ognjen", "Nyancat", "Morninngcat"],
#     "salary": [2000, 21300, 10800, 300, 450, 700, 100, 2200, 3300, 7777]
# }
# def checksal(maxi,salary):
#     if maxi >= 1000 and maxi <=10000:
#         salary = salary - (0.24*salary)
#     elif maxi > 10000:
#         salary = salary - (0.49*salary)
#     return round(salary)
    
# df = pd.DataFrame(data)
# df['maxi'] = df.groupby('company_id')['salary'].transform('max')
# df['salary'] = df.apply(lambda x :checksal(x['maxi'],x['salary']),axis = 1)
# df = df.drop(columns = ['maxi'])
#print(df)


# -- 534. Game Play Analysis III
# -- Description
# -- Table: Activity
# -- +--------------+---------+
# -- | Column Name  | Type    |
# -- +--------------+---------+
# -- | player_id    | int     |
# -- | device_id    | int     |
# -- | event_date   | date    |
# -- | games_played | int     |
# -- +--------------+---------+
# -- (player_id, event_date) is the primary key (column with unique values) of this table.
# -- This table shows the activity of players of some games.
# -- Each row is a record of a player who logged in and played a number of games (possibly 0) before logging out 
# --on someday using some device.
# -- Write a solution to report for each player and date, how many games played so far by the player.
# -- That is, the total number of games played by the player until that date. Check the example for clarity.
# -- Return the result table in any order.
# -- The result format is in the following example.
# -- Example 1:
# -- Input: 
# -- Activity table:
# -- +-----------+-----------+------------+--------------+
# -- | player_id | device_id | event_date | games_played |
# -- +-----------+-----------+------------+--------------+
# -- | 1         | 2         | 2016-03-01 | 5            |
# -- | 1         | 2         | 2016-05-02 | 6            |
# -- | 1         | 3         | 2017-06-25 | 1            |
# -- | 3         | 1         | 2016-03-02 | 0            |
# -- | 3         | 4         | 2018-07-03 | 5            |
# -- +-----------+-----------+------------+--------------+
# -- Output: 
# -- +-----------+------------+---------------------+
# -- | player_id | event_date | games_played_so_far |
# -- +-----------+------------+---------------------+
# -- | 1         | 2016-03-01 | 5                   |
# -- | 1         | 2016-05-02 | 11                  |
# -- | 1         | 2017-06-25 | 12                  |
# -- | 3         | 2016-03-02 | 0                   |
# -- | 3         | 2018-07-03 | 5                   |
# -- +-----------+------------+---------------------+
# -- Explanation: 
# -- For the player with id 1, 5 + 6 = 11 games played by 2016-05-02, and 5 + 6 + 1 = 12 games
# played by 2017-06-25.
# -- For the player with id 3, 0 + 5 = 5 games played by 2018-07-03.
# -- Note that for each player we only care about the days when the player logged in.


# import pandas as pd

# data = {
#     'player_id': [1, 1, 1, 3, 3],
#     'device_id': [2, 2, 3, 1, 4],
#     'event_date': ['2016-03-01', '2016-05-02', '2017-06-25', '2016-03-02', '2018-07-03'],
#     'games_played': [5, 6, 1, 0, 5]
# }

# df = pd.DataFrame(data)
# df['event_date'] = pd.to_datetime(df['event_date'])



# m1 using cumsum

# df['games_played_so_far'] = df.groupby('player_id')['games_played'].transform('cumsum')
# df = df[['player_id','event_date','games_played_so_far']]
# print(df)


# m2 using self join
# df = df.merge(df,on='player_id',how ='inner')
# df = df.query('event_date_x >= event_date_y')
# df['games_played_so_far'] = df.groupby(['player_id','event_date_x'])['games_played_y'].transform('cumsum')
# df = df.groupby(['player_id','event_date_x'])['games_played_so_far'].last()
# print(df)


# using gpt


# result = (
#     df.merge(df, on='player_id', how='inner')
#     .query('event_date_x >= event_date_y')
#     .groupby(['player_id', 'event_date_x'])['games_played_y']
#     .sum()
#     .reset_index()
#     .rename(columns={'event_date_x': 'event_date', 'games_played_y': 'games_played_so_far'})
#     .sort_values(by=['player_id', 'event_date'])
# )

# print(result)

##############################################################################################################

