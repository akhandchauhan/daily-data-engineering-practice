# 1613. Find the Missing IDs 
# Description
# Table: Customers
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | customer_id   | int     |
# | customer_name | varchar |
# +---------------+---------+
# customer_id is the column with unique values for this table.
# Each row of this table contains the name and the id customer.
# Write a solution to find the missing customer IDs. The missing IDs are ones that are not in the 
# Customers table but are in the range between 1 and the maximum customer_id present in the table.
# Notice that the maximum customer_id will not exceed 100.
# Return the result table ordered by ids in ascending order.
# The result format is in the following example.
# Example 1:
# Input: 
# Customers table:
# +-------------+---------------+
# | customer_id | customer_name |
# +-------------+---------------+
# | 1           | Alice         |
# | 4           | Bob           |
# | 5           | Charlie       |
# +-------------+---------------+
# Output: 
# +-----+
# | ids |
# +-----+
# | 2   |
# | 3   |
# +-----+
# Explanation: 
# The maximum customer_id present
#  in the table is 5, so in the range [1,5], IDs 2 and 3 are missing from the table.


import pandas as pd

customers_df = pd.DataFrame(
    {
        'customer_id' : [1,4,5],
        'customer_name':['Alice','Bob','Charlie']
    }
)

id_range_df = pd.DataFrame(range(1,customers_df['customer_id'].max()+1)).rename(columns ={0:'customer_id'})

df = (
    id_range_df.merge(customers_df, on ='customer_id',how ='left')
)
df = df[df['customer_name'].isna()][['customer_id']].rename(columns = {'customer_id':'id'}).reset_index(drop=True)
print(df)


################################################################################
# m2 

id_range_df = pd.DataFrame(range(1,customers_df['customer_id'].max()+1)).rename(columns ={0:'customer_id'})

df = (
    id_range_df
    .merge(customers_df, on='customer_id', how='left')
    .loc[lambda x: x['customer_name'].isna(), ['customer_id']]
    .rename(columns={'customer_id': 'id'})
    .reset_index(drop=True)
)



################################################################################
# m3
df = (
    pd.DataFrame({'customer_id': range(1, customers_df['customer_id'].max()+1)})
    .merge(customers_df[['customer_id']], on='customer_id', how='left', indicator=True)
    .loc[lambda x: x['_merge'] == 'left_only', ['customer_id']]
    .rename(columns={'customer_id': 'id'})
    .reset_index(drop=True)
)