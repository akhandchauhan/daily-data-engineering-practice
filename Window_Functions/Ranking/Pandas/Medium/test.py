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
