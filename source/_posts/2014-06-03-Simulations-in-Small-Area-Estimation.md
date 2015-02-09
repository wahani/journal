---
layout: post
published: true
title: "saeSim: Simulation Tools in Small Area Estimation"
description: "A short introduction of the R-Package saeSim. Tools for model- and design based simulations in the field of Small Area Estimation."
comments: true
categories: saeSim sae simulation
---

In this post I want to introduce the package [saeSim](/saeSim). The package improved my set-up of design-based and model-based simulation scenarios in the context of Small Area Estimation. It introduces components with which the flow of the simulation is framed and supports a unified structure and interface between each step.


<!--more-->

## General idea and workflow
As I was writing my scripts for simulation I typically ended up using loop structures every second line. Every time I wanted to add or change something, I appended new lines to the script which then needed to iterate over my data. Consider a simple task: Predict a population mean and compare the bias of a linear model and sample average. Repeat this 100 times. The task is clear, simulate 100 populations, compute the mean in each population, draw a sample from each population apply the two models on the samples and estimate the population mean.


{% highlight r %}
library(reshape2)

# Generate data
dataList <- replicate(100, {
  dat <- data.frame(x = rnorm(100), e = rnorm(100))
  dat$y <- 100 + 2 * dat$x + dat$e
  dat
}, simplify = FALSE)

# population mean
dataList <- lapply(dataList, function(dat) {
  dat$popMean <- mean(dat$y)
  dat
})

# Draw a sample
dataList <- lapply(dataList, function(dat) dat[sample.int(100, 20), ])

# Apply model and make prediction
dataList <- lapply(dataList, function(dat) {
  fancyModel <- lm(y ~ x, data = dat)
  out <- data.frame(
    lm = predict(fancyModel, data.frame(x = mean(dat$x))),
    mean = mean(dat$y),
    popMean = mean(dat$popMean)
    )
  out
})

dat <- do.call(rbind, dataList)
dat$biasLm <- dat$lm - dat$popMean
dat$biasMean <- dat$mean - dat$popMean

datEval <- melt(dat[c("biasLm", "biasMean")])
{% endhighlight %}



{% highlight text %}
## No id variables; using all as measure variables
{% endhighlight %}



{% highlight r %}
boxplot(value ~ variable, data = datEval, horizontal=TRUE)
{% endhighlight %}

<img src="/images/images/2014-06-03-Simulations-in-Small-Area-Estimation/unnamed-chunk-1-1.png" title="center" alt="center" width="100%" />

Imagine this style of writing with more complex data and models and hundreds or thousands of lines of code. Reproducing yourself is a mess, let alone find bugs, mistakes, etc. Another issue is that a lot of effort is needed to parallelize the computation. I would need to replace every looping structure with a parallel version. And furthermore the real task is shadowed by all kinds of unnecessary control structures. The idea to overcome this was to write one function which would do the data generation and computation on that data. That would lead only to one loop and to a potentially long function for simulation -- although it is not a problem to split the task step-wise into smaller functions which would be called in the 'main' simulation function. In the end this is what I tried with saeSim. I identified the repeating steps and built a framework so I can easily set-up simulations without thinking about the structure and more about the statistical problem.

## A sim_setup
In all I have 6 steps I can part my simulation into. 

- data generation: `sim_gen()`
- computing on the population: `sim_calc(., level = "population")`
- drawing samples: `sim_sample()`
- computing on the sample: `sim_calc(., level = "sample")`
- aggregating the data (area level information): `sim_agg()`
- finally computing on the aggregates: `sim_calc(., level = "agg")`

The purpose of these functions is simply to control the flow of the simulation and they all take a function as argument. In other words all of these functions control *when* a function is called -- you can decide which function that will be. Let's see how things add up for a simple data generation scenario:


{% highlight r %}
# devtools::install_github("wahani/saeSim")
library(saeSim)
{% endhighlight %}



{% highlight text %}
## Loading required package: methods
## Documentation is available at wahani.github.io/saeSim
{% endhighlight %}



{% highlight r %}
# Generating a population with 100 domains and 100 units in each domain:
setup <- base_id(100, 100) %>%
  # Variable x and error component e
  sim_gen_x(sd = 1) %>%
  sim_gen_e(sd = 1) %>%
  sim_resp_eq(y = 100 + 2 * x + e)
{% endhighlight %}

To inspect `setup` I have a `plot`, `autoplot`, `summary` and `show` method.


{% highlight r %}
setup
{% endhighlight %}



{% highlight text %}
##   idD idU          x           e         y
## 1   1   1 -0.2936745  0.41833162  99.83098
## 2   1   2  1.2569742 -0.96474030 101.54921
## 3   1   3  0.2044349 -1.33075751  99.07811
## 4   1   4  0.2617979  0.10603543 100.62963
## 5   1   5 -0.6024912  0.55230630  99.34732
## 6   1   6  0.4533176  0.02703708 100.93367
{% endhighlight %}

Note that the response 'y' will always be constructed automatically. To visualize the data, the plot method will always try to find 'y' and plot it against the first variable found.


{% highlight r %}
plot(setup)
{% endhighlight %}

<img src="/images/images/2014-06-03-Simulations-in-Small-Area-Estimation/unnamed-chunk-4-1.png" title="center" alt="center" width="100%" />

{% highlight r %}
# What happens if I add contamination to the error:
plot(setup %>% sim_gen_ec())
{% endhighlight %}

<img src="/images/images/2014-06-03-Simulations-in-Small-Area-Estimation/unnamed-chunk-4-2.png" title="center" alt="center" width="100%" />

In contrast the `autoplot` function will use ggplot2 and will plot a two dimensional density estimate, very much like `smoothScatter`.


{% highlight r %}
autoplot(setup)
{% endhighlight %}

<img src="/images/images/2014-06-03-Simulations-in-Small-Area-Estimation/unnamed-chunk-5-1.png" title="center" alt="center" width="100%" />

## Back to the introductory example
So how does my scripting change using `saeSim`. I have some data generation interfaces which are a bit clumsy in this setting, they make my coding clearer in more complex scenarios. My simulation components are connected using the `%&%` operator. So even complex tasks can be split into several lines to maintain readability. The set-up is separated from the actual repetition, which allows to construct more complex designs and test them easily as I add new steps and components to the scenario.


{% highlight r %}
# Population with 1 domain and 100 units
setup <- base_id(1, 100) %>%
  # y = 100 + 2*x + e
  sim_gen(gen_norm(0, 1, "x")) %>%
  sim_gen(gen_norm(0, 1, "e")) %>%
  sim_resp_eq(y = 100 + 2 * x + e) %>%
  # Keeping the mean of y
  sim_comp_popMean() %>%
  # Drawing a simple random sample with n = 20
  sim_sample(sample_number(20)) %>%
  # Computing the estimated parameters
  sim_comp_sample(function(dat) {
    fancyModel <- lm(y ~ x, data = dat)
    out <- data.frame(
      lm = predict(fancyModel, data.frame(x = mean(dat$x))),
      mean = mean(dat$y),
      popMean = mean(dat$popMean)
      )
    out
    })

setup
{% endhighlight %}



{% highlight text %}
##        lm    mean  popMean
## 1 100.977 100.977 100.4657
{% endhighlight %}



{% highlight r %}
# Running the simulation
res <- sim(setup, R = 100)

# Combining results as before:
dat <- do.call(rbind, res)
dat$biasLm <- dat$lm - dat$popMean
dat$biasMean <- dat$mean - dat$popMean
datEval <- melt(dat[c("biasLm", "biasMean")])
{% endhighlight %}



{% highlight text %}
## No id variables; using all as measure variables
{% endhighlight %}



{% highlight r %}
boxplot(value ~ variable, data = datEval, horizontal=TRUE)
{% endhighlight %}

<img src="/images/images/2014-06-03-Simulations-in-Small-Area-Estimation/unnamed-chunk-6-1.png" title="center" alt="center" width="100%" />

## How to get started
If you have come this far and in the case you are still interested in what this is about, go to the [homepage of saeSim](/saeSim), install the package, checkout the vignette, add comments here or on [GitHub](https://github.com/wahani/saeSim)...