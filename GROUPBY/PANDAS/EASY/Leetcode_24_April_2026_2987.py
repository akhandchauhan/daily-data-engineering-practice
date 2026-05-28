# 2987. Find Expensive Cities
# Description
# Table: Listings
# +-------------+---------+
# | Column Name | Type    |
# +-------------+---------+
# | listing_id  | int     |
# | city        | varchar |
# | price       | int     |
# +-------------+---------+
# listing_id is column of unique values for this table.
# This table contains listing_id, city, and price.

# Write a solution to find cities where the average home prices exceed the 
# national average home price.

# Return the result table sorted by city in ascending order.

# Input: 
# Listings table:
# +------------+--------------+---------+
# | listing_id | city         | price   | 
# +------------+--------------+---------+
# | 113        | LosAngeles   | 7560386 | 
# | 136        | SanFrancisco | 2380268 |
# | 92         | Chicago      | 9833209 | 
# | 60         | Chicago      | 5147582 | 
# | 8          | Chicago      | 5274441 |  
# | 79         | SanFrancisco | 8372065 | 
# | 37         | Chicago      | 7939595 | 
# | 53         | LosAngeles   | 4965123 | 
# | 178        | SanFrancisco | 999207  | 
# | 51         | NewYork      | 5951718 | 
# | 121        | NewYork      | 2893760 | 
# +------------+--------------+---------+
# Output
# +------------+
# | city       | 
# +------------+
# | Chicago    | 
# | LosAngeles |  
# +------------+
# Explanation
# The national average home price is $6,122,059.45. Among the cities listed:
# - Chicago has an average price of $7,043,706.75
# - Los Angeles has an average price of $6,277,754.5
# - San Francisco has an average price of $3,900,513.33
# - New York has an average price of $4,422,739
# Only Chicago and Los Angeles have average home prices exceeding the national average. 
# Therefore, these two cities are included in the output table. 
# The output table is sorted in ascending order based on the city names.


import pandas as pd

data = [
    (113, "LosAngeles", 7560386),
    (136, "SanFrancisco", 2380268),
    (92, "Chicago", 9833209),
    (60, "Chicago", 5147582),
    (8, "Chicago", 5274441),
    (79, "SanFrancisco", 8372065),
    (37, "Chicago", 7939595),
    (53, "LosAngeles", 4965123),
    (178, "SanFrancisco", 999207),
    (51, "NewYork", 5951718),
    (121, "NewYork", 2893760)
]

listings = pd.DataFrame(data, columns=["listing_id", "city", "price"])

# m1
overall_avg_price = listings['price'].mean()

df = (
    listings.groupby("city", as_index = False)['price']
    .mean()
    .loc[lambda d: d['price'] > overall_avg_price]
    [['city']]
    .sort_values('city')
)

print(df)

#############################################################################

# m2 

df = (
    listings
    .assign(
        overall_avg_price = lambda d: d['price'].mean(),
        city_price_avg = lambda d: d.groupby('city')['price'].transform("mean")
    )
    .loc[lambda d: d['city_price_avg'] > d['overall_avg_price']]
    [['city']]
    .drop_duplicates()
    .sort_values('city')
)
print(df)