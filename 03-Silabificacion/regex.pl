use warnings;
use strict;
use 5.28.1;

my $en_syl_phoneme = "`l_mk ({ 2 })";
#my $array_katakana = 'a';
my $array_katakana = 'ヲ';

print $array_katakana;
print "\n";

#if($array_katakana =~ /[abc]/){
#if($array_katakana =~ /[アヤ]/){
if($array_katakana =~ /^(ア|ヤ)/){
    print "LIST";
    
}else{
    print "LIST2";
}
