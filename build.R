knitPost <- function(input, base.url = "/", outPath = "source/_posts/", output = NULL) {
  #input <- "2014-02-21-PlotNo1.Rmd"
  opts_knit$set(base.url = base.url)
  fig.path <- paste0("figs/", sub(".Rmd$", "", basename(input)), "/")
  opts_chunk$set(fig.path = fig.path)
  opts_chunk$set(fig.cap = "center")
  opts_chunk$set(tidy = FALSE)
  opts_chunk$set(out.width = "100%")
  opts_chunk$set(fig.width=10)
  opts_chunk$set(fig.height=5)
  render_jekyll(highlight = "pygments", extra="linenos")
  knit(input,
       output = if (is.null(output)) paste0(outPath, sub("\\.[R|r]md$", ".md", basename(input)), "") else output,
       envir = parent.frame())
}
# 

library(knitr)
# files <- list.files("_rmd", pattern = "[R|r]md", full.names = TRUE)
# lapply(files, knitPost)

args <- commandArgs(TRUE)
knitPost(args[1], output = args[2])
# knitPost("_rmd/2015-01-13-Setup-Jekyll-Octopress-and-knitr-for-workflow.rmd")

# Getting things straight with folders...
system("cp -f -r figs source")
