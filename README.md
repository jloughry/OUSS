Oxford University Scientific Society (OUSS)
===========================================

This is a copy of all files in the `~/science` directory on Oxford's web server.

Privacy
-------

As it is a copy of what's on the web server, there is no confidential information
in this repository.

How to Use the `Makefile`
-------------------------

1. Each term, edit the `Makefile` and create a new target like `tt14` for the
new termcard.

2. `make termcard_archive` to update the main file.

3. `make tt14` to create the new term card file.

4. `make install` to copy only files that changed to the remote web server.

5. `make commit` to push changes to GitHub.

TODO
----

1. Figure out a way to save the large audio (MP3) files without using up space
in Git.

2. Automated check in Makefile for files with permissions other than -rw-r--r--.

3. Consider a subordinate Makefile method to allow editing like this:

````
% make tt14 edit
% make tt14 install
````
Notes:
------

Many people have asked on the web how to get `rsync` to report only the changes
it makes to the remote directory. The best way I have found to accomplish this
trick is to use

    rsync -cir local_directory/ user@remote_host:remote_directory/

which tells `rsync` to compare checksums instead of date/time on files and
directories. It seems to work pretty well in this application.

To find all files with 'execute' permissions but ignore certain directories,
use `find . -type f -perm /a+x -not -path "./.git*" -not -path ".cgi/bin/*"`.
This is much better than the extremely confusing `-prune` option on `find(1)`.

