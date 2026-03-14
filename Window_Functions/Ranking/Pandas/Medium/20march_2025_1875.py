# -- 1875. Group Employees of the Same Salary
# -- Level
# -- Medium
# -- Description
# -- Table: Employees
# -- +-------------+---------+
# -- | Column Name | Type    |
# -- +-------------+---------+
# -- | employee_id | int     |
# -- | name        | varchar |
# -- | salary      | int     |
# -- +-------------+---------+
# -- employee_id is the primary key for this table.
# -- Each row of this table indicates the employee ID, employee name, and salary.
# -- A company wants to divide the employees into teams such that all the members on each team
# -- have the same salary. The teams should follow these criteria:
# -- Each team should consist of at least two employees.
# -- All the employees on a team should have the same salary.
# -- All the employees of the same salary should be assigned to the same team.
# -- If the salary of an employee is unique, we do not assign this employee to any team.
# -- A team’s ID is assigned based on the rank of the team’s salary relative to the other teams’ salaries,
# -- where the team with the lowest salary has team_id = 1. Note that the salaries for employees 
# --not on a team are not included in this ranking.
# -- Write an  SQL query to get the team_id of each employee that is in a team.

# -- Return the result table ordered by team_id in ascending order. In case of a tie, order
# -- it by employee_id in ascending order.
# -- The query result format is in the following example:
# -- Employees table:
# -- +-------------+---------+--------+
# -- | employee_id | name    | salary |
# -- +-------------+---------+--------+
# -- | 2           | Meir    | 3000   |
# -- | 3           | Michael | 3000   |
# -- | 7           | Addilyn | 7400   |
# -- | 8           | Juan    | 6100   |
# -- | 9           | Kannon  | 7400   |
# -- +-------------+---------+--------+
# -- Result table:
# -- +-------------+---------+--------+---------+
# -- | employee_id | name    | salary | team_id |
# -- +-------------+---------+--------+---------+
# -- | 2           | Meir    | 3000   | 1       |
# -- | 3           | Michael | 3000   | 1       |
# -- | 7           | Addilyn | 7400   | 2       |
# -- | 9           | Kannon  | 7400   | 2       |
# -- +-------------+---------+--------+---------+

# -- Meir (employee_id=2) and Michael (employee_id=3) are in the same team because they have the same salary of 3000.
# -- Addilyn (employee_id=7) and Kannon (employee_id=9) are in the same team because they have the same salary of 7400.
# -- Juan (employee_id=8) is not included in any team because their salary of 6100 is unique (i.e. no other employee has the same salary).
# -- The team IDs are assigned as follows (based on salary ranking, lowest first):
# -- - team_id=1: Meir and Michael, salary of 3000
# -- - team_id=2: Addilyn and Kannon, salary of 7400
# -- Juan's salary of 6100 is not included in the ranking because they are not on a team.

import pandas as pd
data = {
    'employee_id' :[2,3,7,8,9],
    'name' : ['Meir','Michael','Addilyn','Juan','Kannon'],
    'salary' : [3000, 3000, 7400,6100,7400]
}
employee_df = pd.DataFrame(data)
employee_df2 = employee_df.groupby('salary')['employee_id'].agg(cnt = 'count').reset_index()
df = pd.merge(employee_df2,employee_df,on='salary',how='inner')
df = df.query('cnt > 1')
df = df.sort_values(by ='salary')
df['team_id'] = df['salary'].rank(method ='dense')
df = df[['employee_id','name','salary','team_id']]
print(df)


###################################################################################################################

#m2 using ranking functions

import pandas as pd
def team_creation(employee_df : pd.DataFrame) -> pd.DataFrame:
    # group by salary and filter groups whose count is less than 1
    employee_df['group_count'] = employee_df.groupby('salary')['employee_id'].transform('count')
    employee_df = employee_df[employee_df['group_count'] > 1]

    # use dense rank based on salary 
    employee_df['team_id']= employee_df['salary'].rank(method= 'dense').astype('int')

    employee_df = employee_df[['employee_id','name','salary','team_id']]

    return employee_df
    
# Create a dataframe
data = {
    'employee_id' :[2,3,7,8,9],
    'name' : ['Meir','Michael','Addilyn','Juan','Kannon'],
    'salary' : [3000, 3000, 7400,6100,7400]
}
employee_df = pd.DataFrame(data)

print(team_creation(employee_df))


###################################################################################################################
# m3 using chatgpt
import pandas as pd

def create_salary_teams(employee_df: pd.DataFrame) -> pd.DataFrame:
    """
    Assign team IDs to employees who share the same salary.

    Rules:
    - Employees form a team if at least two people share the same salary.
    - All employees with the same salary belong to the same team.
    - Team IDs are assigned by ascending salary order.
    """

    required_cols = {"employee_id", "name", "salary"}
    missing = required_cols - set(employee_df.columns)
    if missing:
        raise ValueError(f"Missing columns: {missing}")

    df = employee_df.copy()

    df = (
        df
        .assign(group_count=lambda x: x.groupby("salary")["employee_id"].transform("count"))
        .query("group_count > 1")
        .assign(team_id=lambda x: x["salary"].rank(method="dense").astype(int))
        .drop(columns="group_count")
        .sort_values(["team_id", "employee_id"])
    )

    return df