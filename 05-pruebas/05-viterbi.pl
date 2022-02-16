use Algorithm::Viterbi;
use Data::Dumper;
use strict;
use 5.28.1;

 
my $start_probability = { 'Rainy'=> 0.62, 'Sunny'=> 0.38 };
 
my $transition_probability = {
 'Rainy' => {'Rainy'=> 0.7, 'Sunny'=> 0.3},
 'Sunny' => {'Rainy'=> 0.4, 'Sunny'=> 0.6},
};
 
my $emission_probability = {
  'shop' =>  { 'Sunny' => '0.24', 'Rainy' => '0.41' },
  'walk' =>  { 'Sunny' => '0.65', 'Rainy' => '0.09' },
  'clean' => { 'Sunny' => '0.1', 'Rainy' => '0.5' }
};
 
my $v = Algorithm::Viterbi->new();
$v->start($start_probability);
$v->transition($transition_probability);
$v->emission($emission_probability);
 
my $observations = [ 'walk', 'shop', 'clean' ];
 
#my ($prob, $v_path, $v_prob) = $v->forward_viterbi($observations);

print Dumper ($v->forward_viterbi($observations));



