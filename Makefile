web_server = science@linux.ox.ac.uk
web_root = public_html

termcards = $(web_root)/termcards

termcard_archive = $(web_root)/termcard_archive.shtml
tt14 = $(termcards)/tt14.shtml

all::
	@echo "This is the Makefile only for committing to GitHub."

clean::
	rm -f consolidated_bibtex_file.bib

vi:
	make readme

# Add each term's term card here:

tt14-edit:
	vi $(tt14)

tt14-install:
	scp $(tt14) $(web_server):$(termcards)/

# Term Card Archive:

termcard_archive-edit:
	vi $(termcard_archive)

termcard_archive-install:
	scp $(termcard_archive) $(web_server):$(web_root)/

include common.mk

