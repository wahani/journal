---
layout: post
published: true
comments: true
title: Introducing S4-Generics
description: "A short introduction to generic functions using the S4 class system in R."
tags: [S4, S3, method, class]
---
Why do I write this post?
-------------------------


Recently I discovered some nice new (at least for me) features of the [R language](http://cran.r-project.org/). I am often in the position to write functions for different types (classes) of objects (arguments). Somehow it never occurred to me, that it would be a good idea to write methods instead of several functions. And in the usual case where I write a script it isn't. Firstly, the more thinking about what I want to do and coding is not worth it, I typically finish the script first. Secondly, the script gets longer and more difficult than needed. So writing methods will only be relevant for me when developing packages. Besides all other great advantages of generic functions and methods, one main reason for me is simply the number of function names I have to come up with. And the more functions I use in my package the crazier the names. Not good.

What is ...
-----------

### a generic function
A generic function is a function which will do the method dispatch for us. Meaning that a generic function will decide which method to call depending on the class of its arguments. `summary` is a good example for a generic function, it will behave differently when calling it on an object of the class `data.frame` or `lm` or `glm`.

{% highlight r linenos %}
dat <- data.frame(x = rnorm(10), y = rnorm(10))
summary(dat)
{% endhighlight %}



{% highlight text %}
##        x                  y           
##  Min.   :-1.89235   Min.   :-1.86870  
##  1st Qu.:-1.14968   1st Qu.:-0.75013  
##  Median : 0.61491   Median :-0.05573  
##  Mean   : 0.04012   Mean   : 0.03316  
##  3rd Qu.: 1.03095   3rd Qu.: 0.56215  
##  Max.   : 1.29280   Max.   : 2.82742
{% endhighlight %}



{% highlight r linenos %}
summary(lm(y ~ x, dat))
{% endhighlight %}



{% highlight text %}
## 
## Call:
## lm(formula = y ~ x, data = dat)
## 
## Residuals:
##     Min      1Q  Median      3Q     Max 
## -1.7735 -0.6339 -0.1149  0.3188  2.9026 
## 
## Coefficients:
##             Estimate Std. Error t value Pr(>|t|)
## (Intercept)   0.0383     0.4285   0.089    0.931
## x            -0.1282     0.3619  -0.354    0.732
## 
## Residual standard error: 1.354 on 8 degrees of freedom
## Multiple R-squared:  0.01545,	Adjusted R-squared:  -0.1076 
## F-statistic: 0.1255 on 1 and 8 DF,  p-value: 0.7323
{% endhighlight %}

### a method
A method is a function which is written for specific classes of its arguments. Although you probably expect specific classes of your arguments for every function you write. Methods are typically not called directly but by a call to a generic function. So for the generic function `summary`, there are several methods, for example `summary.data.frame` and `summary.lm` which are called depending on the class of the first argument of the call to `summary`. The advantage over writing functions named `summaryDF` and `summarylm` is that you don't need to remember so many (badly chosen) function names.

Writing methods
---------------

### S3

Typically I try not to write new generic functions because I have to remember their names, but write new methods for existing generics. A typical example in my own work are functions like `plot`, `rbind` and also `summary`. The simplest way is to use S3-generics. Their are little formal requirements one has to think of, and this is a good thing for people like me who are not computer scientists or programmers, but statisticians:


{% highlight r linenos %}
mean("Hello!")
{% endhighlight %}



{% highlight text %}
## Warning in mean.default("Hello!"): Argument ist weder numerisch noch
## boolesch: gebe NA zurück
{% endhighlight %}



{% highlight text %}
## [1] NA
{% endhighlight %}



{% highlight r linenos %}
mean.character <- function(x) x
mean("Hello!")
{% endhighlight %}



{% highlight text %}
## [1] "Hello!"
{% endhighlight %}

OK, so this is a stupid example for a S3-Method. The only thing you have to do is to write a new function with a certain naming convention. Begin with the name of the generic function, then a dot and then the class for which this method is written for.

### S4

S3 method dispatch uses "only" the class of the first argument. Sometimes it might be useful to supply methods not only for the first argument, but for different arguments, or what is called the signature. I find this especially appealing for plotting methods, where one needs different plots for different combinations of x and y variables (scatter-plot, boxplot, or histogram). Here is a small example:


{% highlight r linenos %}
data(InsectSprays)

setMethod("plot", signature(x="factor", y="numeric"),
  function(x,  y, ...) boxplot(y ~ x, ...)
)
{% endhighlight %}



{% highlight text %}
## Creating a generic function for 'plot' from package 'graphics' in package 'base'
{% endhighlight %}



{% highlight r linenos %}
plot(InsectSprays$spray, InsectSprays$count)
{% endhighlight %}

<img src="/figs/2014-03-10-Introducing-S4-Methods/unnamed-chunk-4-1.png" title="center" alt="center" width="100%" />

Writing generics
----------------

### What is my problem...

Often I find myself in the following position. I write a function which can do a specific task with given arguments:

{% highlight r linenos %}
filterMe <- function(level, dat, varname) {
  dat[dat[, varname] == level, ]
}

dat$someFactor <- as.factor(rep(c("A", "B"), 5))
filterMe("A", dat, "someFactor")
{% endhighlight %}



{% highlight text %}
##            x           y someFactor
## 1 -1.8923489  0.44346277          A
## 3 -0.6182543 -1.13524056          A
## 5  1.1758795 -0.87959616          A
## 7 -1.3268166 -0.01444823          A
## 9  1.0009824 -0.09700262          A
{% endhighlight %}
Then later in development I discover, that there are actually arguments which should not be of length 1. Typically I already use the function in more than one place and want to preserve its behaviour, so I do not want to change it.

### How I solve it...

Consider the case where I do not have one variable I want to use for filtering but more than one. What I can do is to write a `filterMe` generic and corresponding methods. First the generic, without default behaviour:


{% highlight r linenos %}
setGeneric("filterMe",
           function(varname, ...) standardGeneric("filterMe"))
{% endhighlight %}



{% highlight text %}
## [1] "filterMe"
{% endhighlight %}

Next step is to register the function `filterMe` as a method:


{% highlight r linenos %}
setMethod("filterMe", signature(varname = "character"),
          function(level, dat, varname) {
            dat[dat[, varname] == level, ]
            })
{% endhighlight %}



{% highlight text %}
## [1] "filterMe"
{% endhighlight %}



{% highlight r linenos %}
# And check if it is still working:
filterMe("A", dat, "someFactor")
{% endhighlight %}



{% highlight text %}
##            x           y someFactor
## 1 -1.8923489  0.44346277          A
## 3 -0.6182543 -1.13524056          A
## 5  1.1758795 -0.87959616          A
## 7 -1.3268166 -0.01444823          A
## 9  1.0009824 -0.09700262          A
{% endhighlight %}

Now what I want is a function which filters a `data.frame`, for several variables with different levels. In this case I want the argument `varname` to be a named list, where the name is the variable and the value the level to filter for.


{% highlight r linenos %}
setMethod("filterMe", signature(varname = "list"),
          function(dat, varname) {
            for (var in names(varname)) {
              dat <- filterMe(varname[[var]], dat, var)
              }
            dat
            })
{% endhighlight %}



{% highlight text %}
## [1] "filterMe"
{% endhighlight %}



{% highlight r linenos %}
dat$anotherFactor <- as.factor(rep(c("A", "B", "C"), 4)[1:10])
filterMe(dat, list("someFactor" = "A", "anotherFactor" = "B"))
{% endhighlight %}



{% highlight text %}
## Error in dat[, varname]: falsche Anzahl von Dimensionen
{% endhighlight %}

Note that I can reuse the previously defined method `filterMe` for the class `character` so that the function body is straight forward. In general I find this to be a nice addition to my toolbox and will take advantage of it to reduce the number of function names I have to come up with.

Documentation
-------------

For proper documentation of functions in a package I use the package `roxygen2`. [This question](http://stackoverflow.com/questions/7356120/how-to-properly-document-s4-methods-using-roxygen2) or rather the answers on [StackOverflow](http://stackoverflow.com) illustrate how to document S4-generics and methods and I have nothing to add.
