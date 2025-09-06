from clean import SeriesData
import pandas as pd

def films_like(film_name):
    # Filter DataFrame to find rows where movie title matches the input
    film_row = SeriesData[SeriesData['title'].str.lower() == film_name.lower()]

    # Check if the resulting DataFrame is empty
    if film_row.empty:
        # Print a message if no matching movie is found
        print(f"There is no film named {film_name} in the dataset")
    else:
        # If movie is found, continue with the analysis

        # Make a copy of the SeriesData DataFrame to avoid modifying the original DataFrame
        SeriesData_copy = SeriesData.copy()

        # Exclude the movie itself from the similar movies
        SeriesData_changed = SeriesData_copy[SeriesData_copy['title'].str.lower() != film_name.lower()]

        # Get the genre of the input movie
        genre = film_row['genres'].values[0]

        # Filter out movies with missing values in the 'genres' column
        similar_movies = SeriesData_changed.dropna(subset=['genres'])

        # Convert 'vote_average' column to numeric, handling errors by coercing to NaN
        similar_movies.loc[:,'vote_average'] = pd.to_numeric(similar_movies['vote_average'], errors='coerce')

        # Sort movies by 'vote_average' in descending order
        similar_movies = similar_movies.sort_values(by='vote_average', ascending=False)

        # Filter movies with genres similar to the input movie's genre
        similar_movies_final = similar_movies[similar_movies['genres'].str.contains(genre)]

        # Return a string containing the titles of the top 5 similar movies
        return ', '.join(similar_movies_final.head(5)['title'].unique())

# Prompt the user to input the film name for which they want to find similar movies
film_like_smth = input("Enter the film name for which you want to find similar movies: ")

# Call the function to find movies similar to the input film and print the result
film_similar_to = films_like(film_like_smth)
print(f"{film_similar_to}, these films are similar to {film_like_smth}")