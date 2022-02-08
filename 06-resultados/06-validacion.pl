use warnings;
no warnings 'utf8';
no warnings 'experimental';
use strict;
use utf8;
use Encode qw/encode decode/;
use Config;
binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";
use 5.28.1;

#my $file_obs = '..\Documentos\pruebas\testeo.txt';
my $file_obs = '..\Documentos\pruebas\Fonemas_Entrenamiento.txt';
my $file_sal = '..\Documentos\pruebas\salida.txt';
my $linea;


open(FHO, '<', $file_obs) or die $!;
open(FHS, '<', $file_sal) or die $!;

while (<FHO>) {
    
}


close(FHO);
close(FHS);