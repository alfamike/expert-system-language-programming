import pandas as pd
import re

# Load the CSV file
file_path = 'Coursera.csv'
df = pd.read_csv(file_path, encoding='utf-8')

# Dict for programming languages
# Keys are values to look for and values are for the dataset
languages = {
    "python": "python",
    "java": "java",
    "c": "c",
    "c++": "cpp",
    "javascript": "javascript",
    "c#": "csharp",
    "ruby": "ruby",
    "php": "php",
    "objective-c": "objectivec"
}


def detect_languages(row):
    """
    Function to detect languages in each csv row to classify courses
    :param row: csv row
    :return: list of detected languages in the row
    """
    combined_text = f"{row['Course Name']} {row['Course Description']} {row['Skills']}".lower()
    detected_languages = set()
    for lang_search, lang_print in languages.items():
        if re.search(rf'\b{re.escape(lang_search)}\b', combined_text):
            detected_languages.add(lang_print)
    return list(detected_languages)


df['Language'] = df.apply(detect_languages, axis=1)
df = df[df['Language'].apply(lambda x: len(x) > 0)]


def convert_rating(rating):
    """
    Function to convert numeric rating to string
    :param rating: numeric rating
    :return: string rating
    """
    try:
        rating = float(rating)
        if 0 < rating <= 5:
            return "low"
        elif 5 < rating <= 7:
            return "medium"
        elif 7 < rating <= 10:
            return "high"
    except ValueError:
        return "Unknown"


def normalize_course_level(level):
    """
    Function to normalize course level
    :param level:  value in the row
    :return: normalized course level
    """
    if level not in ['Beginner', 'Intermediate', 'Advanced']:
        return 'Unknown'
    return level.lower()


df['Difficulty Level'] = df['Difficulty Level'].apply(normalize_course_level)
df['Course Rating Level'] = df['Course Rating'].apply(convert_rating)


def escape_prolog_string(text):
    """
    Function to escape symbols that are keywords in Prolog Language
    :param text: text to escape
    :return: escaped text
    """
    # Handle None or NaN values
    if pd.isna(text):
        return ""
    return (text.replace("'", "\\'").replace(".", "").replace(",", "").replace(";", "").replace(":", "").replace("�",
                                                                                                                 "").
            strip())


def generate_prolog_course(row):
    """
    Function to create courses knowledge base
    :param row: csv row
    :return: Prolog structures based in the number of languages detected in the row
    """
    # Escape special characters in course name
    course_name = escape_prolog_string(row['Course Name'])

    # Create a list to store Prolog facts for each language
    prolog_facts = []
    for lang in row['Language']:
        prolog_fact = f"""course('{course_name}', '{lang}', '{row['Difficulty Level']}',
        '{row['Course Rating Level']}')."""
        prolog_facts.append(prolog_fact)

    return prolog_facts


prolog_courses = df.apply(generate_prolog_course, axis=1)

# Flatten the list of lists
prolog_courses = [fact for sublist in prolog_courses for fact in sublist]


def generate_prolog_description(row):
    """
    Function to generate course descriptions in Prolog
    :param row: csv row
    :return: Prolog structure for each course row
    """
    # Escape special characters in course name, university, description, and skills
    course_name = escape_prolog_string(row['Course Name'])
    university_name = escape_prolog_string(row['University'])
    course_description = escape_prolog_string(row['Course Description'])
    skills = escape_prolog_string(row['Skills'])
    aux_languages = ', '.join(row['Language'])

    return f"""course_description('{course_name}') :-
    write('course_name: {course_name}'), nl,
    write('languages: {aux_languages}'), nl,
    write('university: {university_name}'), nl,
    write('difficultyLevel: {row['Difficulty Level']}'), nl,
    write('courseRating: {row['Course Rating Level']}'), nl,
    write('courseUrl: {row['Course URL']}'), nl,
    write('course_description: {course_description}'), nl,
    write('skills: {skills}'), nl."""


prolog_descriptions = df.apply(generate_prolog_description, axis=1)

# Outpuf files with Prolog structures

output_file_path_courses = './kb_courses.pl'
with open(output_file_path_courses, 'w', encoding='utf-8') as file:
    for fact in prolog_courses:
        file.write(fact + '\n')

output_file_path_descriptions = './describe_courses.pl'
with open(output_file_path_descriptions, 'w', encoding='utf-8') as file:
    for fact in prolog_descriptions:
        file.write(fact + '\n')
