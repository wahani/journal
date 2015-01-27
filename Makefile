# Usually, only these lines need changing
MDDIR= ./source/_posts
RMDDIR= ./_rmd

# list R-markdown files
RMD_FILES:= $(wildcard $(RMDDIR)/*.Rmd)
TMP:= $(RMD_FILES:.Rmd=.md)
MD_FILES:= $(subst $(RMDDIR), $(MDDIR), $(TMP))

all: $(MD_FILES)

# Run Rmd>md
$(MDDIR)/%.md: $(RMDDIR)/%.Rmd
	Rscript build.R $< $@

watch:
	Rscript -e 'wahaniMiscs::watch()'

clean:
	rm -fv -r images

.PHONY: clean watch
