#use Algorithm::Viterbi;
#use Algorithm::ViterbiV2;
#use Algorithm::ViterbiLog;
use Algorithm::ViterbiLogV2;
use Data::Dumper;
use strict;
use 5.28.1;

 
#my $start_probability = { 'Healthy'=> 0.6, 'Fever'=> 0.4 };
# 
#my $transition_probability = {
# 'Healthy' => {'Healthy'=> 0.7, 'Fever'=> 0.3},
# 'Fever' => {'Healthy'=> 0.4, 'Fever'=> 0.6},
#};
# 
#my $emission_probability = {
#  'dizzy' =>  { 'Fever' => '0.6', 'Healthy' => '0.1' },
#  'cold' =>  { 'Fever' => '0.3', 'Healthy' => '0.4' },
#  'normal' => { 'Fever' => '0.1', 'Healthy' => '0.5' }
#};

my $start_probability = { 'Healthy'=> -0.2218, 'Fever'=> -0.3979 };
 
my $transition_probability = {
 'Healthy' => {'Healthy'=> -0.1549, 'Fever'=> -0.5228},
 'Fever' => {'Healthy'=> -0.3979, 'Fever'=> -0.2218},
};
 
my $emission_probability = {
  'dizzy' =>  { 'Fever' => '-0.2218', 'Healthy' => '-1' },
  'cold' =>  { 'Fever' => '-0.5228', 'Healthy' => '-0.3979' },
  'normal' => { 'Fever' => '-1', 'Healthy' => '-0.3010' }
};

 
my $v = Algorithm::Viterbi->new();
$v->start($start_probability);
$v->transition($transition_probability);
$v->emission($emission_probability);
 
my $observations = [ 'normal', 'cold', 'dizzy' ];
 
#my ($prob, $v_path, $v_prob) = $v->forward_viterbi($observations);

#print Dumper ($v->forward_viterbi($observations));

my ($prob_max, @path) = $v->forward_viterbi($observations);

print "\nPROB_MAX: $prob_max\n";
foreach my $answer (@path){
    print "$answer ";    
}



