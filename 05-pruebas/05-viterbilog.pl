use Algorithm::ViterbiLog;
use Data::Dumper;
use strict;
use 5.28.1;

 
my $start_probability = { 'Rainy'=> -0.2076, 'Sunny'=> -0.4202 };
 
my $transition_probability = {
 'Rainy' => {'Rainy'=> -0.1549, 'Sunny'=> -0.5228},
 'Sunny' => {'Rainy'=> -0.3979, 'Sunny'=> -0.2218},
};
 
my $emission_probability = {
  'shop' =>  { 'Sunny' => '-0.6197', 'Rainy' => '-0.3872' },
  'walk' =>  { 'Sunny' => '-0.1870', 'Rainy' => '-1.0457' },
  'clean' => { 'Sunny' => '-1', 'Rainy' => '-0.3010' }
};
 
my $v = Algorithm::Viterbi->new();
$v->start($start_probability);
$v->transition($transition_probability);
$v->emission($emission_probability);
 
my $observations = [ 'walk', 'shop', 'clean' ];
 
#my ($prob, $v_path, $v_prob) = $v->forward_viterbi($observations);

print Dumper ($v->forward_viterbi($observations));



