Oxford University Scientific Society (OUSS)
===========================================

This is a copy of all files in the `~/science` directory on Oxford's web server.

How to Use the `Makefile`
-------------------------

1. Each term, edit the `Makefile` and create new targets like `tt14-edit` and
`tt14-install` for the new termcard.

2. `make termcard_archive-edit` to update the main file.

3. `make tt14-edit` and `make tt14-install` to create the new term card file.

TODO
----

1. Add new targets for `about.shtml`, `committee_archive.shtml`, and `membership.shtml`.

2. Consider a subordinate Makefile method to allow editing like this:

````
% make tt14 edit
% make tt14 install
````

3. Set up an `rsync` command that can refresh the entire OUSS web site from this
repository automatically, without unnecessary copying of files that are already
there in the same version.

4. Figure out a way to save the large audio (MP3) files without using up space
in Git.

