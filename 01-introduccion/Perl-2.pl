use warnings;
use strict;

my $filename = 'C:\Users\jjmor\Downloads\EPWING Dictionaries\01-Guia.txt';

#my $filename = 'C:\Users\jjmor\Downloads\EPWING Dictionaries\02-Katakana\ハイブリッド新辞林\ハイブリッド新辞林\HBSJRN98\DATA\HONMON.ebz';

#my $filename = 'C:\Users\jjmor\Downloads\EPWING Dictionaries\02-Katakana\ハイブリッド新辞林\ハイブリッド新辞林\HBSJRN98\DATA\HONMON.ebz';

#my $filename = 'C:\Users\jjmor\Downloads\EPWING Dictionaries\HONMON.ebz';

#my $filename = 'C:\Users\jjmor\Downloads\EPWING Dictionaries\CATALOGS';

open(FH, '<', $filename) or die $!;

while (<FH>) {
    print $_;
}

close(FH);


