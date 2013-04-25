# Class List

*Class List* is an application for teachers. It takes a list of students and generates sets of student pairs. Each student should be paired with every other student and no student should work with the same student more than once.

For example, let's say the class has four students: Bob, Lisa, Duke and Tyrone. This application will generate these lists:

```
[ [ "Bob", "Lisa" ], [ "Duke", "Tyrone" ] ]
[ [ "Bob", "Duke" ], [ "Lisa", "Tyrone" ] ]
[ [ "Bob", "Tyrone" ], [ "Lisa", "Duke" ] ]
```

## Technology

*Class List* is build using [Ember.js](http://emberjs.com/), [Sass](http://sass-lang.com/), [CoffeeScript](http://coffeescript.org/) and [Middleman](http://middlemanapp.com/). It's deployed to [GitHub Pages](http://pages.github.com/).

## Algorithm

The algorithm for computing the lists was taken from a [Stack Overflow post](http://stackoverflow.com/questions/16207837) and is an implementation of the [round robin algorithm](http://en.wikipedia.org/wiki/Round-robin_tournament#Scheduling_algorithm).

Let's say we have a list of six students:

```
A B C D E F
```

Start by splitting the students into two rows rotated clockwise:

```
A B C
F E D
```

Each row represents part of a pair. Next, fix one number in place and rotate the rest clockwise:

```
A F B
E D C
```

Repeat this until all of the students have been paired:

```
A E F
D C B

A D E
C B F

A C D
B F E
```