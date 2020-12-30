# Use maximal number of CPU cores
MAKEFLAGS += --jobs=$(shell getconf _NPROCESSORS_ONLN) 
# Only ouput invoked command if $VERBOSE is set
$(VERBOSE).SILENT:

# the NAME of the main file NAME.pandoc, for example, main.pandoc
NAME  = main
FILES = # (sub)files, for example, for each chapter one chapter.md
DEP   = $(NAME).pandoc $(FILES)
# # When there are images, you might want to add 
# $(wildcard images/*.{jpg,jpeg,png,gif})

# OPTIONS {{{
PANDOC_OPTIONS        = \
												--standalone \
# # When there are references (to sections, figures, tables, ...),
#	# you might want to add
							          # --filter=pandoc-crossref \
# # When there are citations (to bibliography), you might want to add
							          #  --citeproc \
# # or, for pandoc versions < 2.1,
							          #  --filter=pandoc-citeproc \
#	# You might want to add additional options, such as:
							          # --toc --toc-depth 2 --number-sections

PANDOC_DOCX_OPTIONS   = # --reference-doc=FILE
PANDOC_ODT_OPTIONS    = # --reference-doc=FILE
PANDOC_EPUB_OPTIONS   = \
#	# You might want to add a stylesheet, such as:
										    # --epub-stylesheet ~/.pandoc/stylesheets/solarized.css
PANDOC_HTML_OPTIONS   = \
												--self-contained \
# # when there are are formulas, you might want to add
												# --mathml \
#	# You might want to add a stylesheet, such as:
										    # --css ~/.pandoc/stylesheets/solarized.css
# # e-mail obfuscation
												# --email-obfuscation=references

PANDOC_LATEX_OPTIONS  = \
#	# You might want to add a custom header, such as:
											# --include-in-header ~/.pandoc/headers/latex/header.tex
PANDOC_BEAMER_OPTIONS = # --reference-doc=FILE
#	# You might want to add a custom header, such as:
											# --include-in-header ~/.pandoc/headers/beamer/header.tex
# PANDOC_PDF_OPTIONS    = -fmt=preamble
# }}}

# COMPILE {{{
all: latex pdf
docx: $(DEP)
	pandoc \
		$(PANDOC_OPTIONS) \
		$(PANDOC_DOCX_OPTIONS) \
		--from markdown --to docx \
		$(NAME).pandoc $(FILES) --output $(NAME).docx
odt: $(DEP)
	pandoc \
		$(PANDOC_OPTIONS) \
		$(PANDOC_ODT_OPTIONS) \
		--from markdown --to odt \
		$(NAME).pandoc $(FILES) --output $(NAME).odt
epub: $(DEP)
	pandoc \
		$(PANDOC_OPTIONS) \
		$(PANDOC_EPUB_OPTIONS) \
		--from markdown --to epub \
		$(NAME).pandoc $(FILES) --output $(NAME).epub
html: $(DEP)
	pandoc \
		$(PANDOC_OPTIONS) \
		$(PANDOC_HTML_OPTIONS) \
		--from markdown --to html5 \
		$(NAME).pandoc $(FILES) --output $(NAME).html
latex: $(DEP)
	pandoc \
		$(PANDOC_OPTIONS) \
		$(PANDOC_LATEX_OPTIONS) \
		--from markdown --to latex \
		$(NAME).pandoc $(FILES) --output $(NAME).tex
beamer: $(DEP)
		pandoc \
			$(PANDOC_OPTIONS) \
			$(PANDOC_BEAMER_OPTIONS) \
			--from markdown --to beamer \
			$(NAME).pandoc $(FILES) --output $(NAME).tex
pdf:
	latexrun --latex-args="$(PANDOC_PDF_OPTIONS)" --color never $(NAME).tex
# pdf:
# 	pandoc \
# 		$(PANDOC_OPTIONS) \
# 		$(PANDOC_LATEX_OPTIONS) \
#     --pdf-engine-opt="$(PANDOC_PDF_OPTIONS)" \
# 		--from markdown --to latex \
# 		$(NAME).pandoc $(FILES) --output $(NAME).pdf
# }}}

# RUN {{{
run: run-pdf
run-docx: docx
	libreoffice --nologo $(NAME).docx \
	>/dev/null 2>&1 &
run-odt: odt
	okular $(NAME).odt \
	>/dev/null 2>&1 &
run-epub: epub
	okular $(NAME).epub \
	>/dev/null 2>&1 &
run-html: html
	$(BROWSER) $(NAME).html \
	>/dev/null 2>&1 &
run-pdf:
	$(PDFVIEWER) $(NAME).pdf \
	>/dev/null 2>&1 &
# }}}

# CLEAN {{{
clean: clean-docx clean-odt clean-epub clean-html clean-latex clean-pdf
clean-docx:
	rm --force --verbose *.docx
clean-odt:
	rm --force --verbose *.odt
clean-epub:
	rm --force --verbose *.epub
clean-html:
	rm --force --verbose *.html
clean-latex:
	rm --force --verbose $(NAME).tex
clean-pdf:
	latexrun --clean-all
	rm --force --verbose $(NAME).pdf
# }}}

# CHECK {{{
check: check_latex
check_html:
	linkchecker $(NAME).html
check_latex:
	lacheck $(NAME).tex
# }}}

preamble: $(NAME).tex
	pdftex -ini -interaction=nonstopmode -jobname=preamble "&pdflatex" mylatexformat.ltx $(NAME).tex

watch: html
	if command -v entr > /dev/null; then \
		find . -print | grep -i '.*[.]html' | entr -n reload-browser Firefox; \
	else $(MAKE) run-html; \
		echo "\nInstall entr(1) to run tasks on file change. \n"; \
		echo "See http://entrproject.org/"; fi

.PHONY: all run clean check

# ex: ft=make:foldmethod=marker:

