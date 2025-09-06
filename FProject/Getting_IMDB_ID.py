from clean import SeriesData
import pandas as pd

def getting_imbd_id(film_name):
    # Filter DataFrame to find rows where movie title matches the input
    film_row = SeriesData[SeriesData['title'].str.lower() == film_name.lower()]

    # Check if the resulting DataFrame is not empty
    if not film_row.empty:
        # If movie is found, return its IMDb ID and a suggestion to search it on Google
        return f"{film_row.iloc[0]['imdb_id']} and you can search it in google"
    else:
        # If movie is not found, return a message indicating it was not found in the dataset
        return "Film not found in the dataset"

# Prompt the user to input the movie name for which they want to get the IMDb ID
film_you_want = input("Enter the film, which id you want to receive: " )
result_1 = getting_imbd_id(film_you_want)
print(f"The IMBD_ID of {film_you_want} is {result_1}")