use Algorithm::ViterbiLog;
use Data::Dumper;
use strict;
use 5.28.1;

my $file_in = '..\Documentos\simulador\vector_inicial.csv';
my $file_emi = '..\Documentos\simulador\probabilidades_emision.csv';
my $file_tra = '..\Documentos\simulador\probabilidades_transicion.csv';

my %vector_inicial;
my %probabilidad_emision;
my %probabilidad_transicion;

open(FHI, '<', $file_in) or die $!;
open(FHE, '<', $file_emi) or die $!;
open(FHT, '<', $file_tra) or die $!;

while (<FHI>) {
    my $linea = $_;
    chomp($linea);
    
    #print "linea: $linea \n";
    my @vector = split(/,/, $linea, length($linea));
    
    #print "parte 0: $vector[0] \n";
    #print "parte 1: $vector[1] \n\n";
    $vector_inicial{$vector[0]} = $vector[1];
}

while (<FHE>) {
    my $linea = $_;
    chomp($linea);
    
    my @emision = split(/,/, $linea, length($linea));
    
    $probabilidad_emision{$emision[0]}{$emision[1]} = $emision[2];
}

while (<FHT>) {
    my $linea = $_;
    chomp($linea);
    
    my @transicion = split(/,/, $linea, length($linea));
    
    $probabilidad_transicion{$transicion[0]}{$transicion[1]} = $transicion[2];
}

#################### VITERBI ####################

#print "\nDumper Vector Inicial\n";
#print Dumper(\%vector_inicial);
#
#print "\nDumper Probabilidad Emision\n";
#print Dumper(\%probabilidad_emision);
#
#print "\nDumper Probabilidad Transicion\n";
#print Dumper(\%probabilidad_transicion);


my $v = Algorithm::Viterbi->new();
$v->start(\%vector_inicial);
$v->transition(\%probabilidad_transicion);
$v->emission(\%probabilidad_emision);

 
my $observations = [ '<s>', '`s_eh_n', 't_r_ax_l', '</s>' ];
#my $observations = [ '<s>', '`s_eh_n'];
#my $observations = [ '<s>'];

print "\nDumper Forward Viterbi\n";
print Dumper ($v->forward_viterbi($observations));


close(FHI);
close(FHE);
close(FHT);