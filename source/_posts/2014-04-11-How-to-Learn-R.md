---
layout: post
published: false
comments: true
math: false
title: Resources to learn R as a programming language
description: "A list of articles, books and courses you can use to learn R as a programming language."
tags: [R, resources, tutorials]
---
Why do I write this post?
-------------------------
Since I started to learn [*R*](http://cran.r-project.org/) as a programming language, I came across very useful resources. My main focus for such resources has always been to those *not* introducing statistics with *R*. I have always had the feeling that those resources are very limited in the possibility to understand what *R* is doing -- by intention they focus on what the statistical method is doing. So there will be no books on machine learning, regression models or the like. 

Some of my resources will not be on *R* itself, because I never saw anything on 'Software Design with R' or related topics. Also something like 'Functional Programming with R' would be great. I know, especially on functional programming there are things out there. However, they focus on 'functions are first class citizens' and that you can pass functions around as objects and store them in lists. Actually there is not a single resource on *R* I know trying to explain when and why it is useful to write a closure, or store functions in a list. Most likely you will make your code unreadable for the average *R* user.

So here it comes. A list of things you may want to consider if you are serious about learning *R*; not statistics.

Articles
--------
- [*Best Practices for Scientific Computing*](http://arxiv.org/pdf/1210.0530.pdf)
- [*Developments in Class Inheritance and Method Selection*](http://statweb.stanford.edu/~jmc4/classInheritance.pdf)
- [*Lexical Scope and Statistical Computing*](http://www.tandfonline.com/doi/abs/10.1080/10618600.2000.10474895)
- [*Software Engineering with R*](http://www.people.fas.harvard.edu/~ptoulis/harvard-homepage/papers/R-software-engineering.pdf)
- [*The split-apply-combine strategy for data analysis*](http://vita.had.co.nz/papers/plyr.html)
- [*The State of Naming Conventions in R*](http://journal.r-project.org/archive/2012-2/RJournal_2012-2_Baaaath.pdf)

Blog-Articles
-------------
- [Closures in R: A useful abstraction](http://leftcensored.skepsi.net/2012/12/02/closures-in-r-a-useful-abstraction/)
- [Wondrous oddities: R's function-call semantics](http://blog.moertel.com/posts/2006-01-20-wondrous-oddities-rs-function-call-semantics.html)
- [Functional programming in R](http://daspringate.github.io/posts/2013/05/Functional_programming_in_R.html)

Books
-----
- [Burns, Patrick (2011): *The R Inferno*](http://www.burns-stat.com/documents/books/the-r-inferno/)
  - In my opinion still one of the best books around.
  - It is nicely written and presents a lot of concepts how to think about programming problems and how to solve them.
  - It is not an introduction to R. If you already know a bit of R, but have the feeling that ordinary tutorials are too easy, yet your skills do not develop any further: This is the book for you.
- Chambers, John M. (2009): *Software for Data Analyses: Programming with R*
  - For *useR*s who already have a good understanding of the language.
  - You won't learn any nasty tricks to show off.
  - John Chambers writes a lot about why they designed the language the way they did, and how you can use it in accordance: Following *The Prime Directive* -- read the book!
- Matloff, Norman (2009): *The Art of R Programming*
  - When I first used this book it was still a draft and [available as PDF](http://heather.cs.ucdavis.edu/~matloff/132/NSPpart.pdf). I also have the printed version but never used it.
  - It is a good book which focuses very much on *what* you can do, by introducing a lot of examples. You get a good overview of the language.
  - What I am missing are exercises for each chapter. Reading about `lapply` is one thing, trying to use it is something else. Exercises would also upgrade the book to something I can use alongside a class at university.
- [Wickham, Hadley: *Advanced R programming*](http://adv-r.had.co.nz/)
  - This is a very needed introduction to advanced programming in R - Something in between *The Art of R Programming* and *Software for Data Analyses*.
  - This is a great resource to learn R, however not for programming *novices*.
  - As a lot of *R* users are not from the field of computer science, this book will drill you enough to see yourself as an educated *useR*.
  - Most important for me: it has exercises!
  - Finishing all these exercises, you can think about things like *scope* and *closures* and other crazy concepts you never heard about (if you are not a programmer)!

Courses
-------
- [Design of Computer Programs](https://www.udacity.com/course/cs212)
  - Not using *R* but *Python*.
  - I really like this course -- but it is for people who have more enthusiasm to learn *Python* than me.
  - In preparation of this course I did a [*Python* intro from Google](https://developers.google.com/edu/python/), which is great and from my point of view sufficient to start with *Design of Computer Programs*.
- [Functional Programming Principles in Scala](https://www.coursera.org/course/progfun)
  - Not using *R* but *Scala*
  - If you want to know what functional programming is about, why it is a good idea to combine it with object-orientation and what the heck is polymorphism?; then this course is a good starting point.
  - This course helped me a lot in many ways. *Scala* treats functions as 'first class citizens' and the scoping rules are similar to what you know from *R*. I tried to do all the exercises in *R* which is possible until a certain point in the course. I didn't complete the course because I never really tried to learn *Scala* and after a couple of weeks that means you are out. Until then I learned a lot about programming and *R* along the way!
- [Introduction to Systematic Program Design - Part 1](https://www.coursera.org/course/programdesign)
  - This course is not about *R* and is not using it. They are using a teaching language fairly easy to learn.
  - It was the first time I saw that there is a different strategy to writing functions; sorry, that there are strategies to write functions, design data objects and programs. Until then I just wrote some script, if it worked I put some curly brackets around it and name it `newFunction`. If this sounds familiar to you, then you might want to get into systematic program design.
  - Although the course is not using *R*, you can apply a great deal of the techniques to any programming language.
- [R Programming](https://www.coursera.org/course/rprog)
  - A class on coursera to learn programming with *R*
  - I very much like this course. If you have never dealt with much of the fundamentals of the language, you can still learn something as an advanced *useR*.
  - If you just get started with *R*, then this is a good course. From my point of view some first contact with *R* is helpful to follow the course.

Tutorials
---------
OK, the tutorials are not really on programming. I wanted to list them here anyway.
- [List of Free Online R Tutorials](http://pairach.com/2012/06/17/r_tutorials_non-uni/)
- [R-Uni (A List of 100 Free R Tutorials and Resources in University webpages)](http://pairach.com/2012/02/26/r-tutorials-from-universities-around-the-world/)
- [TwoTorials](http://www.twotorials.com/)


