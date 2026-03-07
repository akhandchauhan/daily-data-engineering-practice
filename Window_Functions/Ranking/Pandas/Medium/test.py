import pandas as pd

# Create a pandas DataFrame to represent the Events table
df = pd.DataFrame({
    'business_id': [1, 3, 1, 2, 3, 1, 2],
    'event_type': ['reviews', 'reviews', 'ads', 'ads', 'ads', 'page views', 'page views'],
    'occurences': [7, 3, 11, 7, 6, 3, 12]
})

# m1 
# event_average_df = (
#                     df.groupby('event_type')['occurences']
#                     .mean()
#                     .reset_index(name = 'average_event_occurence')

# )
# final = ( df.merge(event_average_df, on = 'event_type')
#             .query("occurences > average_event_occurence")
#             .groupby('business_id')['occurences']
#             .count()
#             .reset_index(name = 'df_size')
#             .query("df_size > 1")
#             [['business_id']]
# )
# print(final)

#####################################################################################################################3

# m2 using window function

df['average_event_occurence'] = df.groupby('event_type')['occurences'].transform('mean')

final = (   df
            .query("occurences > average_event_occurence")
            .groupby('business_id')['occurences']
            .count()
            .reset_index(name = 'df_size')
            .query("df_size > 1")
            [['business_id']]
)

print(final)