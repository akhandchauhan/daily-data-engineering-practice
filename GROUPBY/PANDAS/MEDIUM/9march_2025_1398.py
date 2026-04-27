# -- 1398. Customers Who Bought Products A and B but Not C
# -- Description
# -- Table: Customers
# -- +---------------------+---------+
# -- | Column Name         | Type    |
# -- +---------------------+---------+
# -- | customer_id         | int     |
# -- | customer_name       | varchar |
# -- +---------------------+---------+
# -- customer_id is the column with unique values for this table.
# -- customer_name is the name of the customer.
# -- Table: Orders
# -- +---------------+---------+
# -- | Column Name   | Type    |
# -- +---------------+---------+
# -- | order_id      | int     |
# -- | customer_id   | int     |
# -- | product_name  | varchar |
# -- +---------------+---------+
# -- order_id is the column with unique values for this table.
# -- customer_id is the id of the customer who bought the product "product_name".
# -- Write a solution to report the customer_id and customer_name of customers who bought products "A",
# "B" but did not buy the product "C"
# --  since we want to recommend them to purchase this product.
# -- Return the result table ordered by customer_id.
# -- Example 1:
# -- Input: 
# -- Customers table:
# -- +-------------+---------------+
# -- | customer_id | customer_name |
# -- +-------------+---------------+
# -- | 1           | Daniel        |
# -- | 2           | Diana         |
# -- | 3           | Elizabeth     |
# -- | 4           | Jhon          |
# -- +-------------+---------------+
# -- Orders table:
# -- +------------+--------------+---------------+
# -- | order_id   | customer_id  | product_name  |
# -- +------------+--------------+---------------+
# -- | 10         |     1        |     A         |
# -- | 20         |     1        |     B         |
# -- | 30         |     1        |     D         |
# -- | 40         |     1        |     C         |
# -- | 50         |     2        |     A         |
# -- | 60         |     3        |     A         |
# -- | 70         |     3        |     B         |
# -- | 80         |     3        |     D         |
# -- | 90         |     4        |     C         |
# -- +------------+--------------+---------------+
# -- Output: 
# -- +-------------+---------------+
# -- | customer_id | customer_name |
# -- +-------------+---------------+
# -- | 3           | Elizabeth     |
# -- +-------------+---------------+
# -- Explanation: Only the customer_id with id 3 bought the product A and B 
# -- but not the product C.

import pandas as pd

# Sample data
customers_data = {
    "customer_id": [1, 2, 3, 4],
    "customer_name": ["Daniel", "Diana", "Elizabeth", "Jhon"]
}
orders_data = {
    "order_id": [10, 20, 30, 40, 50, 60, 70, 80, 90],
    "customer_id": [1, 1, 1, 1, 2, 3, 3, 3, 4],
    "product_name": ["A", "B", "D", "C", "A", "A", "B", "D", "C"]
}

# Create DataFrames
customers_df = pd.DataFrame(customers_data)
orders_df = pd.DataFrame(orders_data)

# Count occurrences of each product per customer
df = pd.merge(customers_df, orders_df, on="customer_id", how="left")
df["cnt"] = df.groupby(["customer_name", "product_name"])["product_name"].transform("count")

def check(row):
    products = orders_df[orders_df["customer_id"] == row["customer_id"]]["product_name"].unique()
    # print(products)
    return "A" in products and "B" in products and "C" not in products

# Filter customers using the check function
filtered_customers = customers_df[customers_df.apply(check, axis=1)]
filtered_customers = filtered_customers.sort_values(by="customer_id")
# print(filtered_customers)

