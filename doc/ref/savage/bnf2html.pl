#!/usr/bin/perl -w
#
# @(#)$Id: bnf2html.pl,v 3.7 2005/07/13 18:32:35 jleffler Exp $
#
# Convert SQL-92, SQL-99 BNF plain text file into hyperlinked HTML.

use strict;
use POSIX qw(strftime);

my(%rules);	# Indexed by rule names w/o angle-brackets; each entry is a ref to a hash.
my(%keywords);	# Index by keywords; each entry is a ref to a hash.

use constant debug => 0;

sub top
{
print "<p><a href='#top'>Top</a></p>\n\n";
}

# Usage: add_entry(\%keywords, $keyword, $rule);
# Usage: add_entry(\%rules, $rhs, $rule);
sub add_entry
{
	my($reflist, $lhs, $rhs) = @_;
	${$reflist}{$lhs} = {} unless defined ${$reflist}{$lhs};
	${$reflist}{$lhs}{$rhs} = 1;
}

sub add_refs
{
	my($def, $tail) = @_;
	print "\n<!-- ADD REFS ($def) ($tail) -->\n" if debug;
	return if $tail =~ m/!!/;
	while ($tail)
	{
		$tail =~ s/^\s*//;
		if ($tail =~ m%^\&lt;([-:/\w\s]+)\&gt;%)
		{
			print "<!-- Rule - LHS: $def - RHS $1 -->\n" if debug;
			add_entry(\%rules, $1, $def);
			$tail =~ s%^\&lt;([-:/\w\s]+)\&gt;%%;
		}
		elsif ($tail =~ m%^([-:/\w]+)%)
		{
			my($token) = $1;
			print "<!-- KyWd - LHS: $def - RHS $token -->\n" if debug;
			add_entry(\%keywords, $token, $def) if $token =~ m%[[:alpha:]][[:alpha:]]% || $token eq 'C';
			$tail =~ s%^[-:/\w]+%%;
		}
		else
		{
			# Otherwise, it is punctuation (such as the BNF metacharacters).
			$tail =~ s%^[^-:/\w]%%;
		}
	}
}

# NB: webcode replaces tabs with blanks!
open WEBCODE, "webcode @ARGV |" or die "$!";

$_ = <WEBCODE>;
exit 0 unless defined($_);
chomp;

# Is it wicked to use double quoting with single quotes, as in qq'text'?
# It is used quite extensively in this script - beware!
print qq'<!DOCTYPE HTML PUBLIC "-//W3C//DTD HTML 4.0 Transitional//EN">\n';
print "<!-- Generated HTML - Modify at your own peril! -->\n";
print "<html>\n<head>\n";
print "<title> $_ </title>\n</head>\n<body>\n\n";
print "<h1> $_ </h1>\n\n";
print qq'<a name="top">&nbsp;</a>\n';

print "<br>\n";
print qq'<a href="#xref-rules"> Cross-Reference: rules </a>\n';
print "<br>\n";
print qq'<a href="#xref-keywords"> Cross-Reference: keywords </a>\n';
print "<br>\n";

sub rcs_id
{
	my($id) = @_;
	$id =~ s%^(@\(#\))?\$[I]d: %%o;
	$id =~ s% \$$%%o;
	$id =~ s%,v % %o;
	$id =~ s%\w+ Exp( \w+)?$%%o;
	my(@words) = split / /, $id;
	my($version) = "file $words[0] version $words[1] dated $words[2] $words[3]";
	return $version;
}

sub iso8601_format
{
	my($tm) = @_;
	my $today = strftime("%Y-%m-%d %H:%M:%S+00:00", gmtime($tm));
	return($today);
}


# Print hrefs for non-terminals and keywords.
# Also substitute /* Nothing */ for an absence of productions between alternatives.
sub print_tail
{
	my($tail, $tcount) = @_;
	while ($tail)
	{
		my($newtail);
		if ($tail =~ m%^\s+%)
		{
			my($spaces) = $&;
			$newtail = $';
			print "<!-- print_tail: SPACES = '$spaces', NEWTAIL = '$newtail' -->\n" if debug;
			$spaces =~ s% {4,8}%&nbsp;&nbsp;&nbsp;&nbsp;%g;
			print $spaces;
			# Spaces are not a token - don't count them!
		}
		elsif ($tail =~ m%^'[^']*'% || $tail =~ m%^"[^"]*"% || $tail =~ m%^!!.*$%)
		{
			# Quoted literal - print and ignore.
			# Or meta-expression...
			my($quote) = $&;
			$newtail = $';
			print "<!-- print_tail: QUOTE = <$quote>, NEWTAIL = '$newtail' -->\n" if debug;
			$quote =~ s%!!.*%<font color="red"> $quote </font>%;
			print $quote;
			$tcount++;
		}
		elsif ($tail =~ m%^\&lt;([-:/\w\s]+)\&gt;%)
		{
			my($nonterm) = $&;
			$newtail = $';
			print "<!-- print_tail: NONTERM = '$nonterm', NEWTAIL = '$newtail' -->\n" if debug;
			$nonterm =~ s%\&lt;([-:/\w\s]+)\&gt;%<a href='#$1'>\&lt;$1\&gt;</a>%;
			print " $nonterm";
			$tcount++;
		}
		elsif ($tail =~ m%^[\w_]+%)
		{
			# Keyword
			my($keyword) = $&;
			$newtail = $';
			print "<!-- print_tail: KEYWORD = '$keyword', NEWTAIL = '$newtail' -->\n" if debug;
			print qq' <a href="#xref-$keyword"> $keyword </a>';
			$tcount++;
		}
		else
		{
			# Metacharacter, string literal, etc.
			$tail =~ m%\S+%;
			my($symbol) = $&;
			$newtail = $';
			print "<!-- print_tail: SYMBOL = '$symbol', NEWTAIL = '$newtail' -->\n" if debug;
			if ($symbol eq '|')
			{
				print "<font color=red>/* Nothing */</font> " if $tcount == 0;
				$tcount = 0;
			}
			else
			{
				$symbol =~ s%...omitted...%<font color=red>/* $& */</font>%i;
				$tcount++;
			}
			print " $symbol";
		}
		$tail = $newtail;
	}
	return($tcount);
}

my $hr_count = 0;
my $tcount = 0;			# Ick!
my $def;			# Current rule

# Don't forget - the input has been web-encoded!

while (<WEBCODE>)
{
	chomp;
	next if /^===*$/o;
	s/\s+$//o;	# Remove trailing white space
	if (/^[ 	]*$/)
	{
		print "\n";
	}
	elsif (/^---*$/)
	{
		print "<hr>\n";
	}
	elsif (/^@.#..Id:/)
	{
		# Convert what(1) string identifier into version information
		my $id = '$Id: bnf2html.pl,v 3.7 2005/07/13 18:32:35 jleffler Exp $'; 
		my($v1) = rcs_id($_);
		my $v2 = rcs_id($id);
		print "<p><font color=green><i><small>\n";
		print "Derived from $v1\n";
		my $today = iso8601_format(time);
		print "<br>\n";
		print "Generated on $today by $v2\n";
		print "</small></i></font></p>\n";
	}
	elsif (/ ::=/)
	{
		# Definition line
		$def = $_;
		$def =~ s%\&lt;([-:/()\w\s]+)\&gt;.*%$1%;
		my($tail) = $_;
		$tail =~ s%.*::=\s*%%;
		print qq'<p><a name="$def"> &nbsp; </a>\n';
		print qq'<a href="#xref-$def"> &lt;$def&gt; </a>&nbsp;&nbsp;&nbsp;::=';
		$tcount = 0;
		if ($tail)
		{
			add_refs($def, $tail);
			print "&nbsp;&nbsp;";
			$tcount = print_tail($tail, $tcount);
		}
		print "\n";
	}
	elsif (/^\s/)
	{
		# Expansion line
		add_refs($def, $_);
		print "<br>";
		$tcount = print_tail($_, $tcount);
	}
	elsif (m/^--[\/]?(\w+)/)
	{
		# Pseudo-directive line in lower-case
		# Print a 'Top' link before <hr> tags except first.
		top if /--hr/ && $hr_count++ > 0;
		s%--(/?[a-z][a-z\d]*)%<$1>%;
		s%\&lt;([-:/\w\s]+)\&gt;%<a href='#$1'>\&lt;$1\&gt;</a>%g;
		print "$_\n";
	}
	elsif (m%^--##%)
	{
		# Undo web-coding
		s%&gt;%>%g;
		s%&lt;%<%g;
		s%&amp;%&%g;
		s%^--##\s*%%;
		print "$_\n";
	}
	elsif (m/^--%start\s+(\w+)/)
	{
		# Designated start symbol
		my $start = $1;
		print qq'<p><b>Start symbol: </b> <a href="#$start"> $start </a></p>\n';
	}
	else
	{
		# Anything unrecognized passed through unchanged!
		print "$_\n";
	}
}

# Print index of initial letters for keywords.
sub print_index_key
{
	my($prefix, @keys) = @_;
	my %letters = ();
	foreach my $keyword (@keys)
	{
		my $initial = uc substr $keyword, 0, 1;
		$letters{$initial} = 1;
	}
	foreach my $letter ('A' .. 'Z')
	{
		if (defined($letters{$letter}))
		{
			print qq'<a href="#$prefix-$letter"> $letter </a>\n';
		}
		else
		{
			print qq'$letter\n';
		}
	}
	print "\n";
}

### Generate cross-reference tables

{
print "<br>\n\n";
print "<hr>\n";
print qq'<a name="xref-rules"></a>\n';
print "<h2> Cross-Reference Table: Rules </h2>\n";

print_index_key("rules", keys %rules);

print "<table border=1>\n";
print "<tr> <th> Rule (non-terminal) </th> <th> Rules using it </th> </tr>\n";
my %letters = ();

foreach my $rule (sort { uc $a cmp uc $b } keys %rules)
{
	my $initial = uc substr $rule, 0, 1;
	my $label = "";
	if (!defined($letters{$initial}))
	{
		$letters{$initial} = 1;
		$label = qq'<a name="rules-$initial"> </a>';
	}
	print qq'<tr> <td> $label <a name="xref-$rule"> </a> <a href="#$rule"> $rule </a> </td>\n     <td> ';
	my $pad = "";
	foreach my $ref (sort { uc $a cmp uc $b } keys %{$rules{$rule}})
	{
		print qq'$pad<a href="#$ref"> &lt;$ref&gt; </a>\n';
		$pad = "          ";
	}
	print "     </td>\n</tr>\n"; 
}
print "</table>\n";
print "<br>\n";
top;
}

{
print "<hr>\n";
print qq'<a name="xref-keywords"></a>\n';
print "<h2> Cross-Reference Table: Keywords </h2>\n";

print_index_key("keywords", keys %keywords);

print "<table border=1>\n";
print "<tr> <th> Keyword </th> <th> Rules using it </th> </tr>\n";
my %letters = ();
foreach my $keyword (sort { uc $a cmp uc $b } keys %keywords)
{
	my $initial = uc substr $keyword, 0, 1;
	my $label = "";
	if (!defined($letters{$initial}))
	{
		$letters{$initial} = 1;
		$label = qq'<a name="keywords-$initial"> </a>';
	}
	print qq'<tr> <td> $label <a name="xref-$keyword"> </a> $keyword </td>\n     <td> ';
	my $pad = "";
	foreach my $ref (sort { uc $a cmp uc $b } keys %{$keywords{$keyword}})
	{
		print qq'$pad<a href="#$ref"> &lt;$ref&gt; </a>\n';
		$pad = "          ";
	}
	print "     </td>\n</tr>\n"; 
}
print "</table>\n";
print "<br>\n";
top;
print "<hr>\n";
}

printf "%s\n", q'Please send feedback to Jonathan Leffler, variously:';
printf "%s\n", q'<a href="mailto:jleffler@us.ibm.com"> jleffler@us.ibm.com </a> or';
printf "%s\n", q'<a href="mailto:jonathan.leffler@gmail.com"> jonathan.leffler@gmail.com </a>.';


print "\n</body>\n</html>\n";

