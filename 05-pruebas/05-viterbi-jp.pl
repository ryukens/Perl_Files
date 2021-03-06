use Algorithm::Viterbi;
use Data::Dumper;
use strict;
use 5.28.1;
 
#my $start_probability = { 'セン'=> 0.25 , 'コ'=> 0.25 , 'コル'=> 0.25 , 'コス'=> 0.25 };

#my $start_probability = { 'サイン'=> 0.01, 'セン'=> 0.01, '<s>' => 0.09, 'コ' => 0.01, 'コル' => 0.01, 'トラル' => 0.01, 'セット' => 0.01, '</s>' => 0.01, 'コス' => 0.01, 'ティック' => 0.01, 'メ' => 0.01 };
# 
#my $transition_probability = {
# 'コス' => {'サイン'=> 0.01, 'セン'=> 0.01, '<s>' => 0.01, 'コ' => 0.01, 'コル' => 0.01, 'トラル' => 0.01, 'セット' => 0.01, '</s>' => 0.01, 'コス' => 0.01, 'ティック' => 0.01, 'メ' => 0.9},
# 'ティック' => {'サイン'=> 0.01, 'セン'=> 0.01, '<s>' => 0.01, 'コ' => 0.01, 'コル' => 0.01, 'トラル' => 0.01, 'セット' => 0.01, '</s>' => 0.9, 'コス' => 0.01, 'ティック' => 0.01, 'メ' => 0.01},
# 'メ' => {'サイン'=> 0.01, 'セン'=> 0.01, '<s>' => 0.01, 'コ' => 0.01, 'コル' => 0.01, 'トラル' => 0.01, 'セット' => 0.01, '</s>' => 0.01, 'コス' => 0.01, 'ティック' => 0.9, 'メ' => 0.01},
# 'セット' => {'サイン'=> 0.01, 'セン'=> 0.01, '<s>' => 0.01, 'コ' => 0.01, 'コル' => 0.01, 'トラル' => 0.01, 'セット' => 0.01, '</s>' => 0.9, 'コス' => 0.01, 'ティック' => 0.01, 'メ' => 0.01},
# '</s>' => {'サイン'=> 0, 'セン'=> 0, '<s>' => 0, 'コ' => 0, 'コル' => 0, 'トラル' => 0, 'セット' => 0, '</s>' => 0, 'コス' => 0, 'ティック' => 0, 'メ' => 0},
# 'トラル' => {'サイン'=> 0.01, 'セン'=> 0.01, '<s>' => 0.01, 'コ' => 0.01, 'コル' => 0.01, 'トラル' => 0.01, 'セット' => 0.01, '</s>' => 0.9, 'コス' => 0.01, 'ティック' => 0.01, 'メ' => 0.01},
# 'コル' => {'サイン'=> 0.01, 'セン'=> 0.01, '<s>' => 0.01, 'コ' => 0.01, 'コル' => 0.01, 'トラル' => 0.01, 'セット' => 0.9, '</s>' => 0.01, 'コス' => 0.01, 'ティック' => 0.01, 'メ' => 0.01},
# 'セン' => {'サイン'=> 0.01, 'セン'=> 0.01, '<s>' => 0.01, 'コ' => 0.01, 'コル' => 0.01, 'トラル' => 0.9, 'セット' => 0.01, '</s>' => 0.01, 'コス' => 0.01, 'ティック' => 0.01, 'メ' => 0.01},
# 'サイン' => {'サイン'=> 0.01, 'セン'=> 0.01, '<s>' => 0.01, 'コ' => 0.01, 'コル' => 0.01, 'トラル' => 0.01, 'セット' => 0.01, '</s>' => 0.9, 'コス' => 0.01, 'ティック' => 0.01, 'メ' => 0.01},
# 'コ' => {'サイン'=> 0.9, 'セン'=> 0.01, '<s>' => 0.01, 'コ' => 0.01, 'コル' => 0.01, 'トラル' => 0.01, 'セット' => 0.01, '</s>' => 0.01, 'コス' => 0.01, 'ティック' => 0.01, 'メ' => 0.01},
# '<s>' => {'サイン'=> 0.01, 'セン'=> 0.225, '<s>' => 0.01, 'コ' => 0.225, 'コル' => 0.225, 'トラル' => 0.01, 'セット' => 0.01, '</s>' => 0.01, 'コス' => 0.225, 'ティック' => 0.01, 'メ' => 0.01}
#};
# 
#my $emission_probability = {
# '`k_ao_r' => {'サイン'=> '0.01', 'セン'=> '0.01', '<s>' => '0', 'コ' => '0.01', 'コル' => '0.9', 'トラル' => '0.01', 'セット' => '0.01', '</s>' => '0', 'コス' => '0.01', 'ティック' => '0.01', 'メ' => '0.01'},
# '`k_ow' => {'サイン'=> '0.01', 'セン'=> '0.01', '<s>' => '0', 'コ' => '0.9', 'コル' => '0.01', 'トラル' => '0.01', 'セット' => '0.01', '</s>' => '0', 'コス' => '0.01', 'ティック' => '0.01', 'メ' => '0.01'},
# 'k_aa_z' => {'サイン'=> '0.01', 'セン'=> '0.01', '<s>' => '0', 'コ' => '0.01', 'コル' => '0.01', 'トラル' => '0.01', 'セット' => '0.01', '</s>' => '0', 'コス' => '0.9', 'ティック' => '0.01', 'メ' => '0.01'},
# '`m_eh' => {'サイン'=> '0.01', 'セン'=> '0.01', '<s>' => '0', 'コ' => '0.01', 'コル' => '0.01', 'トラル' => '0.01', 'セット' => '0.01', '</s>' => '0', 'コス' => '0.01', 'ティック' => '0.01', 'メ' => '0.9'},
# '</s>' => {'サイン'=> '0.01', 'セン'=> '0.01', '<s>' => '0', 'コ' => '0.01', 'コル' => '0.01', 'トラル' => '0.01', 'セット' => '0.01', '</s>' => '1', 'コス' => '0.01', 'ティック' => '0.01', 'メ' => '0.01'},
# '`s_eh_n' => {'サイン'=> '0.01', 'セン'=> '0.9', '<s>' => '0', 'コ' => '0.01', 'コル' => '0.01', 'トラル' => '0.01', 'セット' => '0.01', '</s>' => '0', 'コス' => '0.01', 'ティック' => '0.01', 'メ' => '0.01'},
# 't_ax_k_s' => {'サイン'=> '0.01', 'セン'=> '0.01', '<s>' => '0', 'コ' => '0.01', 'コル' => '0.01', 'トラル' => '0.01', 'セット' => '0.01', '</s>' => '0', 'コス' => '0.01', 'ティック' => '0.9', 'メ' => '0.01'},
# 's_ax_t' => {'サイン'=> '0.01', 'セン'=> '0.01', '<s>' => '0', 'コ' => '0.01', 'コル' => '0.01', 'トラル' => '0.01', 'セット' => '0.9', '</s>' => '0', 'コス' => '0.01', 'ティック' => '0.01', 'メ' => '0.01'},
# '`z_iy_n' => {'サイン'=> '0.9', 'セン'=> '0.01', '<s>' => '0', 'コ' => '0.01', 'コル' => '0.01', 'トラル' => '0.01', 'セット' => '0.01', '</s>' => '0', 'コス' => '0.01', 'ティック' => '0.01', 'メ' => '0.01'},
# 't_r_ax_l' => {'サイン'=> '0.01', 'セン'=> '0.01', '<s>' => '0', 'コ' => '0.01', 'コル' => '0.01', 'トラル' => '0.9', 'セット' => '0.01', '</s>' => '0', 'コス' => '0.01', 'ティック' => '0.01', 'メ' => '0.01'},
# 
# #'t_r_ax_l' => {'サイン'=> '0.01', 'セン'=> '0.00', '<s>' => '0', 'コ' => '0.00', 'コル' => '0.00', 'トラル' => '0.9', 'セット' => '0.01', '</s>' => '0', 'コス' => '0.00', 'ティック' => '0.01', 'メ' => '0.01'},
# 
# '<s>' => {'サイン'=> '0.01', 'セン'=> '0.01', '<s>' => '0.9', 'コ' => '0.01', 'コル' => '0.01', 'トラル' => '0.01', 'セット' => '0.01', '</s>' => '0', 'コス' => '0.01', 'ティック' => '0.01', 'メ' => '0.01'}
#};
 
#my $v = Algorithm::Viterbi->new();
#$v->start($start_probability);
#$v->transition($transition_probability);
#$v->emission($emission_probability);
# 
#my $observations = [ '<s>', '`s_eh_n', 't_r_ax_l', '</s>' ];
#my $observations = [ '<s>', '`s_eh_n', 't_r_ax_l' ];
#my $observations = [ '`s_eh_n', 't_r_ax_l' ];

#my $observations = [ '`s_eh_n'];
#my $observations = [ '`s_eh_n', '`s_eh_n'];
#my $observations = [ '<s>', '`s_eh_n' ];

#my $observations = [ 'k_aa_z' ];

#my $observations = [ 't_r_ax_l' ];

#my $observations = [ '<s>', '`k_ow', '`z_iy_n', '</s>' ];
#my $observations = [ '`k_ow', '`z_iy_n' ];
#my $observations = [ '`k_ow', '`m_eh' ];
#my $observations = [ '`z_iy_n' ];


#my ($prob, $v_path, $v_prob) = $v->forward_viterbi($observations);

#print Dumper ($v->forward_viterbi($observations));

#my $e;
#$e = $v -> get_emission('`s_eh_n', 'セン'); # $e = 0.9
#$e = $v -> get_emission('t_r_ax_l', 'コ'); # $e = 0.01
#$e = $v -> get_emission('t_r_ax_l', 'トラル'); # $e = 0.9
#print "\ne: $e \n";



my $start_probability = { 'セン'=> 0.01, '<s>' => 0.9, 'トラル' => 0.01, '</s>' => 0.01};

my $transition_probability = {
 '</s>' => {'セン'=> 0, '<s>' => 0, 'トラル' => 0, '</s>' => 1},
 'トラル' => {'セン'=> 0.01, '<s>' => 0, 'トラル' => 0.01, '</s>' => 0.9},
 'セン' => {'セン'=> 0.01, '<s>' => 0, 'トラル' => 0.9, '</s>' => 0.01},
 '<s>' => {'セン'=> 0.99, '<s>' => 0, 'トラル' => 0.01, '</s>' => 0}
};

my $emission_probability = {
#    central
 '</s>' => {'セン'=> '0.01', '<s>' => '0', 'トラル' => '0.01', '</s>' => '0.97'}, 
 '`s_eh_n' => {'セン'=> '0.97', '<s>' => '0', 'トラル' => '0.01', '</s>' => '0.01'}, #SOLO ESTE ESTA CORRECTO/LOS DEMÁS COMOM ESTE
 't_r_ax_l' => { 'セン' => '0.01', '<s>' => '0', 'トラル' => '0.97', '</s>' => '0.01'},
 '<s>' => {'セン'=> '0.01', '<s>' => '0.97', 'トラル' => '0.01', '</s>' => '0.01'}
 
# ALIMENTAR A PARTIR DE AQUI SE VA INCLUYENDO LAS DEMÁS PROBABILIDADES EN FFUNCIÓN DEL RESTO DEL CORPUS.
# ALIMENTAR UNO POR UNO.
# '`k_ao_r' => {'サイン'=> '0.01', 'セン'=> '0.01', '<s>' => '0', 'コ' => '0.01', 'コル' => '0.9', 'トラル' => '0.01', 'セット' => '0.01', '</s>' => '0', 'コス' => '0.01', 'ティック' => '0.01', 'メ' => '0.01'},
 
};

#BUCLE PARA ALIMENTAR COCN -99 LOS CASOS QUE NON EXISEN ENN FUNCIÓNN DE LA PALABRA ESPECIFICA, SOLO PARA QUE VITERBII PUEDA HACCER SU CALCULO.


my $v = Algorithm::Viterbi->new();
$v->start($start_probability);
$v->transition($transition_probability);
$v->emission($emission_probability);
 
my $observations = [ '<s>', '`s_eh_n', 't_r_ax_l', '</s>' ];

print Dumper ($v->forward_viterbi($observations));


#
#
#my $emission_probability = {
# '`k_ao_r' => {'サイン'=> '0.01', 'セン'=> '0.01', '<s>' => '0', 'コ' => '0.01', 'コル' => '0.9', 'トラル' => '0.01', 'セット' => '0.01', '</s>' => '0', 'コス' => '0.01', 'ティック' => '0.01', 'メ' => '0.01'},
# '`k_ow' => {'サイン'=> '0.01', 'セン'=> '0.01', '<s>' => '0', 'コ' => '0.9', 'コル' => '0.01', 'トラル' => '0.01', 'セット' => '0.01', '</s>' => '0', 'コス' => '0.01', 'ティック' => '0.01', 'メ' => '0.01'},
# '</s>' => {'サイン'=> '0.01', 'セン'=> '0.01', '<s>' => '0', 'コ' => '0.01', 'コル' => '0.01', 'トラル' => '0.01', 'セット' => '0.01', '</s>' => '1', 'コス' => '0.01', 'ティック' => '0.01', 'メ' => '0.01'},
# 's_ax_t' => {'サイン'=> '0.01', 'セン'=> '0.01', '<s>' => '0', 'コ' => '0.01', 'コル' => '0.01', 'トラル' => '0.01', 'セット' => '0.9', '</s>' => '0', 'コス' => '0.01', 'ティック' => '0.01', 'メ' => '0.01'},
# '<s>' => {'サイン'=> '0.01', 'セン'=> '0.01', '<s>' => '0.9', 'コ' => '0.01', 'コル' => '0.01', 'トラル' => '0.01', 'セット' => '0.01', '</s>' => '0', 'コス' => '0.01', 'ティック' => '0.01', 'メ' => '0.01'}
#};
