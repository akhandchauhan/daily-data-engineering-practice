
# Question:
# You are given an Orders table with the following columns:

# Customer_id : ID of the customer
# Order_date  : Date when the order was placed
# coupon_code : Coupon code used in the order
#               (can be NULL if no coupon was applied)

# Write an SQL query to return the number of new customers
# who satisfy all of the following conditions:

# 1. They place orders in each of their first 3 consecutive months
#    since their very first order.

# 2. The number of orders in the second month is exactly double
#    the number of orders in the first month.

# 3. The number of orders in the third month is exactly triple
#    the number of orders in the first month.

# 4. Their last order (latest by date) was placed with a coupon code
#    (i.e., coupon_code IS NOT NULL).


import pandas as pd
import datetime as dt

data = [
    # Customer 1
    (1, '2025-01-10', None),
    (1, '2025-02-05', None),
    (1, '2025-02-20', None),
    (1, '2025-03-01', None),
    (1, '2025-03-10', None),
    (1, '2025-03-15', 'DISC10'),

    # Customer 2
    (2, '2025-02-02', None),
    (2, '2025-02-05', None),
    (2, '2025-03-05', None),
    (2, '2025-03-18', None),
    (2, '2025-03-20', None),
    (2, '2025-03-22', None),
    (2, '2025-04-02', None),
    (2, '2025-04-10', None),
    (2, '2025-04-15', 'DISC20'),
    (2, '2025-04-16', None),
    (2, '2025-04-18', None),
    (2, '2025-04-20', 'DISC20'),

    # Customer 3
    (3, '2025-03-05', None),
    (3, '2025-04-10', None),
    (3, '2025-05-15', 'DISC30'),

    # Customer 4
    (4, '2025-02-01', None),
    (4, '2025-04-05', 'DISC40'),

    # Customer 5
    (5, '2025-01-03', None),
    (5, '2025-02-05', None),
    (5, '2025-02-15', None),
    (5, '2025-03-01', None),
    (5, '2025-03-08', 'DISC50'),
    (5, '2025-03-20', None),

    # Customer 6
    (6, '2025-01-05', None),
    (6, '2025-03-02', None),
    (6, '2025-03-15', None),
    (6, '2025-05-05', None),
    (6, '2025-05-10', None),
    (6, '2025-05-25', 'DISC60'),
]

df = pd.DataFrame(data, columns=['customer_id', 'order_date', 'coupon_code'])
df['order_date'] = pd.to_datetime(df['order_date'])


# dense rank the customers based on order
df['format_order_dt'] = df['order_date'].dt.strftime('%Y-%m-01')
df = df.sort_values(by = ['customer_id','format_order_dt'], ascending= [True, True])
df['order_rnk'] = df.groupby('customer_id')['format_order_dt'].rank(method = 'dense')

print(df)

