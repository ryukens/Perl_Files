use warnings;
use strict;
use utf8;
use Encode qw/encode decode/;
use Config;
binmode STDOUT, ":utf8";
binmode STDERR, ":utf8";
use 5.28.1;

my $file_in = '..\Documentos\results_final.txt';
my $file_out = '..\Documentos\diccionario_emision.txt';
my $file_out2 = '..\Documentos\diccionario_alineacion.txt';
my $linea;
my @array_jp;

open(FH, '<', $file_in) or die $!;
open(FHO, '+>', $file_out) or die $!;
open(FHO2, '+>', $file_out2) or die $!;

while (<FH>) {
    #$linea = $_;
    $linea = decode("utf-8", $_);
    given($linea){        
        when($linea =~ /[|]/){
            
            $linea =~ s/^NULL \(\{[\s\d]*\}\)//;
            
            my @linea_og = split(/\|+ /, $linea, length($linea));
            
            foreach my $palabra (@linea_og){
                $palabra =~ s/^(\(\{([\s\d]*)\}\))//;
                print "palabra: $palabra \n";
                &union($palabra,\@array_jp);
            }
        }
        when($linea =~ /NULL/ && $linea !~ /[|]/){
            print "LIST\n";
            $linea =~ s/^NULL \(\{[\s\d]*\}\)//;
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
close(FHO2);


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
    my $katakana_oculto;
    my @array_kat_oculto;
    
    print "\nLINEA\n";
    print $linea_og;
    print "\nKATAKANAS\n";
    print @array_katakana;
        
    #$linea_og =~ s/^NULL \(\{[\s\d]*\}\)//;
    #$linea_og =~ s/\|\s(\(\{([\s\d]*)\}\))//;
    
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
        push (@array_kat_oculto, $secuencia_katakana);
        #MODELO OBSERVABLE
        $fonema_katakana = "<s> $fonema $secuencia_katakana </s>\n";
        print "\nSALIDA OBSERVABLE: $fonema_katakana\n";
        print FHO $fonema_katakana;
        
    }
    #MODELO OCULTO
    $katakana_oculto = "<s>";
    foreach my $secuencia_oculta (@array_kat_oculto){
        $katakana_oculto = "$katakana_oculto ".$secuencia_oculta;
    }
    $katakana_oculto = "$katakana_oculto </s>\n";
    print "\nSALIDA OCULTO: $katakana_oculto\n";
    print FHO2 $katakana_oculto;
}