from clean import SeriesData
import pandas as pd

def which_language(language):
    # Make a copy of the SeriesData DataFrame to avoid modifying the original DataFrame
    SeriesData_copy = SeriesData.copy()

    # Filter movies by the specified language
    SeriesData_language = SeriesData_copy[SeriesData_copy['spoken_languages'].str.lower() == language.lower()]

    # Convert 'vote_average' column to numeric, handling errors by coercing to NaN
    SeriesData_language.loc[:,'vote_average'] = pd.to_numeric(SeriesData_language['vote_average'], errors='coerce')

    # Drop rows with NaN values in 'vote_average' column
    SeriesData_language.dropna(subset=['vote_average'])

    # Sort movies by 'vote_average' in descending order
    SeriesData_language_sorted = SeriesData_language.sort_values(by='vote_average', ascending=False)

    # Return the top 5 unique movie titles in the specified language
    return ', '.join(SeriesData_language_sorted['title'].head(5).unique())

# Prompt the user to input the language they want to explore
lan = input("Enter the language you want to")

# Call the which_language function to get the top movies in the specified language and print the result
result = which_language(lan)
print(f"The language is {lan}, and most high rated movies are on these language are: {result}")