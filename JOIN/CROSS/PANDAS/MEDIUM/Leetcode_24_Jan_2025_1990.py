# 1990. Count the Number of Experiments
# Level
# Description
# Table: Experiments
# +-----------------+------+
# | Column Name     | Type |
# +-----------------+------+
# | experiment_id   | int  |
# | platform        | enum |
# | experiment_name | enum |
# +-----------------+------+
# experiment_id is the primary key for this table.
# platform is an enum with one of the values ('Android', 'IOS', 'Web').
# experiment_name is an enum with one of the values ('Reading', 'Sports', 'Programming').
# This table contains information about the ID of an experiment done with a random person,
# the platform used to do the experiment, and the name of the experiment.
# Write an  SQL query to report the number of experiments done on each of the three
# platforms for each of the three given experiments. 
# Notice that all the pairs of (platform, experiment) should be included in the output
# including the pairs with zero experiments.
# Return the result table in any order.
# The query result format is in the following example.
# Example 1:
# Input:
# Experiments table:
# +---------------+----------+-----------------+
# | experiment_id | platform | experiment_name |
# +---------------+----------+-----------------+
# | 4             | IOS      | Programming     |
# | 13            | IOS      | Sports          |
# | 14            | Android  | Reading         |
# | 8             | Web      | Reading         |
# | 12            | Web      | Reading         |
# | 18            | Web      | Programming     |
# +---------------+----------+-----------------+
# Output: 
# +----------+-----------------+-----------------+
# | platform | experiment_name | num_experiments |
# +----------+-----------------+-----------------+
# | Android  | Reading         | 1               |
# | Android  | Sports          | 0               |
# | Android  | Programming     | 0               |
# | IOS      | Reading         | 0               |
# | IOS      | Sports          | 1               |
# | IOS      | Programming     | 1               |
# | Web      | Reading         | 2               |
# | Web      | Sports          | 0               |
# | Web      | Programming     | 1               |
# +----------+-----------------+-----------------+
# Explanation: 
# On the platform "Android", we had only one "Reading" experiment.
# On the platform "IOS", we had one "Sports" experiment and one "Programming" experiment.
# On the platform "Web", we had two "Reading" experiments and one "Programming" experiment.


import pandas as pd

experiments = pd.DataFrame({
    "experiment_id": [4, 13, 14, 8, 12, 18],
    "platform": ["IOS", "IOS", "Android", "Web", "Web", "Web"],
    "experiment_name": ["Programming", "Sports", "Reading", "Reading", "Reading", "Programming"]
})

all_platform = pd.DataFrame({
    'platform' : ["IOS","Android","Web"],
})

all_experiments = pd.DataFrame({
    'experiment_name' : ["Programming","Sports","Reading"],
})

exp_platform_comb = all_platform.merge(all_experiments, how ='cross')
df = (exp_platform_comb.merge(experiments, how ='left', on = ['platform','experiment_name'])
        .groupby(['platform','experiment_name'])['experiment_id']
        .count()
        .reset_index(name = 'num_experiments')
)
print(df)



# “Since all platform–experiment pairs must appear even if no data exists,
# I first generated the full Cartesian set, left joined the experiment data, 
# and then counted non-null experiment IDs.”