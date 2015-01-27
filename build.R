library(knitr)

args <- commandArgs(TRUE)
input <- args[1]
output <- args[2]

figPath <- paste0("images/", sub(".Rmd$", "", basename(input)), "/")
opts_chunk$set(fig.path = figPath)
opts_knit$set(base.url="/images/")
opts_chunk$set(fig.cap = "center")
opts_chunk$set(tidy = FALSE)
opts_chunk$set(out.width = "100%")
opts_chunk$set(fig.width=7)
opts_chunk$set(fig.height=4)
render_jekyll()

knit(input = args[1], output = args[2])

system("cp -f -r images source/images")
system("rm -r images")
