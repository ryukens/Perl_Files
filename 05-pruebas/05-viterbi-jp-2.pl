use Algorithm::Viterbi;
use Data::Dumper;
use strict;
use 5.28.1;
 
my $start_probability = { 'セン'=> 0.01, '<s>' => 0.9, 'トラル' => 0.01, '</s>' => 0.01};

my $transition_probability = {
 '</s>' => {'セン'=> 0, '<s>' => 0, 'トラル' => 0, '</s>' => 1},
 'トラル' => {'セン'=> 0.01, '<s>' => 0, 'トラル' => 0.01, '</s>' => 0.9},
 'セン' => {'セン'=> 0.01, '<s>' => 0, 'トラル' => 0.9, '</s>' => 0.01},
 '<s>' => {'セン'=> 0.99, '<s>' => 0, 'トラル' => 0.01, '</s>' => 0}
};

my $emission_probability = {
 '</s>' => {'セン'=> '0.01', '<s>' => '0', 'トラル' => '0.01', '</s>' => '0.97'}, 
 '`s_eh_n' => {'セン'=> '0.97', '<s>' => '0', 'トラル' => '0.01', '</s>' => '0.01'},
 't_r_ax_l' => { 'セン' => '0.01', '<s>' => '0', 'トラル' => '0.97', '</s>' => '0.01'},
 '<s>' => {'セン'=> '0.01', '<s>' => '0.97', 'トラル' => '0.01', '</s>' => '0.01'} 
};


my $v = Algorithm::Viterbi->new();
$v->start($start_probability);
$v->transition($transition_probability);
$v->emission($emission_probability);
 
my $observations = [ '<s>', '`s_eh_n', 't_r_ax_l', '</s>' ];

print Dumper ($v->forward_viterbi($observations));
