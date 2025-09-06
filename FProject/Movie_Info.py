from clean import SeriesData
import pandas as pd

def get_movie_info(movie_name):
    # Filter DataFrame to find rows where movie title or IMDb ID matches the input
    movie_row = SeriesData[(SeriesData['title'].str.lower() == movie_name.lower())
                           | (SeriesData['imdb_id'].str.lower() == movie_name.lower())]
    # Check if the resulting DataFrame is empty
    if movie_row.empty:
        # Print a message if no matching movie is found
        print(f"There is no film named {movie_name} in the dataset")
    else:
        # Return information about the movie if it is found
        return f'{movie_row['title'].values[0]} is produced by {movie_row["production_companies"].values[0]} \nIts genre is {movie_row['genres'].values[0]} and Its Imbd_Id is {movie_row['imdb_id'].values[0]}\nIt is released {movie_row['release_date'].values[0]} and It is in {movie_row['spoken_languages'].values[0]} languages'

# Prompt the user to input the movie name or IMDb ID for which they want to receive information
movie_title = input("Enter the movie name od imdb id for which you want receive an info: ")

# Call the function to get information about the movie and print the result
movie_info = get_movie_info(movie_title)
print(movie_info)