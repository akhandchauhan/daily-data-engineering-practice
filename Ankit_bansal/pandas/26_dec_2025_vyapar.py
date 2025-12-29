
# -- A company organizes a felicitation event to cheer up its employees and clients
# -- and keep them motivated. The company has many departments, and in this event,
# -- the company wants to felicitate its best employees and clients of each department.
# --
# -- An employee who has the most sales in his/her department is considered
# -- the best employee in that department.
# --
# -- A client who has contributed the highest sales to a department is considered
# -- the best client of that department.
# --
# -- You are given the following tables:
# --   1. empdetails
# --   2. empsales
# --   3. department
# --   4. client
# --
# -- Write a query to find the client_id and emp_id of the best client and the
# -- best employee respectively for each department.

import pandas as pd

# department table
department_df = pd.DataFrame({
    "dep_id": [1, 2, 3],
    "dep_name": ["Electronics", "Furniture", "Clothing"]
})

# empdetails table
empdetails_df = pd.DataFrame({
    "emp_id": [101, 102, 103, 104, 105, 106],
    "first_name": ["Alice", "Bob", "Charlie", "Diana", "Ethan", "Fiona"],
    "gender": ["F", "M", "M", "F", "M", "F"],
    "dep_id": [1, 1, 2, 2, 3, 3]
})

# client table
client_df = pd.DataFrame({
    "client_id": [1, 2, 3, 4, 5],
    "client_name": ["Amazon", "Walmart", "Costco", "Target", "BestBuy"]
})

# empsales table
empsales_df = pd.DataFrame({
    "emp_id": [101, 101, 102, 102, 103, 103, 104, 105, 106, 106],
    "client_id": [1, 2, 1, 3, 2, 4, 4, 5, 3, 5],
    "sales": [5000, 3000, 7000, 2000, 4000, 3000, 6000, 8000, 5000, 2000]
})

# m1 the long method
df_merged = pd.merge(empdetails_df, empsales_df, how ='inner',on ='emp_id')

emp_df = df_merged.groupby(['dep_id','emp_id'])['sales'].sum().reset_index()
emp_df = emp_df.sort_values(by = ['dep_id','sales'], ascending= [True, False])
emp_df['rnk'] = emp_df.groupby('dep_id').cumcount() + 1
emp_df = emp_df.query("rnk == 1")[['dep_id','emp_id']]


# similar thing can be done for client side

client_df = df_merged.groupby(['dep_id','client_id'])['sales'].sum().reset_index()
client_df = client_df.sort_values(by = ['dep_id','sales'], ascending= [True, False])
client_df['rnk'] = client_df.groupby('dep_id').cumcount() + 1
client_df = client_df.query("rnk == 1")[['dep_id','client_id']]

# final ans show

final_df = pd.merge(client_df,emp_df,how ='inner',on ='dep_id')
print(final_df)

#########################################################################################################


# m2 = repeated code for client and emp used in function

def get_top_performer_by_dept(merged_df, performer_col):
 
    df = (merged_df
          .groupby(['dep_id', performer_col], as_index=False)['sales']
          .sum()
          .sort_values(['dep_id', 'sales'], ascending=[True, False]))
    
    df['rank'] = df.groupby('dep_id').cumcount() + 1
    
    return df[df['rank'] == 1][['dep_id', performer_col]]

# Merge employee details with sales
sales_with_dept = empdetails_df.merge(empsales_df, on='emp_id', how='inner')

# Get best employee and client per department
best_employees = get_top_performer_by_dept(sales_with_dept, 'emp_id')
best_clients = get_top_performer_by_dept(sales_with_dept, 'client_id')

# Combine results
result = best_employees.merge(best_clients, on='dep_id', how='inner')
print(result)



#########################################################################################################
# m3 

# CTE 1: Join empsales with empdetails
cte = empsales_df.merge(empdetails_df[['emp_id', 'dep_id']], on='emp_id', how='inner')

# CTE 2: Combine employee and client sales with UNION ALL
emp_sales = (cte
             .groupby(['dep_id', 'emp_id'], as_index=False)['sales']
             .sum()
             .rename(columns={'emp_id': 'id'})
             .assign(sale_type='emp'))

client_sales = (cte
                .groupby(['dep_id', 'client_id'], as_index=False)['sales']
                .sum()
                .rename(columns={'client_id': 'id'})
                .assign(sale_type='client'))

emp_client_cte = pd.concat([emp_sales, client_sales], ignore_index=True)

# CTE 3: Add row number (ranking)
emp_client_cte = emp_client_cte.sort_values(['dep_id', 'sale_type', 'sales'], 
                                              ascending=[True, True, False])
emp_client_cte['rn'] = emp_client_cte.groupby(['dep_id', 'sale_type']).cumcount() + 1

# Final SELECT: Pivot to get client_id and emp_id columns
ranked_cte = emp_client_cte[emp_client_cte['rn'] == 1]

result = ranked_cte.pivot_table(
    index='dep_id',
    columns='sale_type',
    values='id',
    aggfunc='first'
).reset_index()

result.columns.name = None
result = result.rename(columns={'client': 'client_id', 'emp': 'emp_id'})

print(result)