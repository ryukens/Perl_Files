use warnings;
use strict;

my $filename = '..\Documentos\words_list.txt';
my $filename2 = '..\Documentos\words_list_2.txt';
my $linea;
my @token;

open(FH, '<', $filename) or die $!;
open(FHO, '+>', $filename2) or die $!;

while (<FH>) {
    $linea = $_;
    @token = split(/\t/,$linea);
    print FHO $token[1]."\t".$token[2]."\t".$token[4]."\n";
}

close(FH);  
close(FHO);