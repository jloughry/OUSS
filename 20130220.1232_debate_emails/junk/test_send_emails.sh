#!/bin/sh

spam()
{
	VICTIM=$1
	echo "spamming $VICTIM"
	rm -f tempfile
	echo "To: $VICTIM" > tempfile
	cat mime_header.txt debate_description.html >> tempfile
	/usr/lib/sendmail -t < tempfile
	sleep 1
}

spam joe.loughry@stx.ox.ac.uk
spam joe.loughry@applied-math.org

