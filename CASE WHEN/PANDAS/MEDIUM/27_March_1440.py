# -- 1440. Evaluate Boolean Expression

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


import pandas as pd
import numpy as np
pd.set_option("display.max_columns", None)

variables_data = {'name': ['x', 'y'], 'value': [66, 77]}
variables_df = pd.DataFrame(variables_data)

expressions_data = {
    'left_operand': ['x', 'x', 'x', 'y', 'y', 'x'],
    'operator': ['>', '<', '=', '>', '<', '='],
    'right_operand': ['y', 'y', 'y', 'x', 'x', 'x']
}
expressions_df = pd.DataFrame(expressions_data)

df = (
    variables_df.merge(expressions_df, left_on = 'name', right_on='left_operand')
    .merge(variables_df,right_on = 'name', left_on='right_operand' )
)

conditions = [
        (df['operator'] == '>') & (df['value_x'] > df['value_y']),
        (df['operator'] == '<') & (df['value_x'] < df['value_y']),
        (df['operator'] == '=') & (df['value_x'] == df['value_y'])
]

values = ['true','true','true']

df['value'] = np.select(conditions, values, default = 'false')

df = df[['left_operand','operator','right_operand','value']]
print(df)

#########################################################################################
# m2 

df = (
    variables_df.merge(expressions_df, left_on = 'name', right_on='left_operand')
    .merge(variables_df,right_on = 'name', left_on='right_operand' )
)
df['value'] = np.where(
    (
        ((df['operator'] == '>') & (df['value_x'] > df['value_y'])) |
        ((df['operator'] == '<') & (df['value_x'] < df['value_y'])) |
        ((df['operator'] == '=') & (df['value_x'] == df['value_y']))
    ),
    'true',
    'false'
)
df = df[['left_operand','operator','right_operand','value']]
print(df)