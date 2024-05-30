main :-

  % Reset user answers at the beginning of the program
  reset_answers,

  % Expert System 1: Programming Languages ------------ %
  reconsult('kb.pl'),nl,
  reconsult('questions.pl'),nl,
  reconsult('answers.pl'),nl,
  reconsult('describe.pl'),nl,
  reconsult('assign.pl'),nl,
  intro,
  find_language(Language),
  describe(Language), nl,
  ask_agreement(Language).

recommender(Language) :-
  % Expert System 2: Course selection ---------------- %
  reconsult('kb_courses.pl'),
  reconsult('questions_courses.pl'),
  reconsult('answers_courses.pl'),
  reconsult('describe_courses.pl'),
  reconsult('assign_courses.pl'),
  intro_courses,
  % Ask user filters
  level(DifficultyLevel), nl,
  rating(CourseRatingLevel), nl,
  % Query kb
  findall(CourseName, course(CourseName, Language, DifficultyLevel, CourseRatingLevel), Courses),
  present_courses_and_select(Courses).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Expert System 1

intro :-
  write('Which programming language should I learn first?'), nl,
  write('To answer, input the number shown next to each answer, followed by a dot (.)'), nl, nl.

find_language(Language) :-
  language(Language), !.


% Store user answers to be able to track his progress
:- dynamic(progress/2).


% Clear stored user progress
% reset_answers must always return true; because retract can return either true
% or false, we fail the first and succeed with the second.
reset_answers :-
  retract(progress(_, _)),
  fail.
reset_answers.


% Outputs a nicely formatted list of answers
% [First|Rest] is the Choices list, Index is the index of First in Choices
answers([], _).
answers([First|Rest], Index) :-
  write(Index), write(' '), answer(First), nl,
  NextIndex is Index + 1,
  answers(Rest, NextIndex).


% Parses an Index and returns a Response representing the "Indexth" element in
% Choices (the [First|Rest] list)
parse(0, [First|_], First).
parse(Index, [First|Rest], Response) :-
  Index > 0,
  NextIndex is Index - 1,
  parse(NextIndex, Rest, Response).


% Asks the Question to the user and saves the Answer
ask(Question, Answer, Choices) :-
  question(Question),
  answers(Choices, 0),
  read(Index),
  parse(Index, Choices, Response),
  asserta(progress(Question, Response)),
  Response = Answer.

% Ask confirmation to the user
ask_agreement(Language) :-
  nl,
  write('Are you interested in learning '), write(Language), write('? (yes/no).'), nl,
  read(Answer),
  process_agreement(Answer, Language).

process_agreement(yes, Language) :-
  write('Great! Let\'s move on to the next step.'),
  recommender(Language).

process_agreement(no, Language) :-
  write('Oh, that\'s unfortunate. Maybe another language?.'),
  reset_answers,
  main.

process_agreement(Answer, Language) :-
  \+ member(Answer, [yes, no]), % Check if Answer is not yes or no
  write('Please answer with yes or no.'), nl,
  ask_agreement(Language).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Expert System 2

% Asks the Question to the user and saves the Answer
ask2(Question, Answer, Choices) :-
  question_courses(Question),
  answer_courses(Choices, 0),
  read(Index),
  parse(Index, Choices, Answer),
  asserta(progress(Question, Answer)).

% [First|Rest] is the Choices list, Index is the index of First in Choices
answer_courses([], _).
answer_courses([First|Rest], Index) :-
  write(Index), write('. '), answer_courses(First), nl,
  NextIndex is Index + 1,
  answer_courses(Rest, NextIndex).

intro_courses :-
  write('Which course would you like to take?'), nl,
  write('To answer, input the number shown next to each answer, followed by a dot (.)'), nl, nl.

% List the courses to the users and allow to choose one
present_courses_and_select(Courses) :-
    present_courses(Courses), nl,
    write('Select the course number you are interested in: '),
    read(Index),
    select_course_description(Courses, Index).

% Select the course and show the description to the user
select_course_description(Courses, Index) :-
    nth1(Index, Courses, Course),
    course_description(Course), nl.

% Show recommended courses to the user
present_courses([]) :-
    write('No recommended courses for this language.'), nl,
    reset_answers, !,
    fail.
present_courses(Courses) :-
    write('Recommended courses for this language:'), nl,
    % Print every recommended course with its associated number
    print_courses_with_numbers(Courses, 1).

% Print courses list with numbers
print_courses_with_numbers([], _).
print_courses_with_numbers([Course|Rest], Number) :-
    write(Number), write('. '), write(Course), nl,
    NextNumber is Number + 1,
    print_courses_with_numbers(Rest, NextNumber).

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
