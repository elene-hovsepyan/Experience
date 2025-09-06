from clean import SeriesData

def top_5_movies_by_genre(genre_name):
    # Make a copy of the SeriesData DataFrame to avoid modifying the original DataFrame
    SeriesData_copy = SeriesData.copy()

    # Filter movies by the specified genre, ignoring case and handling missing values
    genre_movies = SeriesData_copy[SeriesData['genres'].str.lower().str.contains(genre_name.lower(), case=False, na=False)]

    # Get the top 5 unique movie titles from the filtered DataFrame and join them into a string
    return ', '.join(genre_movies.head(5)['title'].unique())

# Prompt the user to input the genre they want to explore
genre_movies = input("Enter the gener you want: ")

# Call the function to get the top 5 movies by the specified genre and print the result
print(f"Top 5 movies by genre: {top_5_movies_by_genre(genre_movies)}")