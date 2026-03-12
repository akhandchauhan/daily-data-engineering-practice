import pandas as pd

data ={
    'city_id' :[1,1,1,2,2,3,3],
    'day' : ['2022-01-07','2022-03-07','2022-07-07','2022-08-07','2022-08-17','2022-02-07','2022-12-07'],
    'degree': [-12,5,24,37,37,-7,-6]
}

weather_df = pd.DataFrame(data)
weather_df['day'] = pd.to_datetime(weather_df['day'])

# m1 

weather_df['rnk'] = weather_df.groupby('city_id')['degree'].rank(method='first', ascending=False)
weather_df_filtered = weather_df[weather_df['rnk'] == 1]
weather_df_filtered = weather_df_filtered[['city_id', 'day', 'degree']]
print(weather_df_filtered)


############################################################################################################
# m2

def weather_info(weather_df:pd.DataFrame) -> pd.DataFrame: 
    max_weather_df = ( weather_df
                    .groupby('city_id', as_index = False)['degree']
                    .max()
                    .rename(columns = {'degree':'max_degree'})
    )

    merged_df = (
                    weather_df.merge(max_weather_df,
                                    left_on = ['city_id','degree'], 
                                    right_on = ['city_id', 'max_degree']
                                    )
                    .groupby(['city_id','degree'], as_index= False)['day']
                    .min()
                    .sort_values(by = 'city_id')
                    [['city_id','day','degree']]
                    
    )
    return merged_df

print(weather_info(weather_df))

############################################################################################################
# m3

weather_df = weather_df.sort_values(by = ['degree','day'], ascending= [False, True])
weather_df['rnk'] = weather_df.groupby('city_id').cumcount()+1
weather_df_filtered = weather_df[weather_df['rnk'] == 1]
weather_df_filtered = weather_df_filtered[['city_id', 'day', 'degree']].sort_values('city_id')
print(weather_df_filtered)


############################################################################################################
# m4

max_degree = weather_df.groupby('city_id')['degree'].transform('max')

result = (
    weather_df[weather_df['degree'] == max_degree]
    .sort_values(['city_id','day'])
    .drop_duplicates('city_id')
    [['city_id','day','degree']]
)