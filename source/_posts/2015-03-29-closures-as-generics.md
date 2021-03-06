---
layout: post
title: "Generic functions and closures"
author: "Sebastian"
categories: fp closures
bibliography: 
output: wahaniMiscs:::pdf_memo
---

How to implement the behavior of generic functions using a closure. Features needed:

- Methods are associated with functions.
- Method dispatch

What is already there:

- lambda.r
- S3
- S4

Why would I want to use a closure instead?

- encapsulation: the existing approaches support the definition of methods at various places in source code. Maybe it would be interesting to encourage the method definition as part of the generic.

Cons:
- What about extendability?


{% highlight r %}
Generic <- function(expr) {  
  self <- environment()
  mc <- match.call()
  eval(mc$expr, envir = self)
  function(...) {
    key <- decodeSignature(...)
    get(key, envir = self)(...)
  }
}

someGeneric <- Generic({
  decodeSignature <- function(...) 
    paste0("m.", paste(sapply(list(...), class), collapse = "."))
  
  m.numeric <- function(x) "numeric"
  m.character <- function(x) "character"
})

someGeneric(1)
{% endhighlight %}



{% highlight text %}
## [1] "numeric"
{% endhighlight %}



{% highlight r %}
someGeneric("a")
{% endhighlight %}



{% highlight text %}
## [1] "character"
{% endhighlight %}

How to implement a default?

