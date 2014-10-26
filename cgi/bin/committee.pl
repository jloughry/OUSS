# Output a committee table for a given term
# If input is term=MT&year=1997, does yellow-background version
# If input is interm=MT1998, does version wrapped in
# thisterm_committee_prelim.html and thisterm_committee_postlim.html

# Input via CGI POST or CGI GET method

print "Content-type: text/html\n\n";

$len = $ENV{'CONTENT_LENGTH'};
read(STDIN,$input,$len);
($first,$second) = split "&",$input;
($v1,$v2)=split "=",$first;$indices{$v1}=$v2;
($v1,$v2)=split "=",$second;$indices{$v1}=$v2;
($first,$second) = split "&",$ENV{'QUERY_STRING'};
($v1,$v2)=split "=",$first;$indices{$v1}=$v2;
($v1,$v2)=split "=",$second;$indices{$v1}=$v2;

if ($indices{"interm"} eq "")
{
  $interm = $indices{"term"}.$indices{"year"};
  $mode = "yellow";
}
else
{
  $interm = $indices{"interm"};
  $mode = "white";
}

open OFFICES,"<offices.txt";
open PEOPLE,"<people.txt";

if ($mode eq "yellow")
{
    print (<<RABBIT);
<html>

<head>
<title>Science Society committee query</title>
<link rel="stylesheet" href="/~science/scisoc.css" />
</head>

<body>
RABBIT

    print "<h1>Committee for $interm</h1>";
}
else
{
    open PRELIM,"<thisterm_committee_prelim.html";
    while (<PRELIM>)
    {
        if($_ =~ /MENU/)
        {
            open MENU,"../public_html/menu.html";
            while (<MENU>) {print;}
        }
        else
        {
            print;
        } 
    }
}

$index=0;
while (<OFFICES>)
{
  # Ignore blank or commented-out lines
  unless ($_ eq "\n" || substr($_,0,1) eq "#")
  {
    chomp;
    ($term)=split "\\\\",$_;
    if ($term eq $interm)
    {
      # Cut off the first term (which is the term)
      s/[^\\]*\\(.*)/\1/;
      $offline[$index++]=$_;
    }
  }
}

if ($index == 0)
{
    print "<h1>Sorry, there was no data found for this term</h1>\n";
}

while (<PEOPLE>)
{
  # Ignore blank or commented-out lines
  unless ($_ eq "\n" || substr($_,0,1) eq "#")
  {
    chomp;
    ($nom,$col,$ema,$web)=split "\\\\",$_;
    $pcollege{$nom}=$col;
    $pemail{$nom}=$ema;
    $pweb{$nom}=$web;
  }  
}

print "<table class=\"committee\">\n";

foreach $i (@offline)
{
  print "<tr><td class=\"committee\">";
  @details = split "\\\\",$i;
  $office = shift @details;
  print $office,"</td><td class=\"committee\">";
  foreach $holder (@details)
  {
    if ($pemail{$holder} ne "")
    {
      print qq/<a href="mailto:$pemail{$holder}">/;
    }
    print "$holder ($pcollege{$holder})";
    if ($pemail{$holder} ne "")
    {
      print "</a>";
    }
    print "<br/>";
  }
  print "</td></tr>\n";
}

print "</table>\n";

if ($mode eq "yellow")
{
  print (<<BACK_TO_PERL)
</body></html>
BACK_TO_PERL
}
else
{
  open POSTLIM,"<thisterm_committee_postlim.html";
  while (<POSTLIM>) {print;}
}
 








