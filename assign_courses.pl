% Assigns an answer to questions from the knowledge base

level(Answer) :-
  progress(level, Answer).
level(Answer) :-
  \+ progress(level, _),
  ask(level, Answer, [beginner, intermediate, advanced]).

university(Answer) :-
  progress(university, Answer).
university(Answer) :-
  \+ progress(university, _),
  ask(university, Answer, []).

rating(Answer) :-
  progress(rating, Answer).
rating(Answer) :-
  \+ progress(rating, _),
  ask(rating, Answer, [low, medium, high]).

skills(Answer) :-
  progress(skills, Answer).
skills(Answer) :-
  \+ progress(skills, _),
  ask(skills, Answer, []).
