# -- 2993. Friday Purchases I
# -- Description
# -- Table: Purchases
# -- +---------------+------+
# -- | Column Name   | Type |
# -- +---------------+------+
# -- | user_id       | int  |
# -- | purchase_date | date |
# -- | amount_spend  | int  |
# -- +---------------+------+
# -- (user_id, purchase_date, amount_spend) is the primary key (combination of columns with unique values) 
# -- for this table.
# -- purchase_date will range from November 1, 2023, to November 30, 2023, inclusive of both dates.
# -- Each row contains user id, purchase date, and amount spend.
# -- Write a solution to calculate the total spending by users on each Friday of every week in 
# -- November 2023. Output only weeks that include at least one purchase on a Friday.
# -- Return the result table ordered by week of month in ascending order.
# -- The result format is in the following example.
# -- Example 1:
# -- Input: 
# -- Purchases table:
# -- +---------+---------------+--------------+
# -- | user_id | purchase_date | amount_spend |
# -- +---------+---------------+--------------+
# -- | 11      | 2023-11-07    | 1126         |
# -- | 15      | 2023-11-30    | 7473         |
# -- | 17      | 2023-11-14    | 2414         |
# -- | 12      | 2023-11-24    | 9692         |
# -- | 8       | 2023-11-03    | 5117         |
# -- | 1       | 2023-11-16    | 5241         |
# -- | 10      | 2023-11-12    | 8266         |
# -- | 13      | 2023-11-24    | 12000        |
# -- +---------+---------------+--------------+
# -- Output: 
# -- +---------------+---------------+--------------+
# -- | week_of_month | purchase_date | total_amount |
# -- +---------------+---------------+--------------+
# -- | 1             | 2023-11-03    | 5117         |
# -- | 4             | 2023-11-24    | 21692        |
# -- +---------------+---------------+--------------+ 
# -- Explanation: 
# -- - During the first week of November 2023, transactions amounting to $5,117 occurred on Friday, 2023-11-03.
# -- - For the second week of November 2023, there were no transactions on Friday, 2023-11-10.
# -- - Similarly, during the third week of November 2023, there were no transactions on Friday, 2023-11-17.
# -- - In the fourth week of November 2023, two transactions took place on Friday, 2023-11-24, amounting to $12,000 
# -- and $9,692 respectively, summing up to a total of $21,692.
# -- Output table is ordered by week_of_month in ascending order.

import pandas as pd

data = {
    'user_id': [11, 15, 17, 12, 8, 1, 10, 13],
    'purchase_date': ['2023-11-07', '2023-11-30', '2023-11-14', '2023-11-24', 
                     '2023-11-03', '2023-11-16', '2023-11-12', '2023-11-24'],
    'amount_spend': [1126, 7473, 2414, 9692, 5117, 5241, 8266, 12000]
}

purchases = pd.DataFrame(data)
purchases['purchase_date'] = pd.to_datetime(purchases['purchase_date'])
purchases['day_of_week'] = purchases['purchase_date'].dt.dayofweek
purchases['week_of_month'] = (purchases['purchase_date'].dt.day - 1) // 7 + 1

friday_purchases = purchases[purchases['day_of_week'] == 4]
result = friday_purchases.groupby(['week_of_month', 'purchase_date'])['amount_spend'].sum().reset_index()
result = result.rename(columns={'amount_spend': 'total_amount'})
result = result.sort_values('week_of_month').reset_index(drop=True)
result['purchase_date'] = result['purchase_date'].dt.strftime('%Y-%m-%d')

print(result)