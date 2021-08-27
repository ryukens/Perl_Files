use warnings;
use strict;
use 5.28.1;

my $file_in = '..\Documentos\results_final.txt';
my $file_out = '..\Documentos\modelo_observable.txt';
my $linea;
my @array_jp;

open(FH, '<', $file_in) or die $!;
open(FHO, '+>', $file_out) or die $!;

while (<FH>) {
    $linea = $_;
    given($linea){        
        when($linea =~ /NULL/){
            &union($linea,\@array_jp);
        }
        when ($linea !~ /[0-9]/){
            #print "secuencia katakana:\n";
            @array_jp = split(/\s/,$linea);
            #foreach my $kat (@array_jp){
            #    print "kat: $kat\n";
            #}
            #print @array_jp;
            #print "\n";
        }
        default {}
    }    
}


close(FH);
close(FHO);


# FUNCIONES

sub union {
    print "\n::::::::::::::INICIO::::::::::::::::::::\n";
    my $linea_og = $_[0];
    my @array_katakana = @{$_[1]};
    my $fonema_con_indices;
    my @array_phoneme;
    my @array_indices;
    my $indices;
    my $indice_katakana;
    my $fonema;
    my $fonema_katakana;
    
    print "\nLINEA\n";
    print $linea_og;
    print "\nKATAKANAS\n";
    print @array_katakana;
        
    $linea_og =~ s/^NULL \(\{[\s\d]*\}\)//;
    $linea_og =~ s/\|\s(\(\{([\s\d]*)\}\))//;
    
    while ($linea_og =~ /(`?\w*\s\(\{[\s\d]*\}\))/g) {
        push (@array_phoneme, $1);
    }
    
    foreach $fonema_con_indices (@array_phoneme){
        $indices = $fonema_con_indices;
        $indices =~ s/[^0-9]//g;
        @array_indices = split('', $indices, length($indices));
        print "\nValor: $fonema_con_indices\n";
        print "Indices: ";
        print @array_indices;
        print "\n";
        while ($fonema_con_indices =~ /([^\s\(\)\{\}\[\]\|\d(NULL)]+)/g) {
            $fonema = $1;
        }
        print "Fonema: $fonema \n";
        my $secuencia_katakana = '';
        foreach $indice_katakana (@array_indices){
            print "Katakana: ";
            print $array_katakana[$indice_katakana-1];
            print "\n";
            $secuencia_katakana = "$secuencia_katakana".$array_katakana[$indice_katakana-1];
            print "Secuencia_katakana: $secuencia_katakana\n";
        }
        $fonema_katakana = "$fonema $secuencia_katakana\n";
        print "\nSALIDA: $fonema_katakana\n";
        print FHO $fonema_katakana;              
    }            
}