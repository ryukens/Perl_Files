use Algorithm::ViterbiV2;
use Data::Dumper;
use strict;
use 5.28.1;

 
my $start_probability = { 'H'=> 0, 'C'=> 1.0 };
 
my $transition_probability = {
 'H' => {'H'=> 0.7, 'C'=> 0.3},
 'C' => {'H'=> 0.4, 'C'=> 0.6},
};
 
my $emission_probability = {
  'S' =>  { 'C' => '0.7', 'H' => '0.1' },
  'M' =>  { 'C' => '0.2', 'H' => '0.4' },
  'L' => { 'C' => '0.1', 'H' => '0.5' }
};
 
my $v = Algorithm::Viterbi->new();
$v->start($start_probability);
$v->transition($transition_probability);
$v->emission($emission_probability);
 
my $observations = [ 'M', 'S', 'L' ];
 
#my ($prob, $v_path, $v_prob) = $v->forward_viterbi($observations);

#print Dumper ($v->forward_viterbi($observations));

my ($prob_max, @path) = $v->forward_viterbi($observations);

print "\nPROB_MAX: $prob_max\n";
foreach my $answer (@path){
    print "$answer ";    
}



