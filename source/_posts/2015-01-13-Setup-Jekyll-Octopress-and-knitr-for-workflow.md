---
layout: post
title:  "Setup Jekyll Octopress and knitr for workflow"
description: ""
categories: knitr, jekyll
---

Hello!

## Requirements


{% highlight r %}
install.packages(
  c('servr', 'knitr'),
  type = 'source',
  repos = c('http://yihui.name/xran', 'http://cran.rstudio.com')
)
{% endhighlight %}

## In RStudio


{% highlight r %}
servr::jekyll(input = "_rmd", output = "source/_posts")
{% endhighlight %}

