from clean import SeriesData
import pandas as pd

def giving_the_link_to_film(film_name):
    # Filter DataFrame to find rows where movie title matches the input
    film_row = SeriesData[SeriesData['title'].str.lower() == film_name.lower()]

    # Check if the resulting DataFrame is not empty
    if not film_row.empty:
        # If movie is found, return its homepage link
        return film_row.iloc[0]['homepage']
    else:
        # return a message indicating it was not found
        return "Film not found"

# Prompt the user to input the movie name for which they want to get the link
wanted_film_name = input("Enter the film you want to watch: ")

# Call the function to get the link for the requested movie and print the result
result = giving_the_link_to_film(wanted_film_name)
print(f"{result}, this is link to film")