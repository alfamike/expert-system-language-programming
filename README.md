# expert-systems
A basic expert system, written in Prolog, that suggests what programming language one should learn first.

The system is based on the [this](http://carlcheo.com/wp-content/uploads/2014/12/which-programming-language-should-i-learn-first-infographic.png) infographic.

Expanded with a second expert system to recommend courses depending on the language suggested, the difficulty and the rating of the course.

## Instalation

In order to run this Prolog program you need to have...Prolog installed:

- on Mac:

  ```bash
  brew install swi-prolog
  ```

Then, just clone this repo and you're good to go!

## Running base version

Start a Prolog console loaded with `main.pl`:

```bash
swipL -f main.pl
?- main.
```

Then follow the on-screen instructions. Enjoy!

## Running expanded version
Start a Prolog console loaded with `recommender.pl`:

```bash
swipL -f recommender.pl
?- main.
```