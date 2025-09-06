from clean import SeriesData
import pandas as pd

def movie_lenght(time, genre):
    # Make a copy of the SeriesData DataFrame to avoid modifying the original DataFrame
    SeriesData_copy = SeriesData.copy()

    # Filter movies by the specified genre, ignoring case and handling missing values
    SeriesData_1 = SeriesData_copy[SeriesData['genres'].str.lower().str.contains(genre.lower(), case=False, na=False)]

    # Filter movies by the specified maximum runtime
    SeriesData_time = SeriesData_1[SeriesData_1['runtime'] <= time]

    # Convert 'vote_average' column to numeric, handling errors by coercing to NaN
    SeriesData_time.loc[:, 'vote_average'] = pd.to_numeric(SeriesData_time['vote_average'], errors='coerce')

    # Drop rows with NaN values in 'vote_average' column
    SeriesData_time.dropna(subset=['vote_average'])

    # Sort movies by 'vote_average' in descending order
    SeriesData_time_rating = SeriesData_time.sort_values(by='vote_average', ascending=False)

    # Return the top 5 unique movie titles with runtime less than or equal to the specified time
    return ', '.join(SeriesData_time_rating['title'].head(5).unique())

# Prompt the user to input the maximum runtime and the desired genre
time_you_want = input("how long do you want the film be in minutes?")
time_you_want = int(time_you_want)
genre_1 = input("what genre do you want the film")

# Call the movie_length function to get the movies matching the criteria and print the result
result = movie_lenght(time_you_want, genre_1)
print(f"{result}, these are the movies which lenght is less than {time_you_want} minutes and its genre is {genre_1}")