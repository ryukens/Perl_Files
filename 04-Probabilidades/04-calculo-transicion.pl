use warnings;
no warnings 'uninitialized';
no warnings 'utf8';
use strict;
use utf8;
use Encode qw/encode decode/;
use Config;
binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";
use Data::Dumper;
use 5.28.1;

#my $file_in = '..\Documentos\results_test.txt';
my $file_in = '..\Documentos\diccionario_transicion.txt';
my $file_out = '..\Documentos\simulador\probabilidades_transicion.csv';
my $file_vect = '..\Documentos\simulador\vector_inicial.csv';
my %unigrama;
my @uni_valores;
my %unigrama_prob;
my %bigrama;
my %bigrama_prob;
my %vector_inicial;
my $linea;
my $tamano_linea;
my $uni_inicial;
my $llave_1;
my $llave_2;
my $total = 0;
my $total_s = 0;


open(FH, '<', $file_in) or die $!;
open(FHO, '+>', $file_out) or die $!;
open(FHV, '+>', $file_vect) or die $!;

while (<FH>) {
    $linea = decode("utf-8", $_);
    chomp($linea);
    my @array_linea = split(' ', $linea, length($linea));
    $tamano_linea = @array_linea;
    
    #UNIGRAMAS
    foreach my $uni (@array_linea){
        if (exists $unigrama{$uni}) {
            $unigrama{$uni} = $unigrama{$uni} + 1;
        }else{
            $unigrama{$uni} = 1;
        }
        #print "uni: $uni valor: $unigrama{$uni}\n";
    }
    
    #BIGRAMAS DE DICCIONARIO    
    for (my $a = 0; $a < $tamano_linea; $a++ ){
        my $b = $a + 1;
        if ($b != $tamano_linea) {
            if (exists $bigrama{$array_linea[$a]}{$array_linea[$b]}) {
                $bigrama{$array_linea[$a]}{$array_linea[$b]} = $bigrama{$array_linea[$a]}{$array_linea[$b]}+1;
            }else{
                $bigrama{$array_linea[$a]}{$array_linea[$b]} = 1;
            }
            #print "a: $a b: $b ";
            #print "bi: $array_linea[$a] / $array_linea[$b] valor: $bigrama{$array_linea[$a]}{$array_linea[$b]}\n";
        }            
    }
}

print ">>>>>>>>>>>>>>>>>>>>> UNIGRAMAS >>>>>>>>>>>>>>>>>>>>>\n";
@uni_valores = values %unigrama;
foreach my $valor (@uni_valores){
    $total = $total + $valor;
}
print "TOTAL: $total\n";
$total_s = $total - $unigrama{'<s>'};
print "TOTAL sin <s>: $total_s\n";
my $cant = %unigrama;
print "cantidad unigramas = $cant\n";

foreach $llave_1 (keys %unigrama){
    print "unigrama: $llave_1 valor: $unigrama{$llave_1}\n";
    if ($llave_1 eq "<s>") {
        $vector_inicial{$llave_1} = 0;
    }else{
        $vector_inicial{$llave_1} = -99;    
    }    
}

#if ($llave_1 eq "<s>") {
#    $vector_inicial{$llave_2} = $bigrama_prob{$llave_1}{$llave_2};
#}


foreach $llave_1 (keys %unigrama){
    foreach $llave_2 (keys %unigrama){        
        if (!exists $bigrama{$llave_1}{$llave_2}) {
            $bigrama{$llave_1}{$llave_2} = -99;
        }
    }
#   $unigrama_prob{$llave_1} = $unigrama{$llave_1}/$total_s;
}

#print "\n>>>>>>>>>>>>>>>>>>>>> UNIGRAMA_PROB >>>>>>>>>>>>>>>>>>>>>\n";
#foreach $llave_1 (keys %unigrama_prob){
#    print "$llave_1 = $unigrama_prob{$llave_1}\n";
#}

print "\n>>>>>>>>>>>>>>>>>>>>> BIGRAMAS >>>>>>>>>>>>>>>>>>>>>\n";
foreach $llave_1 (keys %bigrama){
    foreach $llave_2 (keys %{$bigrama{$llave_1}}){
        #print "$llave_1 / $llave_2 = $bigrama{$llave_1}{$llave_2}\n";
        if ($bigrama{$llave_1}{$llave_2} == -99) {
            $bigrama_prob{$llave_1}{$llave_2} = -99;
        }else{
            my $numerador = &log_base_n(10, $bigrama{$llave_1}{$llave_2});
            my $denominador = &log_base_n(10, $unigrama{$llave_1});
            $bigrama_prob{$llave_1}{$llave_2} = $numerador - $denominador;
            
            #VECTOR INICIAL
            #if ($llave_1 eq "<s>") {
            #    $vector_inicial{$llave_2} = $bigrama_prob{$llave_1}{$llave_2};
            #}
            
            #$bigrama_prob{$llave_1}{$llave_2} = $bigrama{$llave_1}{$llave_2}/$unigrama{$llave_1};
        }
    }
}

print "\n>>>>>>>>>>>>>>>>>>>>> BIGRAMA_PROB >>>>>>>>>>>>>>>>>>>>>\n";
foreach $llave_1 (keys %bigrama_prob){
    foreach $llave_2 (keys %{$bigrama{$llave_1}}){
        #print "$llave_1 / $llave_2 = $bigrama_prob{$llave_1}{$llave_2}\n"; 
        my $st = sprintf ("%s,%s,%.6f\n", $llave_1,$llave_2,$bigrama_prob{$llave_1}{$llave_2});
        #print $st;
        print FHO $st;
        
        
    }
}

print "\n>>>>>>>>>>>>>>>>>>>>> VECTOR_INICIAL >>>>>>>>>>>>>>>>>>>>>\n";
foreach $uni_inicial (keys %vector_inicial){
    my $vc = sprintf ("%s,%.6f\n", $uni_inicial,$vector_inicial{$uni_inicial});
    #print $vc;
    print FHV $vc;
}


close (FH);
close (FHO);
close (FHV);

sub log_base_n {
    my ($base, $n) = @_;
    return log($n)/log($base)
}