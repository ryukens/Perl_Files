use warnings;
no warnings 'utf8';
no warnings 'experimental';
use strict;
use utf8;
use Encode qw/encode decode/;
use Config;
binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";
use Text::Levenshtein qw(distance);
use 5.28.1;

#ENTRENAMIENTO
#my $file_fon_kat = '..\Documentos\pruebas\entrenamiento_fonema_katakana.txt';
#my $file_fon_no_val = '..\Documentos\pruebas\entrenamiento_fonemas_no_validos.txt';
#my $file_final = '..\Documentos\pruebas\entrenamiento_fonema_katakana_final.txt';

#PRUEBAS
my $file_fon_kat = '..\Documentos\pruebas\pruebas_fonema_katakana.txt';
my $file_fon_no_val = '..\Documentos\pruebas\pruebas_fonemas_no_validos.txt';
my $file_final = '..\Documentos\pruebas\pruebas_fonema_katakana_final.txt';

my $linea;
my @array_fon_no_val;
my @array_kat_og;
my @array_kat_cod;

open(FH, '<', $file_fon_kat) or die $!;
open(FHF, '<', $file_fon_no_val) or die $!;
open(FHK, '+>', $file_final) or die $!;

while (<FHF>) {
    $linea = decode("utf-8", $_);
    chomp($linea);
    push(@array_fon_no_val, $linea);
}

my $a = @array_fon_no_val;
my $cont_util = 0;
my $cont_total = 0;
while (<FH>) {
    $linea = decode("utf-8", $_);
    chomp($linea);
    my @vector = split(/\t/, $linea, length($linea));
    if (grep(/$vector[0]/, @array_fon_no_val)) {
        #print "$linea\n";
    }else{
        $cont_util++;
        print FHK "$linea\n";
    }
    $cont_total++;
    #print FHK "$linea\n";
}
print "total: $cont_total\n";
print "utilizable: $cont_util\n";

close(FH);
close(FHF);
close(FHK);

open(FHK2, '<', $file_final) or die $!;

while (<FHK2>) {
    $linea = decode("utf-8", $_);
    chomp($linea);
    my @vector = split(/\t/, $linea, length($linea));
    push(@array_kat_og, $vector[1]);
    push(@array_kat_cod, $vector[2]);
}

close(FHK2);

my $b = @array_kat_og;
my $c = @array_kat_cod;

print "b-og: $b / c-cod: $c\n";

my $umbral_1 = 0;
my $umbral_2 = 0;
my $umbral_3 = 0;
my $umbral_4 = 0;

for (my $i=0; $i<$b; $i++){
    my $distance = distance($array_kat_og[$i],$array_kat_cod[$i]);
    if ($distance >= 1 ) {
        $umbral_1++;
    }
    if ($distance >= 2 ) {
        $umbral_2++;
    }
    if ($distance >= 3 ) {
        $umbral_3++;
    }
    if ($distance >= 4 ) {
        $umbral_4++;
    }
}
print "INCORRECTO\n";
my $porc_um_1 = ($umbral_1*100)/$b;
my $porc_um_2 = ($umbral_2*100)/$b;
my $porc_um_3 = ($umbral_3*100)/$b;
my $porc_um_4 = ($umbral_4*100)/$b;
print "umbral_1: $umbral_1 / umbral_2: $umbral_2 / umbral_3: $umbral_3 / umbral_4: $umbral_4\n";
print "porc_um_1: $porc_um_1 / porc_um_2: $porc_um_2 / porc_um_3: $porc_um_3 / porc_um_4: $porc_um_4\n";


print "\nCORRECTO\n";
my $umbral_1_corr = $b - $umbral_1;
my $umbral_2_corr = $b - $umbral_2;
my $umbral_3_corr = $b - $umbral_3;
my $umbral_4_corr = $b - $umbral_4;
my $porc_um_1_corr = 100 - $porc_um_1;
my $porc_um_2_corr = 100 - $porc_um_2;
my $porc_um_3_corr = 100 - $porc_um_3;
my $porc_um_4_corr = 100 - $porc_um_4;
print "umbral_1_corr: $umbral_1_corr / umbral_2_corr: $umbral_2_corr / umbral_3_corr: $umbral_3_corr / umbral_4_corr: $umbral_4_corr\n";
print "porc_um_1_corr: $porc_um_1_corr / porc_um_2_corr: $porc_um_2_corr / porc_um_3_corr: $porc_um_3_corr / porc_um_4_corr: $porc_um_4_corr\n";
