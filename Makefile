all::
	@echo "This is the Makefile only for committing to GitHub."

clean::
	rm -f consolidated_bibtex_file.bib

vi:
	make readme

include common.mk

