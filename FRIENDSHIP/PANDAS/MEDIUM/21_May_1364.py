
# 1364. Number of Trusted Contacts of a Customer

# Table: Customers
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | customer_id   | int     |
# | customer_name | varchar |
# | email         | varchar |
# +---------------+---------+
# customer_id is the column of unique values for this table.
# Each row of this table contains the name and the email of a customer of an online shop.

# Table: Contacts
# +---------------+---------+
# | Column Name   | Type    |
# +---------------+---------+
# | user_id       | id      |
# | contact_name  | varchar |
# | contact_email | varchar |
# +---------------+---------+
# (user_id, contact_email) is the primary key (combination of columns with unique values) for this 
# table.
# Each row of this table contains the name and email of one contact of customer with user_id.
# This table contains information about people each customer trust. The contact may or may not 
# exist in the Customers table.

# Table: Invoices
# +--------------+---------+
# | Column Name  | Type    |
# +--------------+---------+
# | invoice_id   | int     |
# | price        | int     |
# | user_id      | int     |
# +--------------+---------+
# invoice_id is the column of unique values for this table.
# Each row of this table indicates that user_id has an invoice with invoice_id and a price.
 

# Write a solution to find the following for each invoice_id:

# customer_name: The name of the customer the invoice is related to.
# price: The price of the invoice.
# contacts_cnt: The number of contacts related to the customer.
# trusted_contacts_cnt: The number of contacts related to the customer and at the same time 
# they are customers to the shop. (i.e their email exists in the Customers table.)
# Return the result table ordered by invoice_id.

# Customers table:
# +-------------+---------------+--------------------+
# | customer_id | customer_name | email              |
# +-------------+---------------+--------------------+
# | 1           | Alice         | alice@leetcode.com |
# | 2           | Bob           | bob@leetcode.com   |
# | 13          | John          | john@leetcode.com  |
# | 6           | Alex          | alex@leetcode.com  |
# +-------------+---------------+--------------------+

# Contacts table:
# +-------------+--------------+--------------------+
# | user_id     | contact_name | contact_email      |
# +-------------+--------------+--------------------+
# | 1           | Bob          | bob@leetcode.com   |
# | 1           | John         | john@leetcode.com  |
# | 1           | Jal          | jal@leetcode.com   |
# | 2           | Omar         | omar@leetcode.com  |
# | 2           | Meir         | meir@leetcode.com  |
# | 6           | Alice        | alice@leetcode.com |
# +-------------+--------------+--------------------+

# Invoices table:
# +------------+-------+---------+
# | invoice_id | price | user_id |
# +------------+-------+---------+
# | 77         | 100   | 1       |
# | 88         | 200   | 1       |
# | 99         | 300   | 2       |
# | 66         | 400   | 2       |
# | 55         | 500   | 13      |
# | 44         | 60    | 6       |
# +------------+-------+---------+
# Output: 
# +------------+---------------+-------+--------------+----------------------+
# | invoice_id | customer_name | price | contacts_cnt | trusted_contacts_cnt |
# +------------+---------------+-------+--------------+----------------------+
# | 44         | Alex          | 60    | 1            | 1                    |
# | 55         | John          | 500   | 0            | 0                    |
# | 66         | Bob           | 400   | 2            | 0                    |
# | 77         | Alice         | 100   | 3            | 2                    |
# | 88         | Alice         | 200   | 3            | 2                    |
# | 99         | Bob           | 300   | 2            | 0                    |
# +------------+---------------+-------+--------------+----------------------+
# Explanation: 
# Alice has three contacts, two of them are trusted contacts (Bob and John).
# Bob has two contacts, none of them is a trusted contact.
# Alex has one contact and it is a trusted contact (Alice).
# John doesn't have any contacts.


import pandas as pd
pd.set_option("display.max_columns", None)
customers = pd.DataFrame({
    'customer_id': [1, 2, 13, 6],
    'customer_name': ['Alice', 'Bob', 'John', 'Alex'],
    'email': [
        'alice@leetcode.com',
        'bob@leetcode.com',
        'john@leetcode.com',
        'alex@leetcode.com'
    ]
})

contacts = pd.DataFrame({
    'user_id': [1, 1, 1, 2, 2, 6],
    'contact_name': ['Bob', 'John', 'Jal', 'Omar', 'Meir', 'Alice'],
    'contact_email': [
        'bob@leetcode.com',
        'john@leetcode.com',
        'jal@leetcode.com',
        'omar@leetcode.com',
        'meir@leetcode.com',
        'alice@leetcode.com'
    ]
})

invoices = pd.DataFrame({
    'invoice_id': [77, 88, 99, 66, 55, 44],
    'price': [100, 200, 300, 400, 500, 60],
    'user_id': [1, 1, 2, 2, 13, 6]
})

merged_df = (
    invoices.merge(customers, how = 'left', left_on = 'user_id', right_on = 'customer_id')
    .merge(contacts, how = 'left', left_on = 'customer_id', right_on = 'user_id')
    .merge(customers, how = 'left', left_on = 'contact_email', right_on='email' )
    .groupby(['invoice_id', 'customer_name_x', 'price'], as_index = False)
    .agg(
        contacts_cnt = ('user_id_y','count'),
        trusted_contacts_cnt = ('email_y', 'count')
    )
    .rename(columns = {'customer_name_x' :'customer_name'})
    .sort_values(by = ['invoice_id'])
)

print(merged_df)