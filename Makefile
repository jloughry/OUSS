web_server = $(private_web_server_for_OUSS)

#
# Files.
#

termcard          = $(public_html)/termcard.shtml
termcard_archive  = $(public_html)/termcard_archive.shtml
about             = $(public_html)/about.shtml
committee_archive = $(public_html)/committee_archive.shtml
membership        = $(public_html)/membership.shtml
index             = $(public_html)/index.shtml
css               = $(public_html)/includes/style.css
banner            = $(public_html)/includes/banner.html

tt14 = $(termcards)/tt14.shtml
mt14 = $(termcards)/mt14.shtml
ht15 = $(termcards)/ht15.shtml
tt15 = $(termcards)/tt15.shtml

#
# Directories.
#

debate_email = 20130220.1232_debate_emails
audio        = audio
cgi          = cgi
overflow     = OUSS_web_site_overflow
public_html  = public_html

termcards = $(public_html)/termcards

#
# The rsync(1) options are: -c to use checksum instead of date/time to
# determine what files to transfer, -i to to itemise the list of files
# transferred, and -r to do subdirectories recursively.
#

rsync_command = rsync -cirl

editor = vi

all::
	@echo
	@echo "\"make all\" doesn't do anything here. Use \"make tt14\" to edit the termcard, or"
	@echo "use \"make install\" to update the files on the remote web server; \"make commit\""
	@echo "pushes all changes to GitHub."
	@echo

clean::
	rm -f consolidated_bibtex_file.bib

vi:
	make readme

#
# Most of these directories won't change very often, but $(public_html)
# will change just about every time.
#

install:
	# $(rsync_command) $(debate_email)/ $(web_server):$(debate_email)/
	# $(rsync_command) $(audio)/        $(web_server):$(audio)/
	# $(rsync_command) $(cgi)/          $(web_server):$(cgi)/
	# $(rsync_command) $(overflow)/     $(web_server):$(overflow)/
	$(rsync_command) $(public_html)/  $(web_server):$(public_html)/

#
# Each term, add a new set of lines here:
#

tt14:
	$(editor) $(tt14)

mt14:
	$(editor) $(mt14)

ht15:
	$(editor) $(ht15)

tt15:
	$(editor) $(tt15)

#
# Other files that need to be edited each term, or each year:
#

termcard:
	$(editor) $(termcard)

termcard_archive:
	$(editor) $(termcard_archive)

about:
	$(editor) $(about)

committee_archive:
	$(editor) $(committee_archive)

membership:
	$(editor) $(membership)

index:
	$(editor) $(index)

css:
	$(editor) $(css)

banner:
	$(editor) $(banner)

#
# Helper functions.
#

ssh:
	ssh $(private_web_server_for_OUSS)

include common.mk
include private.mk

