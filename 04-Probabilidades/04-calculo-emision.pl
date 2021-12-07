use warnings;
no warnings 'uninitialized';
no warnings 'utf8';
use strict;
use utf8;
use Encode qw/encode decode/;
use Config;
binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";
use 5.28.1;

#my $file_in = '..\Documentos\results_test.txt';
my $file_in = '..\Documentos\diccionario_emision.txt';
my $file_out = '..\Documentos\simulador\probabilidades_emision.csv';
my %unigrama;
my @uni_valores;
my @uni_katakanas;
my %unigrama_prob;
my %bigrama;
my %bigrama_prob;
my $linea;
my $tamano_linea;
my $llave_1;
my $llave_2;
my $total = 0;
my $total_s = 0;


open(FH, '<', $file_in) or die $!;
open(FHO, '+>', $file_out) or die $!;

while (<FH>) {
    $linea = decode("utf-8", $_);
    $linea =~ s/(<s>|<\/s>)//g;
    chomp($linea);
    my @array_linea = split(' ', $linea, length($linea));
    $tamano_linea = @array_linea;
    $tamano_linea = $tamano_linea - 1; #-1 porque se consideraba un espacio en blanco
    
    #UNIGRAMAS
    foreach my $uni (@array_linea){
        if ($uni ne "") {
            if (exists $unigrama{$uni}) {
                $unigrama{$uni} = $unigrama{$uni} + 1;
            }else{
                $unigrama{$uni} = 1;
            }
            #print "uni: $uni valor: $unigrama{$uni}\n";
        }
    }    
    
    #BIGRAMAS    
    for (my $a = 0; $a < $tamano_linea; $a++ ){
        my $b = $a + 1;
        if ($b != $tamano_linea) {
            if (exists $bigrama{$array_linea[$a]}{$array_linea[$b]}) {
                $bigrama{$array_linea[$a]}{$array_linea[$b]} = $bigrama{$array_linea[$a]}{$array_linea[$b]}+1;
            }else{
                $bigrama{$array_linea[$a]}{$array_linea[$b]} = 1;
            }
            
            #ARRAY KATAKANAS
            #print "kat = $array_linea[$b]\n";
            if (!grep (/^$array_linea[$b]$/, @uni_katakanas)) {
                push (@uni_katakanas, $array_linea[$b]);
                #print "INGRESADO\n";
            }
            #print "a: $a b: $b tamano_linea: $tamano_linea\n";
            #print "bi: $array_linea[$a] / $array_linea[$b] valor: $bigrama{$array_linea[$a]}{$array_linea[$b]}\n\n";
        }        
    }
    
}

push (@uni_katakanas, "<s>");
push (@uni_katakanas, "</s>");
$bigrama{"<s>"}{"<s>"} = 1;
$bigrama{"</s>"}{"</s>"} = 1;

print ">>>>>>>>>>>>>>>>>>>>> UNIGRAMAS >>>>>>>>>>>>>>>>>>>>>\n";
@uni_valores = values %unigrama;
foreach my $valor (@uni_valores){
    $total = $total + $valor;
}
print "TOTAL: $total\n";

my $cant = %bigrama;
print "cantidad bigramas = $cant\n";
my $cant_kat = @uni_katakanas;
print "cantidad katakanas = $cant_kat\n";

foreach $llave_1 (keys %bigrama){      
    foreach $llave_2 (@uni_katakanas){
        #print "llave2: $llave_2 \n";
        if (!exists $bigrama{$llave_1}{$llave_2}) {
            $bigrama{$llave_1}{$llave_2} = -99;
        }
    }
}

#print "\n>>>>>>>>>>>>>>>>>>>>> UNIGRAMA_PROB >>>>>>>>>>>>>>>>>>>>>\n";
#foreach $llave_1 (keys %unigrama){
#    print "$llave_1 = $unigrama{$llave_1}\n";
#    $unigrama_prob{$llave_1} = $unigrama{$llave_1}/$total;
#}
#
#foreach $llave_1 (keys %unigrama_prob){
    #print "$llave_1 = $unigrama_prob{$llave_1}\n";
#}

print "\n>>>>>>>>>>>>>>>>>>>>> BIGRAMAS >>>>>>>>>>>>>>>>>>>>>\n";
foreach $llave_1 (keys %bigrama){
    foreach $llave_2 (keys %{$bigrama{$llave_1}}){
        #print "$llave_1 / $llave_2 = $bigrama{$llave_1}{$llave_2}\n";
        if ($bigrama{$llave_1}{$llave_2} == -99) {
            $bigrama_prob{$llave_1}{$llave_2} = -99;
        }else{
            if ($llave_1 eq "<s>" || $llave_1 eq "</s>" ) {
                $bigrama_prob{$llave_1}{$llave_2} = 0;
            }else{
                my $numerador = &log_base_n(10, $bigrama{$llave_1}{$llave_2});
                my $denominador = &log_base_n(10, $unigrama{$llave_1});
                $bigrama_prob{$llave_1}{$llave_2} = $numerador - $denominador;
                
                #$bigrama_prob{$llave_1}{$llave_2} = $bigrama{$llave_1}{$llave_2}/$unigrama{$llave_1};
            }
        }
    }
}

#LOGARITMICO
#print FHO "<s>,<s>,0.000000\n";
#print FHO "</s>,</s>,0.000000\n";

print "\n>>>>>>>>>>>>>>>>>>>>> BIGRAMA_PROB >>>>>>>>>>>>>>>>>>>>>\n";
foreach $llave_1 (keys %bigrama_prob){
    foreach $llave_2 (keys %{$bigrama{$llave_1}}){
        #print "$llave_1 / $llave_2 = $bigrama_prob{$llave_1}{$llave_2}\n"; 
        my $st = sprintf ("%s,%s,%.6f\n", $llave_1,$llave_2,$bigrama_prob{$llave_1}{$llave_2});
        print FHO $st;
    }
}


close (FH);
close (FHO);


sub log_base_n {
    my ($base, $n) = @_;
    return log($n)/log($base)
}