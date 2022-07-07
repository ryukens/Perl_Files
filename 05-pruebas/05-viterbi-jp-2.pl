#use Algorithm::ViterbiLogV2A; #Libreria de pruebas independientes
use Algorithm::ViterbiLogV2;
use Data::Dumper;
use strict;
use 5.28.1;
use Time::HiRes qw( time );
use Time::Seconds;

my $start = time();

my $file_in = '..\Documentos\simulador\vector_inicial.csv';
my $file_emi = '..\Documentos\simulador\probabilidades_emision.csv';
my $file_tra = '..\Documentos\simulador\probabilidades_transicion.csv';
#my $file_obs = '..\Documentos\pruebas\observaciones_Entrenamiento.txt';
my $file_obs = '..\Documentos\pruebas\observaciones_Prueba.txt';
my $file_sal = '..\Documentos\pruebas\salida.txt';

my %vector_inicial;
my %probabilidad_emision;
my %probabilidad_transicion;

open(FHI, '<', $file_in) or die $!;
open(FHE, '<', $file_emi) or die $!;
open(FHT, '<', $file_tra) or die $!;
open(FHO, '<', $file_obs) or die $!;
open(FHS, '+>', $file_sal) or die $!;

while (<FHI>) {
    my $linea = $_;
    chomp($linea);
    my @vector = split(/,/, $linea, length($linea));
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

my $v = Algorithm::Viterbi->new();
$v->start(\%vector_inicial);
$v->{unknown_emission_prob} = -99;
$v->{unknown_transition_prob} = -99;
$v->transition(\%probabilidad_transicion);
$v->emission(\%probabilidad_emision);

my $contador = 0;

while (<FHO>) {
    $contador += 1;
    my $linea = $_;
    chomp($linea);
    my @observacion = split(/ /, $linea, length($linea));
    my ($prob_max, @path) = $v->forward_viterbi(\@observacion);
    print FHS "@path\n";
}

print "\ncontador: $contador";

close(FHI);
close(FHE);
close(FHT);
close(FHO);
close(FHS);

my $end = time();
my $diff = Time::Seconds->new($end - $start);
print "\n";
print $diff->pretty;
