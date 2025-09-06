from clean import SeriesData
import pandas as pd

def is_the_film_in_dataser(film_name):
    # Make a copy of the SeriesData DataFrame to avoid modifying the original DataFrame
    SeriesData_copy = SeriesData.copy()

    # Drop rows with missing values in the 'title' column
    SeriesData_copy.dropna(subset=['title'], inplace=True)

    # Filter movies whose title contains the input film_name
    film_movies = SeriesData_copy[SeriesData_copy['title'].str.lower().str.contains(film_name.lower())]

    # Join the top 5 unique movie titles matching the criteria into a string
    return ', '.join(film_movies['title'].head(5).unique())

# Prompt the user to input the film name they want to check
check_film = input("Enter the film you want to check: ")

# Call the function to find movies with the input name in their title and print the result
print(f"This films have the name {check_film} in their title: {is_the_film_in_dataser(check_film)}")