# # the NAME of the main file NAME.pandoc, for example, main.pandoc
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
							          #  --filter=pandoc-citeproc \
#	# You might want to add additional options, such as:
							          # --toc --toc-depth 2 --number-sections

PANDOC_DOCX_OPTIONS   = # --reference-docx=FILE
PANDOC_ODT_OPTIONS    = # --reference-odt=FILE
PANDOC_EPUB_OPTIONS   = \
#	# You might want to add a stylesheet, such as:
										    # --epub-stylesheet ~/.pandoc/stylesheets/solarized.css
PANDOC_HTML_OPTIONS   = \
												--self-contained \
# # when there are are formulas, you might want to add
												# --mathml \
#	# You might want to add a stylesheet, such as:
										    # --css ~/.pandoc/stylesheets/solarized.css
PANDOC_LATEX_OPTIONS  = \
#	# You might want to add a custom header, such as:
											# --include-in-header ~/.pandoc/headers/latex/header.tex
PANDOC_BEAMER_OPTIONS = \
#	# You might want to add a custom header, such as:
											# --include-in-header ~/.pandoc/headers/beamer/header.tex
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
# pdf: latex beamer
	# latexrun --color never $(NAME).tex
pdf:
	latexrun --color never $(NAME).tex
# }}}

# RUN {{{
run: run_pdf
run_docx: docx
	libreoffice --nologo $(NAME).docx \
	>/dev/null 2>&1 &
run_odt: odt
	okular $(NAME).odt \
	>/dev/null 2>&1 &
run_epub: epub
	okular $(NAME).epub \
	>/dev/null 2>&1 &
run_html: html
	$(BROWSER) $(NAME).html \
	>/dev/null 2>&1 &
run_pdf:
	$(PDFVIEWER) $(NAME).pdf \
	>/dev/null 2>&1 &
# }}}

# CLEAN {{{
clean: clean_docx clean_odt clean_epub clean_html clean_latex clean_pdf
clean_docx:
	rm --force --verbose *.docx
clean_odt:
	rm --force --verbose *.odt
clean_epub:
	rm --force --verbose *.epub
clean_html:
	rm --force --verbose *.html
clean_latex:
	rm --force --verbose $(NAME).tex
clean_pdf:
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

preamble_latex: $(NAME).tex
	pdftex -ini -interaction=nonstopmode -jobname=preamble "&pdflatex" mylatexformat.ltx $(NAME).tex

watch_html: html
	if command -v entr > /dev/null; then \
		find . -print | grep -i '.*[.]html' | entr -n reload-browser Firefox; \
	else $(MAKE) run_html; \
		echo "\nInstall entr(1) to run tasks on file change. \n"; \
		echo "See http://entrproject.org/"; fi

.PHONY: all run clean check

# ex: ft=make:foldmethod=marker:

