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
# -- Explanation: Only the customer_id with id 3 bought the product A and B but not the product C.

# import pandas as pd

# # Sample data
# customers_data = {
#     "customer_id": [1, 2, 3, 4],
#     "customer_name": ["Daniel", "Diana", "Elizabeth", "Jhon"]
# }
# orders_data = {
#     "order_id": [10, 20, 30, 40, 50, 60, 70, 80, 90],
#     "customer_id": [1, 1, 1, 1, 2, 3, 3, 3, 4],
#     "product_name": ["A", "B", "D", "C", "A", "A", "B", "D", "C"]
# }

# # Create DataFrames
# customers_df = pd.DataFrame(customers_data)
# orders_df = pd.DataFrame(orders_data)

# # Count occurrences of each product per customer
# df = pd.merge(customers_df, orders_df, on="customer_id", how="left")
# df["cnt"] = df.groupby(["customer_name", "product_name"])["product_name"].transform("count")

# def check(row):
#     products = orders_df[orders_df["customer_id"] == row["customer_id"]]["product_name"].unique()
#     # print(products)
#     return "A" in products and "B" in products and "C" not in products

# # Filter customers using the check function
# filtered_customers = customers_df[customers_df.apply(check, axis=1)]
# filtered_customers = filtered_customers.sort_values(by="customer_id")
# print(filtered_customers)




# 1715. Count Apples and Oranges
# -- Level
# -- Medium
# -- Description
# -- Table: Boxes
# -- +--------------+------+
# -- | Column Name  | Type |
# -- +--------------+------+
# -- | box_id       | int  |
# -- | chest_id     | int  |
# -- | apple_count  | int  |
# -- | orange_count | int  |
# -- +--------------+------+
# -- box_id is the primary key for this table.
# -- chest_id is a foreign key of the chests table.
# -- This table contains information about the boxes and the number of oranges and apples they contain.
# -- Each box may contain a chest, which also can contain oranges and apples.
# -- Table: Chests
# -- +--------------+------+
# -- | Column Name  | Type |
# -- +--------------+------+
# -- | chest_id     | int  |
# -- | apple_count  | int  |
# -- | orange_count | int  |
# -- +--------------+------+
# -- chest_id is the primary key for this table.
# -- This table contains information about the chests we have, and the corresponding number if oranges and apples they contain.
# -- Write an  SQL query to count the number of  apples and oranges in all the boxes.
# -- If a box contains a chest, you should also include the number of apples and oranges it has.
# -- Return the result table in any order.
# -- The query result format is in the following example:
# -- Boxes table:
# -- +--------+----------+-------------+--------------+
# -- | box_id | chest_id | apple_count | orange_count |
# -- +--------+----------+-------------+--------------+
# -- | 2      | null     | 6           | 15           |
# -- | 18     | 14       | 4           | 15           |
# -- | 19     | 3        | 8           | 4            |
# -- | 12     | 2        | 19          | 20           |
# -- | 20     | 6        | 12          | 9            |
# -- | 8      | 6        | 9           | 9            |
# -- | 3      | 14       | 16          | 7            |
# -- +--------+----------+-------------+--------------+
# -- Chests table:
# -- +----------+-------------+--------------+
# -- | chest_id | apple_count | orange_count |
# -- +----------+-------------+--------------+
# -- | 6        | 5           | 6            |
# -- | 14       | 20          | 10           |
# -- | 2        | 8           | 8            |
# -- | 3        | 19          | 4            |
# -- | 16       | 19          | 19           |
# -- +----------+-------------+--------------+
# -- Result table:
# -- +-------------+--------------+
# -- | apple_count | orange_count |
# -- +-------------+--------------+
# -- | 151         | 123          |
# -- +-------------+--------------+

import pandas as pd

# Sample data
boxes_data = {
    "box_id": [2, 18, 19, 12, 20, 8, 3],
    "chest_id": [None, 14, 3, 2, 6, 6, 14],
    "apple_count": [6, 4, 8, 19, 12, 9, 16],
    "orange_count": [15, 15, 4, 20, 9, 9, 7]
}

chests_data = {
    "chest_id": [6, 14, 2, 3, 16],
    "apple_count": [5, 20, 8, 19, 19],
    "orange_count": [6, 10, 8, 4, 19]
}

# Create DataFrames
boxes_df = pd.DataFrame(boxes_data)
chests_df = pd.DataFrame(chests_data)


# m1 

# merged_df = boxes_df.merge(chests_df, on="chest_id", how="left", suffixes=("_box", "_chest"))

# # Fill NaN values with 0 where there is no chest
# total_apples = (merged_df["apple_count_box"] + merged_df["apple_count_chest"].fillna(0)).sum()
# total_oranges = (merged_df["orange_count_box"] + merged_df["orange_count_chest"].fillna(0)).sum()

# # Create result DataFrame
# result_df = pd.DataFrame({"apple_count": [total_apples], "orange_count": [total_oranges]})

# # Display result
# print(result_df)


# m2 

# df= pd.merge(boxes_df, chests_df, how ='left', on ='chest_id').fillna(0)
# df['apple_count'] = df['apple_count_x'] + df['apple_count_y']
# df['orange_count'] = df['orange_count_x'] + df['orange_count_y']
# df = df[['apple_count','orange_count']]
# new_df = pd.DataFrame({
#     'apple_count': [df['apple_count'].sum()],
#     'orange_count': [df['orange_count'].sum()]
# })

