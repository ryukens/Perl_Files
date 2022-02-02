#use Algorithm::ViterbiLog;
use Algorithm::ViterbiLogV2;
#use Algorithm::ViterbiLogV2A;
use Data::Dumper;
use strict;
use 5.28.1;

my $file_in = '..\Documentos\simulador\vector_inicial.csv';
my $file_emi = '..\Documentos\simulador\probabilidades_emision.csv';
my $file_tra = '..\Documentos\simulador\probabilidades_transicion.csv';
#my $file_obs = '..\Documentos\pruebas\Fonemas_Entrenamiento.txt';
my $file_sal = '..\Documentos\pruebas\salida.txt';

my $file_obs = '..\Documentos\pruebas\testeo.txt';

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
$v->{unknown_transition_prob} = -99;
$v->transition(\%probabilidad_transicion);
$v->emission(\%probabilidad_emision);
#$v->{unknown_emission_prob} = -99;

 
#my $observations = [ '<s>', '`s_eh_n', 't_r_ax_l', '</s>' ];
#my $observations = [ '<s>', '`s_eh_n'];
#my $observations = [ '<s>'];

#my $observations = [ '<s>', '`k_ao_r', 's_ax_t', '</s>' ];

#my $observations = [ '<s>', '`k_ao_z', 'm_ax', 'p_ax', 'l_ax_s', '</s>' ];

#my $observations = [ '<s>', '`s_eh_n', 'k_ao_z', '</s>' ];
#my $observations = [ '<s>', '`s_eh_n', 'm_ax', '</s>' ];
#my $observations = [ '<s>', '`s_eh_n', '`s_eh_n', '</s>' ];

#my $observations = [ '<s>', '`f_ow_k', '`s_ih_ng', 'er', '</s>'];

#my $observations = [ '<s>', '</s>'];

#my $observations = [ '<s>', '`t_r_ey_l', '</s>'];
#my $observations = [ '<s>', 's_t_er', '</s>'];
#my $observations = [ '<s>', 'eh_n', '`k_ae_p', 's_ax', '`l_ey', 'sh_ax_n','</s>'];

#my $observations = [ '<s>', '`s_ih_ng', 'k_r_ax','`n_ay', 'z_er', '</s>'];

#my $observations = [ '<s>', '`k_aa_t', '</s>'];
#my $observations = [ '`k_aa_t', '</s>'];

my $contador = 0;

while (<FHO>) {
    $contador += 1;
    my $linea = $_;
    chomp($linea);
    my @observacion = split(/ /, $linea, length($linea));
    
    #print "\nDumper Forward Viterbi\n";
    #print "@observacion\n";
    my ($prob_max, @path) = $v->forward_viterbi(\@observacion);

    #print "\nPROB_MAX: $prob_max\n";
    #print "@path\n";
    
    print FHS "@path\n";
}

print "\ncontador: $contador";



#print "\nDumper Forward Viterbi\n";
#print Dumper ($v->forward_viterbi($observations));

#my $observations = [ '<s>', '`l_ih_m', '`b_ao_z', '`d_ae_m', 's_ax_l', '`f_ih_sh', '</s>'];
#
#my ($prob_max, @path) = $v->forward_viterbi($observations);
#
#print "\nPROB_MAX: $prob_max\n";
#foreach my $answer (@path){
#    print "$answer ";    
#}

close(FHI);
close(FHE);
close(FHT);
close(FHO);
close(FHS);