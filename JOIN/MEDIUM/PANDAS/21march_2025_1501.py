# -- 1501. Countries You Can Safely Invest In
# -- Description
# -- Table Person:
# -- +----------------+---------+
# -- | Column Name    | Type    |
# -- +----------------+---------+
# -- | id             | int     |
# -- | name           | varchar |
# -- | phone_number   | varchar |
# -- +----------------+---------+
# -- id is the column of unique values for this table.
# -- Each row of this table contains the name of a person and their phone number.
# -- Phone number will be in the form 'xxx-yyyyyyy' where xxx is the country code (3 characters) 
# -- and yyyyyyy is the phone number (7 characters) where x and y are digits. Both can contain leading zeros.
# -- Table Country:
# -- +----------------+---------+
# -- | Column Name    | Type    |
# -- +----------------+---------+
# -- | name           | varchar |
# -- | country_code   | varchar |
# -- +----------------+---------+
# -- country_code is the column of unique values for this table.
# -- Each row of this table contains the country name and its code. 
# --country_code will be in the form 'xxx' where x is digits.
# -- Table Calls:
# -- +-------------+------+
# -- | Column Name | Type |
# -- +-------------+------+
# -- | caller_id   | int  |
# -- | callee_id   | int  |
# -- | duration    | int  |
# -- +-------------+------+
# -- This table may contain duplicate rows.
# -- Each row of this table contains the caller id, callee id and the 
# --duration of the call in minutes. caller_id != callee_id
# -- A telecommunications company wants to invest in new countries. 
# --The company intends to invest in the countries where the 
# -- average call duration of the calls in this country is strictly 
# --greater than the global average call duration.
# -- Write a solution to find the countries where this company can invest.
# -- Return the result table in any order.
# -- The result format is in the following example.
# -- Example 1:
# -- Input: 
# -- Person table:
# -- +----+----------+--------------+
# -- | id | name     | phone_number |
# -- +----+----------+--------------+
# -- | 3  | Jonathan | 051-1234567  |
# -- | 12 | Elvis    | 051-7654321  |
# -- | 1  | Moncef   | 212-1234567  |
# -- | 2  | Maroua   | 212-6523651  |
# -- | 7  | Meir     | 972-1234567  |
# -- | 9  | Rachel   | 972-0011100  |
# -- +----+----------+--------------+
# -- Country table:
# -- +----------+--------------+
# -- | name     | country_code |
# -- +----------+--------------+
# -- | Peru     | 051          |
# -- | Israel   | 972          |
# -- | Morocco  | 212          |
# -- | Germany  | 049          |
# -- | Ethiopia | 251          |
# -- +----------+--------------+
# -- Calls table:
# -- +-----------+-----------+----------+
# -- | caller_id | callee_id | duration |
# -- +-----------+-----------+----------+
# -- | 1         | 9         | 33       |
# -- | 2         | 9         | 4        |
# -- | 1         | 2         | 59       |
# -- | 3         | 12        | 102      |
# -- | 3         | 12        | 330      |
# -- | 12        | 3         | 5        |
# -- | 7         | 9         | 13       |
# -- | 7         | 1         | 3        |
# -- | 9         | 7         | 1        |
# -- | 1         | 7         | 7        |
# -- +-----------+-----------+----------+
# -- Output: 
# -- +----------+
# -- | country  |
# -- +----------+
# -- | Peru     |
# -- +----------+
# -- Explanation: 
# -- The average call duration for Peru is (102 + 102 + 330 + 330 + 5 + 5) / 6 = 145.666667
# -- The average call duration for Israel is (33 + 4 + 13 + 13 + 3 + 1 + 1 + 7) / 8 = 9.37500
# -- The average call duration for Morocco is (33 + 4 + 59 + 59 + 3 + 7) / 6 = 27.5000 
# -- Global call duration average = (2 * (33 + 4 + 59 + 102 + 330 + 5 + 13 + 3 + 1 + 7)) / 20 = 55.70000
# -- Since Peru is the only country where the average call duration is greater than the global average, it is the only

import pandas as pd

person = pd.DataFrame({
    "id": [3, 12, 1, 2, 7, 9],
    "name": ["Jonathan", "Elvis", "Moncef", "Maroua", "Meir", "Rachel"],
    "phone_number": [
        "051-1234567", "051-7654321", "212-1234567",
        "212-6523651", "972-1234567", "972-0011100"
    ]
})

country = pd.DataFrame({
    "name": ["Peru", "Israel", "Morocco", "Germany", "Ethiopia"],
    "country_code": ["051", "972", "212", "049", "251"]
})

calls = pd.DataFrame({
    "caller_id": [1, 2, 1, 3, 3, 12, 7, 7, 9, 1],
    "callee_id": [9, 9, 2, 12, 12, 3, 9, 1, 7, 7],
    "duration": [33, 4, 59, 102, 330, 5, 13, 3, 1, 7]
})

person["country_code"] = person["phone_number"].str[:3]

person_country = (
    person
    .merge(country, on="country_code", how="left")
    [["id", "name_y"]]
    .rename(columns={"name_y": "country"})
)

caller_calls = calls[["caller_id", "duration"]].rename(columns={"caller_id": "id"})
callee_calls = calls[["callee_id", "duration"]].rename(columns={"callee_id": "id"})

all_calls = pd.concat([caller_calls, callee_calls], ignore_index=True)

calls_with_country = all_calls.merge(person_country, on="id", how="left")

country_avg = (
    calls_with_country
    .groupby("country", as_index=False)["duration"]
    .mean()
)

global_avg = calls_with_country["duration"].mean()

result = country_avg[country_avg["duration"] > global_avg][["country"]]

print(result)


