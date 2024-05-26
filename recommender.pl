main :-
  % Expert System 1: Programming Languages ------------ %
  reconsult('kb.pl'),nl,
  reconsult('questions.pl'),nl,
  reconsult('answers.pl'),nl,
  reconsult('describe.pl'),nl,
  reconsult('assign.pl'),nl,
  intro,
  reset_answers,
  find_language(Language),
  describe(Language),
  ask_agreement(Language).

recommender(Language) :-
  % Expert System 2: Course selection ---------------- %
  reconsult('kb_courses.pl'),nl,
  reconsult('questions_courses.pl'),nl,
  reconsult('answers_courses.pl'),nl,
  reconsult('describe_courses.pl'),nl,
  reconsult('assign_courses.pl'),nl,
  ask2()
  find_course(Course, Language, University, DifficultyLevel, CourseRatingLevel),
  course_description(Course), nl.

intro :-
  write('Which programming language should I learn first?'), nl,
  write('To answer, input the number shown next to each answer, followed by a dot (.)'), nl, nl.

intro_courses :-
  write('Which course would you like to take?'), nl,
  write('To answer, input the number shown next to each answer, followed by a dot (.)'), nl, nl.

ask_agreement(Language) :-
  nl,
  write('Are you interested in learning '), write(Language), write('? (yes/no)'), nl,
  read(Answer),
  process_agreement(Answer, Language).

process_agreement(yes, Language) :-
  write('Great! Let\'s move on to the next step.'),ç
  intro_courses,
  recommender(Language).

process_agreement(no, Language) :-
  write('Oh, that\'s unfortunate. Maybe another language?'),
  reset_answers,
  main.

process_agreement(Answer, Language) :-
  \+ member(Answer, [yes, no]), % Check if Answer is not yes or no
  write('Please answer with yes or no.'), nl,
  ask_agreement(Language).

find_language(Language) :-
  language(Language), !.

find_course(Course, Language, University, DifficultyLevel, CourseRatingLevel) :-
  course(Course, Language, University, DifficultyLevel, CourseRatingLevel).
  
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Funciones comunes

% Store user answers to be able to track his progress
:- dynamic(progress/2).

% Clear stored user progress
% reset_answers must always return true; because retract can return either true
% or false, we fail the first and succeed with the second.
reset_answers :-
  retract(progress(_, _)),
  fail.
reset_answers.

% [First|Rest] is the Choices list, Index is the index of First in Choices
answers([], _).
answers([First|Rest], Index) :-
  write(Index), write(' '), answer(First), nl,
  NextIndex is Index + 1,
  answers(Rest, NextIndex).

% [First|Rest] is the Choices list, Index is the index of First in Choices
answer_courses([], _).
answer_courses([First|Rest], Index) :-
  write(Index), write(' '), answer_courses(First), nl,
  NextIndex is Index + 1,
  answer_courses(Rest, NextIndex).

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

% Asks the Question to the user and saves the Answer
ask2(Question, Answer, Choices) :-
  question_courses(Question),
  answer_courses(Choices, 0),
  read(Index),
  parse(Index, Choices, Response),
  asserta(progress(Question, Response)),
  Response = Answer.

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
