# 2372. Calculate the Influence of Each Salesperson 
# Description
# Table: Salesperson
# +----------------+---------+
# | Column Name    | Type    |
# +----------------+---------+
# | salesperson_id | int     |
# | name           | varchar |
# +----------------+---------+
# salesperson_id contains unique values.
# Each row in this table shows the ID of a salesperson.
 
# Table: Customer
# +----------------+------+
# | Column Name    | Type |
# +----------------+------+
# | customer_id    | int  |
# | salesperson_id | int  |
# +----------------+------+
# customer_id contains unique values.
# salesperson_id is a foreign key (reference column) from the Salesperson table.
# Each row in this table shows the ID of a customer and the ID of the salesperson. 

# Table: Sales
# +-------------+------+
# | Column Name | Type |
# +-------------+------+
# | sale_id     | int  |
# | customer_id | int  |
# | price       | int  |
# +-------------+------+
# sale_id contains unique values.
# customer_id is a foreign key (reference column) from the Customer table.
# Each row in this table shows ID of a customer and the price they paid for the sale with sale_id.

# Write a solution to report the sum of prices paid by the customers of each salesperson.
# If a salesperson does not have any customers, the total value should be 0.

# Return the result table in any order.
# Example 1:

# Input: 
# Salesperson table:
# +----------------+-------+
# | salesperson_id | name  |
# +----------------+-------+
# | 1              | Alice |
# | 2              | Bob   |
# | 3              | Jerry |
# +----------------+-------+
# Customer table:
# +-------------+----------------+
# | customer_id | salesperson_id |
# +-------------+----------------+
# | 1           | 1              |
# | 2           | 1              |
# | 3           | 2              |
# +-------------+----------------+
# Sales table:
# +---------+-------------+-------+
# | sale_id | customer_id | price |
# +---------+-------------+-------+
# | 1       | 2           | 892   |
# | 2       | 1           | 354   |
# | 3       | 3           | 988   |
# | 4       | 3           | 856   |
# +---------+-------------+-------+
# Output: 
# +----------------+-------+-------+
# | salesperson_id | name  | total |
# +----------------+-------+-------+
# | 1              | Alice | 1246  |
# | 2              | Bob   | 1844  |
# | 3              | Jerry | 0     |
# +----------------+-------+-------+

# Explanation: 
# Alice is the salesperson for customers 1 and 2.
#   - Customer 1 made one purchase with 354.
#   - Customer 2 made one purchase with 892.
# The total for Alice is 354 + 892 = 1246.
# Bob is the salesperson for customers 3.
#   - Customer 1 made one purchase with 988 and 856.
# The total for Bob is 988 + 856 = 1844.
# Jerry is not the salesperson of any customer.
# The total for Jerry is 0.



import pandas as pd

# Salesperson table
salesperson = pd.DataFrame({
    "salesperson_id": [1, 2, 3],
    "name": ["Alice", "Bob", "Jerry"]
})

# Customer table
customer = pd.DataFrame({
    "customer_id": [1, 2, 3],
    "salesperson_id": [1, 1, 2]
})

# Sales table
sales = pd.DataFrame({
    "sale_id": [1, 2, 3, 4],
    "customer_id": [2, 1, 3, 3],
    "price": [892, 354, 988, 856]
})


df = salesperson.merge(customer, how ='left', on ='salesperson_id')
df = (df.merge(sales, how = 'left', on = 'customer_id')
        .groupby(['salesperson_id','name'])
        .agg(total = ('price','sum')).astype(int)
        .reset_index()
        .fillna(0)
)
print(df)


##################################################################################################

# m2

sales_agg = (
    sales.groupby('customer_id', as_index=False)
         .agg(total_spent=('price', 'sum'))
)

df = (
    salesperson
        .merge(customer, how='left', on='salesperson_id')
        .merge(sales_agg, how='left', on='customer_id')
        .groupby(['salesperson_id', 'name'], as_index=False)
        .agg(total=('total_spent', 'sum'))
        .fillna(0)
        .astype({'total': int})
)
print(df)