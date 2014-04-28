web_server = science@linux.ox.ac.uk
web_root = public_html

termcards = $(web_root)/termcards

termcard_archive  = $(web_root)/termcard_archive.shtml
about             = $(web_root)/about.shtml
committee_archive = $(web_root)/committee_archive.shtml
membership        = $(web_root)/membership.shtml

tt14 = $(termcards)/tt14.shtml

all::
	@echo "This is the Makefile only for committing to GitHub."

clean::
	rm -f consolidated_bibtex_file.bib

vi:
	make readme

# Each term, add a new set of lines here:

tt14-edit:
	vi $(tt14)

tt14-install:
	scp $(tt14) $(web_server):$(termcards)/

# Other files that need to be edited each term, or each year:

termcard_archive-edit:
	vi $(termcard_archive)

termcard_archive-install:
	scp $(termcard_archive) $(web_server):$(web_root)/

about-edit:
	vi $(about)

about-install:
	scp $(about) $(web_server):$(web_root)/

committee_archive-edit:
	vi $(committee_archive)

committee_archive-install:
	scp $(committee_archive) $(web_server):$(web_root)/

membership-edit:
	vi $(membership)

membership-install:
	scp $(membership) $(web_server):$(web_root)/


include common.mk

