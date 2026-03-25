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

