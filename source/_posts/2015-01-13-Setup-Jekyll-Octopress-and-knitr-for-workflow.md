---
layout: post
title:  "Setup Jekyll Octopress and knitr for workflow"
filename: 2015-01-13-Setup-Jekyll-Octopress-and-knitr-for-workflow
description: ""
categories: knitr, jekyll
---

Hello!

## Requirements

{% highlight r linenos %}
install.packages(
  c('servr', 'knitr'),
  type = 'source',
  repos = c('http://yihui.name/xran', 'http://cran.rstudio.com')
)
{% endhighlight %}

## In RStudio

{% highlight r linenos %}
servr::jekyll(input = "_rmd", output = "source/_posts")
{% endhighlight %}

