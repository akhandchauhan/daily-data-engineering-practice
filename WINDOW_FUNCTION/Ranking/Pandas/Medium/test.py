import pandas as pd


project_data = {
    'project_id': [1, 1, 1, 2, 2],
    'employee_id': [1, 2, 3, 1, 4]
}


employee_data = {
    'employee_id': [1, 2, 3, 4],
    'name': ['Khaled', 'Ali', 'John', 'Doe'],
    'experience_years': [3, 2, 3, 2]
}

# Create DataFrames
project_df = pd.DataFrame(project_data)
employee_df = pd.DataFrame(employee_data)


# m1 using max

merged_df = project_df.merge(employee_df, on = 'employee_id')

# max_experience_df = ( merged_df
#                      .groupby('project_id', as_index = False )['experience_years']
#                      .max()
#                      .rename(columns = {'experience_years':'max_experience_years'})
# )

# final_df = ( merged_df.merge(max_experience_df, on = ['project_id'])
#             .query("experience_years == max_experience_years")
#             [['project_id','employee_id']]
# )
# print(final_df)


################################################################################################

#m2 using dense rank
merged_df = project_df.merge(employee_df, on = 'employee_id')
merged_df['max_experience_years'] = (
                        merged_df
                        .groupby('project_id')['experience_years']
                        .rank(method = 'dense', ascending = False)
                        
)
merged_df = merged_df.query("max_experience_years == 1")[['project_id','employee_id']].reset_index(drop = True)
print(merged_df)



################################################################################################
# m3 max using transform

# merged = project_df.merge(employee_df, on='employee_id')
# max_exp = merged.groupby('project_id')['experience_years'].transform('max')

# result = merged[merged['experience_years'] == max_exp][['project_id','employee_id']]