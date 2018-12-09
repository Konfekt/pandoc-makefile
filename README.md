If you are new to [`pandoc`](https://github.com/jgm/pandoc/), then you might want to have a look at [my short post](https://konfekt.github.io/blog/2017/03/26/pandoc-vim-setup) on how to set it up for most efficient use.

# About

This is a `Makefile` to

- compile a markdown file by [`pandoc`](https://github.com/jgm/pandoc/) to common file formats, and
- view the document,

as well as convenience commands such as,

- cleaning up, that is, removing the compiled output,
- refreshing after compilation the `HTML` file shown in the browser, such as Firefox, by [entr](https://bitbucket.org/eradman/entr/), and
- [precompiling](https://web.archive.org/web/20160712215709/http://www.howtotex.com:80/tips-tricks/faster-latex-part-iv-use-a-precompiled-preamble/) the preamble in a LaTeX file for faster compilation.

A template for a pandoc file, `main.pandoc`, is included to show what options of possible interest can be customized.

# Compiling

For example, to compile

- to a LaTeX file, `make latex`
- to a pdf file, `make latex pdf`
- to a docx file, `make docx`

Simply `make` will compile to what is set in the line starting with `all:`.
By default, `make` equals  `make latex pdf`.

For better parsing of LaTeX errors, [LaTeXRun](https://github.com/aclements/latexrun) is used to compile from LaTeX to `pdf`.

# Viewing

For example, to view the compiled

- pdf file, `make run_pdf`,
- docx file, `make run_docx`

Simply `make run` will show what is set in the line starting with `run`.
By default, `make run` equals  `make run_pdf`.
