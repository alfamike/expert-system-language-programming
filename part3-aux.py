import pandas as pd
import re

def extract_unique_universities(csv_file):
    # Leer el archivo CSV
    df = pd.read_csv(csv_file, encoding='utf-8')
    
    # Extraer la columna "University"
    universities = df['University']
    
    # Obtener valores únicos
    unique_universities = universities.unique()
    
    # Convertir a lista y retornar
    return unique_universities.tolist()

def sanitize_prolog_atom(value):
    """
    Sanitiza un valor para ser usado como átomo en Prolog.
    Si el valor contiene caracteres especiales, se reemplazan por guiones bajos.
    """
    # Lista de caracteres especiales a reemplazar
    special_chars = [' ', "'", '(', ')', '[', ']', '{', '}', '|', ';', ',', '+', '-', '*', '/', '\\', '&', '^', '%', '$', '#', '@', '!', '~', '`','.']

    # Reemplazar los caracteres especiales por guiones bajos
    sanitized_value = ''.join(['_' if char in special_chars else char for char in value]).replace("�", "")
    return sanitized_value

unique_universities_sanitized = []

def write_prolog_file(values, prolog_file):
    with open(prolog_file, 'a', encoding='utf-8') as file:
        for value in values:
            sanitized_value = sanitize_prolog_atom(value)
            file.write(f"answer_courses({sanitized_value.lower()}) :-\n")
            file.write(f"    write('{sanitized_value}').\n\n")
            unique_universities_sanitized.append(sanitized_value.lower())

# Archivo CSV
csv_file = '../Coursera.csv'

# Obtener lista de universidades únicas
unique_universities = extract_unique_universities(csv_file)

# Escribir archivo Prolog
prolog_file = 'answers_courses.pl'
write_prolog_file(unique_universities, prolog_file)

# Paso a cadena de texto
unique_universities_str = ', '.join(unique_universities_sanitized)
print('[' + unique_universities_str + ']')
