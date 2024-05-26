import pandas as pd
import re

# Load the CSV file
file_path = '../Coursera.csv'
df = pd.read_csv(file_path, encoding='utf-8')

# Detect programming languages
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
    combined_text = f"{row['Course Name']} {row['Course Description']} {row['Skills']}".lower()
    detected_languages = set()
    for lang_search, lang_print in languages.items():
        if re.search(rf'\b{re.escape(lang_search)}\b', combined_text):
            detected_languages.add(lang_print)
    return list(detected_languages)

df['Language'] = df.apply(detect_languages, axis=1)
df = df[df['Language'].apply(lambda x: len(x) > 0)]

# Convert course rating to levels
def convert_rating(rating):
    try:
        rating = float(rating)
        if 0 < rating <= 5:
            return "Low"
        elif 5 < rating <= 7:
            return "Medium"
        elif 7 < rating <= 10:
            return "High"
    except ValueError:
        return "Unknown"

def normalize_course_level(level):
    if level not in ['Beginner', 'Intermediate', 'Advanced']:
        level = 'Unknown'

df['Difficulty Level'] = df['Difficulty Level'].apply(normalize_course_level)
df['Course Rating Level'] = df['Course Rating'].apply(convert_rating)

def generate_prolog_course(row):
    escaped_name = re.escape(row['Course Name'])
    escaped_university = re.escape(row['University'])
    escaped_description = re.escape(row['Course Description'])
    escaped_skills = re.escape(row['Skills'])

    languages_writes = '\n    '.join([f"language('{lang}')," for lang in row['Language']])

    return f"""course('{escaped_name}') :-
    {languages_writes}
    name('{escaped_name}'),
    university('{escaped_university}'),
    difficultyLevel('{row['Difficulty Level']}'),
    courseRating('{row['Course Rating Level']}'),
    course_description('{escaped_description}'),
    skills('{escaped_skills}')."""

prolog_courses = df.apply(generate_prolog_course, axis=1)

def generate_prolog_description(row):
    escaped_name = re.escape(row['Course Name'])
    escaped_university = re.escape(row['University'])
    escaped_description = re.escape(row['Course Description'])
    escaped_skills = re.escape(row['Skills'])

    return f"""course_description('{escaped_name}') :-
    write('languages: {row['Language']}') nl,
    write('name: {escaped_name}'), nl,
    write('university: {escaped_university}'), nl,
    write('difficultyLevel: {row['Difficulty Level']}'), nl,
    write('courseRating: {row['Course Rating Level']}'), nl,
    write('course_description: {escaped_description}'), nl,
    write('skills: {escaped_skills}')."""

prolog_descriptions = df.apply(generate_prolog_description, axis=1)

output_file_path_courses = './kb_courses.pl'
with open(output_file_path_courses, 'w', encoding='utf-8') as file:
    for fact in prolog_courses:
        file.write(fact + '\n')

output_file_path_descriptions = './describe_courses.pl'
with open(output_file_path_descriptions, 'w', encoding='utf-8') as file:
    for fact in prolog_descriptions:
        file.write(fact + '\n')
