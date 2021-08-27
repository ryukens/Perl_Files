use warnings;
use strict;
use utf8;
use Encode qw/encode decode/;
use Config;
binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";
use 5.28.1;

my $file_in = '..\Documentos\abc.txt';
my $file_out = '..\Documentos\xyz.txt';
my $linea;

open(FH, '<', $file_in) or die $!;
open(FHO, '+>', $file_out) or die $!;

while (<FH>) {
    $linea = $_;
    print "linea1 $linea \n";
    my $linea_enc = encode("euc-jp", $linea);
    my $linea_dec = decode("utf-8", $linea_enc);
    #print "linea2 $linea \n";
    print "linea_enc: $linea_enc \n";
    print "linea_enc: $linea_dec \n";
    print FHO $linea_dec;
}

close(FH);
close(FHO);

