use warnings;
use strict;
use 5.28.1;

my $filename = '..\Documentos\words_list.txt';
my $filename2 = '..\Documentos\words_list_3.txt';
my $linea;
my $palabra;
my $tipo;
my $posicion;
my $tamano;
my $final;
my @token;
my @token2;

open(FH, '<', $filename) or die $!;
open(FHO, '+>', $filename2) or die $!;

while (<FH>) {
    $linea = $_;
    @token = split(/\t/,$linea);
    $tipo = $token[3];
    $palabra = $token[2];
    @token2 = split(/-/,$palabra);
    $tamano = scalar @token2;
    
    if ($palabra =~ /[áéíóú]/) {
        $palabra =~ tr/[áéíóú]/[ÁÉÍÓÚ]/;
        $palabra =~ tr/-/ /;
        print FHO $palabra."\n";
    } else {
        given($tipo){
            when('única') {$posicion = 0;}
            when('primera') {$posicion = 0;}
            when('segunda') {$posicion = 1;}
            when('dos') {$posicion = 1;}
            when('tercera') {$posicion = 2;}
            when('cuarta') {$posicion = 3;}
            when('última') {$posicion = ($tamano - 1);}
            when('penúltima') {$posicion = ($tamano - 2);}
            when('antepenúltima') {$posicion = ($tamano - 3);}
            default{print "no fue posible";}
        }
        
        if ($token2[$posicion] =~ /[aeiou]/) {
            $token2[$posicion] =~ tr/[aeiou]/[AEIOU]/;
        }
        
        for (my $n=0; $n<$tamano; $n++) {
            if ($n > 0) {
                $final = $final." ".$token2[$n];
            } else {    
                $final = $token2[0];
            }
        }
        
        print FHO $final."\n";
    }
}

close(FH);  
close(FHO);