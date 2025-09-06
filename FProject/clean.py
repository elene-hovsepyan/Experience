import pandas as pd

# Read the dataset from CSV file
SeriesData = pd.read_csv('/Users/tigran/Desktop/TMDB.csv',delimiter=';')

# Define columns to be dropped from the DataFrame
ToDrop = ['id','backdrop_path', 'original_title']

# Drop specified columns from the DataFrame
SeriesData.drop(ToDrop, axis=1, inplace=True)

# Drop rows where 'title' and 'imdb_id' are missing
SeriesData = SeriesData[SeriesData['title'] != '']
SeriesData = SeriesData[SeriesData['imdb_id'] != '']

# Drop duplicate rows based on 'title' and 'release_date' columns
SeriesData = SeriesData.drop_duplicates(subset=['title', 'release_date'])

# Choose the most frequent data type among columns
common_type = SeriesData.dtypes.value_counts().sort_values(ascending=False).index[0]

# Check each column and convert its data type to the common_type if needed
for column in SeriesData.columns:
    if SeriesData[column].dtype != common_type:
        SeriesData[column] = SeriesData[column].astype(common_type)

print(SeriesData)