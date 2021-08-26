use strict;
use warnings;
use Encode;
use utf8;
use Config;
binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";
use Data::Dump qw(dump);

my $text = "xxx";
$text =~ s/regex1/reemplazo1/gm;
print "a";
print $text;
$text =~ s/regex2/reemplazo2/gm;
print "b";
print $text;
