% Assigns an answer to questions from the knowledge base

level(Answer) :-
  progress(level, Answer).
level(Answer) :-
  \+ progress(level, _),
  ask2(level, Answer, [beginner, intermediate, advanced]).
  
rating(Answer) :-
  progress(rating, Answer).
rating(Answer) :-
  \+ progress(rating, _),
  ask2(rating, Answer, [low, medium, high]).