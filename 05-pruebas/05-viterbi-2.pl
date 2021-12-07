use Algorithm::Viterbi;
use Data::Dumper;
use strict;
use 5.28.1;

my $emission = {
  'shop' => {
              'Sunny' => '0.3',
              'Rainy' => '0.4'
            },
  'swim' => {
              'Sunny' => '0.1'
            },
  'walk' => {
              'Sunny' => '0.5',
              'Rainy' => '0.1'
            },
  'clean' => {
               'Sunny' => '0.1',
               'Rainy' => '0.5'
             }
};
 
my $start = { 'Rainy'=> 0.6, 'Sunny'=> 0.4 };
 
my $v = Algorithm::Viterbi->new();
$v->emission($emission);
$v->start($start);
my $e;
$e = $v -> get_emission('shop', 'Rainy'); # $e = 0.4
print "e: $e \n";
$e = $v -> get_emission('swim', 'Rainy'); # $e = 0
$e = $v -> get_emission('hack', 'Rainy'); # $e = 0.6
$v->{unknown_emission_prob} = 1;
$e = $v -> get_emission('hack', 'Rainy'); # $e = 1

#my $observations = [
#  [ 'work', 'rainy' ],
#  [ 'work', 'sunny' ],
#  [ 'walk', 'sunny' ],
#  [ 'walk', 'rainy' ],
#  [ 'shop', 'rainy' ],
#  [ 'work', 'rainy' ],
#];
# 
#my $v = Algorithm::Viterbi->new(start_state => '###');
#$v->train($observations);
# 
#print Dumper($v);