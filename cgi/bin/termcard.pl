# Output a termcard for a given term
# If input is term=MT&year=1997, does yellow-background version
# If input is interm=MT1998, does version wrapped in
# thisterm_termcard_prelim.html and thisterm_termcard_postlim.html

# Input via CGI POST or CGI GET method

sub daycount_to_date
{
    # Convert count since Jan 0th to a date
    # bloody leap-years
    @month_names = (January,February,March,April,May,June,July,August,September,October,November,December);
    @monlen = (31,28,31,30,31,30,31,31,30,31,30,31);
    @ordinalb = ("1st","2nd","3rd","4th","5th","6th","7th","8th","9th","10th","11th","12th","13th","14th","15th","16th","17th","18th","19th","20th","21st","22nd","23rd","24th","25th","26th","27th","28th","29th","30th","31st");

    $year = @_[1];
    $day = @_[0];

    if ($year % 4 == 0 && ($year % 100 !=0 || $year % 400 == 0))
    {
        $leapyear = 1;
        @monlen[1]++;
    }

    $c = 0;$m = 0;
    while ($c < $day && $m<12)
    {
        $c += $monlen[$m];
        $m ++;
    }
    $m--;
    $c -= $monlen[$m];
    $str = $month_names[$m]." ".$ordinalb[$day-$c-1];
    return $str;
}

sub realdate
{
    # Input is of the form dayname/weeknum/termname
    # What's perl date handling like?
    # We record Sun 0th week of each term in a hash, then just add week*7+off
    %starts = (HT1996,11,TT1996,109,MT1996,280,
               HT1997,12,TT1997,110,MT1997,278,
               HT1998,11,TT1998,109,MT1998,277,
               HT1999,10,TT1999,108,MT1999,276,
               HT2000,9,TT2000,114,MT2000,275,
               HT2001,7,TT2001,112,MT2001,273,
               HT2002,6,TT2002,104,MT2002,279,
               HT2003,12,TT2003,110,MT2003,278,
               HT2004,11,TT2004,109,MT2004,277,
               HT2005,9,TT2005,107,MT2005,275,
               HT2006,8,TT2006,106,MT2006,274,
	       HT2007,7, TT2007,105,MT2007,273,
	       HT2008,6,TT2008,104);
    %dayoff = (Mon,1,Tue,2,Wed,3,Thu,4,Fri,5,Sat,6,Sun,0);
    ($day,$week,$term) = split "\/",$_[0];
    $year = substr($term,2);
    $startd = $starts{$term};
    $d = $startd + $dayoff{$day} + $week*7;
    return daycount_to_date($d,$year);
}

sub niceform
{
    %longform = (Mon,Monday,Tue,Tuesday,Wed,Wednesday,Thu,Thursday,Fri,Friday,Sat,Saturday,Sun,Sunday);
    %ordinal = (1,First,2,Second,3,Third,4,Fourth,5,Fifth,6,Sixth,7,Seventh,8,Eighth,9,Ninth);
    
    $dat = $_[0];
    $time = $_[1];
    ($day,$week,$term) = split "\/",$dat;
    print "$longform{$day} ".lc($ordinal{$week})." week (".realdate($dat).") $time";
}

print (<<RABBIT);
Content-type: text/html\n\n
    
RABBIT

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

if ($indices{"rabbit"} ne "")
{
    for $i (0..365)
    {
         print "<p>$i ",daycount_to_date($i,$indices{"rabbit"}),"\n";
    }
}

open EVENTS,"<events.txt";
open SPEAKERS,"<speakers.txt";

if ($mode eq "yellow")
{
    print (<<RABBIT);

<?xml version="1.0" encoding="UTF-8"?>

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.1//EN" "http://www.w3.org/TR/xhtml11/DTD/xhtml11.dtd">

<html>

<head>

<title>Oxford University Scientific Society - Termcard for $interm</title>

<meta http-equiv="refresh" content="0;url=http://users.ox.ac.uk/~science/termcard_archive.shtml"></head>

<link rel="shortcut icon" href="http://users.ox.ac.uk/~science/favicon.ico" />

<link type="text/css" rel="stylesheet" href="http://users.ox.ac.uk/~science/includes/style.css" />

</head>

<body>

<h1>
RABBIT

    print "Termcard for $interm</h1>";
}
else
{
    open PRELIM,"<thisterm_termcard_prelim.html";
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
while (<EVENTS>)
{
  # Ignore blank or commented-out lines
  unless ($_ eq "\n" || substr($_,0,1) eq "#")
  {
    chomp;
    ($yahr)=split "\\\\",$_;
    ($day,$week,$term)=split "\/",$yahr;
    if ($term eq $interm)
    {
      $offline[$index++]=$_;
    }
  }
}

if ($index == 0)
{
    print "No data found for this term\n";
}

else
{
    while (<SPEAKERS>)
    {
         # Ignore blank or commented-out lines
         unless ($_ eq "\n" || substr($_,0,1) eq "#")
         {
               chomp;
               ($nom,$realname,$dept,$homepg,$deptpg,$addr,$email,$field)=split "\\\\",$_;
               $srealname{$nom}=$realname;
               $sdept{$nom}=$dept;
               $shomepg{$nom}=$homepg;
               $sdeptpg{$nom}=$deptpg;
         }  
    }
    
    print "<table class=\"archive\">\n";
    print "<tr>
           <th>When?</th>
           <th>Where?</th>
           <th>Who?</th>
           <th>What?</th></tr>\n";
    
    %classcode = (speak,speaker,commit,meeting,commitelect,meeting,visit,visit);
    
    foreach $i (@offline)
    {
	@details = split "\\\\",$i;
	$date = shift @details;
	$time = shift @details;
	$place = shift @details;
	$type = shift @details;
	print "<tr class=\"".$classcode{$type}."\">";
	print "<td>";
	niceform($date,$time);
	print "</td><td>$place</td>";
	if ($type eq "speak")
	{
	    $spkr = shift @details;
	    $title = shift @details;
	    $web = shift @details;
	    print "<td>";
	    if ($srealname{$spkr} ne "")
	    {
		$spkweb = $shomepg{$spkr};
		$spknm = $srealname{$spkr};
		$spkdep = $sdept{$spkr};
		$spkdweb = $sdeptpg{$spkr};
		
		if ($spkweb ne "")
		{
		    $spknm = qq!<a href="$spkweb">! . $spknm ."</a>";
		}
		print "$spknm (";
		if ($spkdweb ne "")
		{
		    $spkdep = qq!<a href="$spkdweb">! . $spkdep ."</a>";
		}
		print "$spkdep)";
	    }
	    else
	    {
		print $spkr;
	    }
	    
	    if ($web ne "")
	    {
		$title = qq!<a href="http://users.ox.ac.uk/~science$web">! . $title."</a>";
	    }
	    print "</td><td>$title";
	}
	if ($type eq "commit")
	{
	    print "<td colspan=2>Committee meeting";
	}
	if ($type eq "commitelect")
	{
	    print "<td colspan=2>Committee meeting <strong>and elections</strong>";
	}
	if ($type eq "visit")
	{
	    $place = shift @details;
	    $web = shift @details;
	    print "<td colspan=2>";
	    if ($web ne "")
	    {
	print qq!<a href="$web">$place</a>!;	
	    }
	    else
	    {
		print "$place";
	    }
	}
        print "</td></tr>\n";
    }
    print "</table>\n";
}

if ($mode eq "yellow")
{
  print (<<BACK_TO_PERL)
</body></html>
BACK_TO_PERL
}
else
{
    open POSTLIM,"<thisterm_termcard_postlim.html";
    while (<POSTLIM>) {print;}
}