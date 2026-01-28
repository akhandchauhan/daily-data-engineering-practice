# -- 1308. Running Total for Different Genders
# -- Description
# -- Table: Scores
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | player_name   | varchar |
# -- | gender        | varchar |
# -- | day           | date    |
# -- | score_points  | int     |
# -- +---------------+---------+
# -- (gender, day) is the primary key (combination of columns with unique values) for this table.
# -- A competition is held between the female team and the male team.
# -- Each row of this table indicates that a player_name and with gender has scored score_point in someday.
# -- Gender is 'F' if the player is in the female team and 'M' if the player is in the male team.
# -- Write a solution to find the total score for each gender on each day.
# -- Return the result table ordered by gender and day in ascending order.
# -- The result format is in the following example.
# -- Example 1:
# -- Input: 
# -- Scores table:
# -- +-------------+--------+------------+--------------+
# -- | player_name | gender | day        | score_points |
# -- +-------------+--------+------------+--------------+
# -- | Aron        | F      | 2020-01-01 | 17           |
# -- | Alice       | F      | 2020-01-07 | 23           |
# -- | Bajrang     | M      | 2020-01-07 | 7            |
# -- | Khali       | M      | 2019-12-25 | 11           |
# -- | Slaman      | M      | 2019-12-30 | 13           |
# -- | Joe         | M      | 2019-12-31 | 3            |
# -- | Jose        | M      | 2019-12-18 | 2            |
# -- | Priya       | F      | 2019-12-31 | 23           |
# -- | Priyanka    | F      | 2019-12-30 | 17           |
# -- +-------------+--------+------------+--------------+
# -- Output: 
# -- +--------+------------+-------+
# -- | gender | day        | total |
# -- +--------+------------+-------+
# -- | F      | 2019-12-30 | 17    |
# -- | F      | 2019-12-31 | 40    |
# -- | F      | 2020-01-01 | 57    |
# -- | F      | 2020-01-07 | 80    |
# -- | M      | 2019-12-18 | 2     |
# -- | M      | 2019-12-25 | 13    |
# -- | M      | 2019-12-30 | 26    |
# -- | M      | 2019-12-31 | 29    |
# -- | M      | 2020-01-07 | 36    |
# -- +--------+------------+-------+


# m1
import pandas as pd

# Create the Scores DataFrame
scores_data = {
    'player_name': ['Aron', 'Alice', 'Bajrang', 'Khali', 'Slaman', 'Joe', 'Jose', 'Priya', 'Priyanka'],
    'gender': ['F', 'F', 'M', 'M', 'M', 'M', 'M', 'F', 'F'],
    'day': ['2020-01-01', '2020-01-07', '2020-01-07', '2019-12-25', '2019-12-30', '2019-12-31', '2019-12-18', '2019-12-31', '2019-12-30'],
    'score_points': [17, 23, 7, 11, 13, 3, 2, 23, 17]
}
scores_df = pd.DataFrame(scores_data)
scores_df['day'] = pd.to_datetime(scores_df['day'])
# scores_df['day'] = pd.to_datetime(scores_df['day'])
# scores_df['total'] = scores_df.groupby('gender')['score_points'].cumsum()
# print(scores_df[['gender', 'day', 'total']].sort_values(by ='gender'))


############################################################################################

#m2
# scores_df = pd.DataFrame(scores_data)
# scores_df = scores_df.groupby(['gender','day'])['score_points'].sum().reset_index()
# scores_df = scores_df.sort_values(['gender','day'])
# scores_df['total'] = scores_df.groupby('gender')['score_points'].cumsum()
# scores_df = scores_df[['gender','day','total']]
# print(scores_df)


#############################################################################################

scores_df = pd.DataFrame(scores_data)
scores_df = scores_df.groupby(['gender','day'])['score_points'].sum().reset_index()

scores_df = scores_df.merge(scores_df, on ='gender')
scores_df = scores_df[scores_df['day_y'] <= scores_df['day_x']]
scores_df = (scores_df.groupby(['gender','day_x'])['score_points_y']
             .sum().reset_index(name ='total')
             .rename(columns = {'day_x':'day'})
             [['gender','day','total']]
)
print(scores_df)