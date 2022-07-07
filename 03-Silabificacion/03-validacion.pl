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

#my $file_in = '..\Documentos\results_test.txt';
my $file_in = '..\Documentos\results_final.txt';
my $file_emi = '..\Documentos\diccionario_emision.txt';
my $file_tran = '..\Documentos\diccionario_transicion.txt';
my $file_no_val = '..\Documentos\palabras_no_validas.txt';
my $file_fon_no_val = '..\Documentos\pruebas\entrenamiento_fonemas_no_validos.txt';
my $linea;
my @array_jp;
my %diccionario_emision;
my @diccionario_transicion;
my $contador = 0;

open(FH, '<', $file_in) or die $!;
open(FHO, '+>', $file_emi) or die $!;
open(FHO2, '+>', $file_tran) or die $!;
open(FHO3, '+>', $file_no_val) or die $!;
open(FHO4, '+>', $file_fon_no_val) or die $!;

while (<FH>) {
    $linea = decode("utf-8", $_);
    chomp($linea);
    given($linea){        
        when($linea =~ /[|]/){
            
            $linea =~ s/^NULL \(\{[\s\d]*\}\)//;
            
            my @linea_og = split(/\|+ /, $linea, length($linea));
            
            foreach my $palabra (@linea_og){
                $palabra =~ s/^(\(\{([\s\d]*)\}\))//;
                #print "palabra: $palabra \n";
                &union($palabra,\@array_jp);
            }
            #print ">>>>>>>>>>>>>>>>>>>> VALIDACION >>>><<<<<<<<<<<>\n";
            &validacion;
        }
        when($linea =~ /NULL/ && $linea !~ /[|]/){
            #print "LIST\n";
            $linea =~ s/^NULL \(\{[\s\d]*\}\)//;
            &union($linea,\@array_jp);
            #print ">>>>>>>>>>>>>>>>>>>> VALIDACION >>>><<<<<<<<<<<>\n";
            &validacion;
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
close(FHO3);
close(FHO4);


# FUNCIONES

sub union {
    #print "\n::::::::::::::INICIO::::::::::::::::::::\n";
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
    
    #print "\nLINEA\n";
    #print $linea_og;
    #print "\nKATAKANAS\n";
    #print @array_katakana;
    
    while ($linea_og =~ /((\w*~?`?)*[\w -]*\(\{[ \d]*\}\))/g) {
        push (@array_phoneme, $1);
    }
    
    foreach $fonema_con_indices (@array_phoneme){
        $indices = $fonema_con_indices;
        $indices =~ s/[^0-9]//g;
        @array_indices = split('', $indices, length($indices));
        #print "\nValor: $fonema_con_indices\n";
        #print "Indices: ";
        #print @array_indices;
        #print "\n";
        while ($fonema_con_indices =~ /([^\s\(\)\{\}\[\]\|\d(NULL)]+)/g) {
            $fonema = $1;
        }
        #print "Fonema: $fonema \n";
        my $secuencia_katakana = '';
        foreach $indice_katakana (@array_indices){
            #print "Katakana: ";
            #print $array_katakana[$indice_katakana-1];
            #print "\n";
            $secuencia_katakana = "$secuencia_katakana".$array_katakana[$indice_katakana-1];
            #print "Secuencia_katakana: $secuencia_katakana\n";
        }
        push (@array_kat_oculto, $secuencia_katakana);
        
        #DICCIONARIO EMISION
        $fonema_katakana = "<s> $fonema $secuencia_katakana </s>\n";
        $diccionario_emision{$contador}{$fonema} = $secuencia_katakana;
        #print "\nSALIDA EMISION: $fonema_katakana\n";
        #print "SA: $fonema $contador $diccionario_emision{$contador}{$fonema}";
        $contador++;
        #print FHO $fonema_katakana;
        
    }
    
    #DICCIONARIO TRANSICION
    $katakana_oculto = "<s>";
    foreach my $secuencia_oculta (@array_kat_oculto){
        $katakana_oculto = "$katakana_oculto ".$secuencia_oculta;
    }
    $katakana_oculto = "$katakana_oculto </s>\n";
    #print "\nSALIDA TRANSICION: $katakana_oculto\n";
    push (@diccionario_transicion, $katakana_oculto);
    #print FHO2 $katakana_oculto;
}

sub validacion {
    my @flag;
    foreach my $cont (sort keys %diccionario_emision) {
        foreach my $en_syl_phoneme (keys %{$diccionario_emision{$cont}}) {
            my $sec_katakana = $diccionario_emision{$cont}{$en_syl_phoneme};
            #print "$en_syl_phoneme -> $sec_katakana\n";
            my $correcto = 0;
            if ($sec_katakana ne "") {
                if($en_syl_phoneme =~ /`?[aery]\w*/ && $sec_katakana =~ /(ア|ヤ)/){
                    #print "ENCONTRADO: 1 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?[iy]|ax\w*/ && $sec_katakana =~ /イ/){
                    #print "ENCONTRADO: 2 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?[auvw]\w*/ && $sec_katakana =~ /ウ/){
                    #print "ENCONTRADO: 3 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?[aeiy]\w*/ && $sec_katakana =~ /エ/){
                    #print "ENCONTRADO: 4 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?[aow]\w*/ && $sec_katakana =~ /オ/){
                    #print "ENCONTRADO: 5 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?[bv]\w*/ && $sec_katakana =~ /(バ|ビ|ブ|ベ|ボ)/){
                    #print "ENCONTRADO: 6 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?d\w*/ && $sec_katakana =~ /(ダ|ヂ|ヅ|デ|ド)/){
                    #print "ENCONTRADO: 7 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?[gj]\w*/ && $sec_katakana =~ /(ガ|ギ|グ|ゲ|ゴ)/){
                    #print "ENCONTRADO: 8 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?[fh]\w*/ && $sec_katakana =~ /フ/){
                    #print "ENCONTRADO: 9 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?([fh]|ch)\w*/ && $sec_katakana =~ /(ハ|ヘ)/){
                    #print "ENCONTRADO: 10 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?[fhak]\w*/ && $sec_katakana =~ /ヒ/){
                    #print "ENCONTRADO: 11 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?[fhw]\w*/ && $sec_katakana =~ /ホ/){
                    #print "ENCONTRADO: 12 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?k\w*/ && $sec_katakana =~ /(カ|キ|ク|ケ|コ)/){
                    #print "ENCONTRADO: 13 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?m\w*/ && $sec_katakana =~ /(マ|ミ|ム|メ|モ)/){
                    #print "ENCONTRADO: 14 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?n\w*/ && $sec_katakana =~ /(ナ|ニ|ヌ|ネ|ノ)/){
                    #print "ENCONTRADO: 15 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?(ng?|m)\w*/ && $sec_katakana =~ /ン/){
                    #print "ENCONTRADO: 16 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?p\w*/ && $sec_katakana =~ /(パ|ピ|プ|ペ|ポ)/){
                    #print "ENCONTRADO: 17 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?[rl]\w*/ && $sec_katakana =~ /(ラ|リ|ル|レ|ロ)/){
                    #print "ENCONTRADO: 18 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?([sz]|th)\w*/ && $sec_katakana =~ /(サ|ス)/){
                    #print "ENCONTRADO: 19 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?([szy]|th)\w*/ && $sec_katakana =~ /シ/){
                    #print "ENCONTRADO: 20 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?(s|th)\w*/ && $sec_katakana =~ /(セ|ソ)/){
                    #print "ENCONTRADO: 21 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?t\w*/ && $sec_katakana =~ /(ツ|テ|ト)/){
                    #print "ENCONTRADO: 22 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?[td]\w*/ && $sec_katakana =~ /タ/){
                    #print "ENCONTRADO: 23 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?([tz]|ch)\w*/ && $sec_katakana =~ /チ/){
                    #print "ENCONTRADO: 24 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?([wv]|er)\w*/ && $sec_katakana =~ /(ワ|ヲ)/){
                    #print "ENCONTRADO: 25 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?(y|jh)\w*/ && $sec_katakana =~ /(ユ|ヨ)/){
                    #print "ENCONTRADO: 26 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?([zsd])\w*/ && $sec_katakana =~ /ザ/){
                    #print "ENCONTRADO: 27 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?z\w*/ && $sec_katakana =~ /(ズ|ゾ)/){
                    #print "ENCONTRADO: 28 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?([zs]|jh)\w*/ && $sec_katakana =~ /ゼ/){
                    #print "ENCONTRADO: 29 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?([dsz]|jh)\w*/ && $sec_katakana =~ /ジ/){
                    #print "ENCONTRADO: 30 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /^`?jh\w*/ && $sec_katakana =~ /(ゼ|ゲ|ガ)/){
                    #print "ENCONTRADO: 31 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
                if($en_syl_phoneme =~ /`?(n_ay)|(n_ax)/ && $sec_katakana =~ /^ナイ/){
                    #print "ENCONTRADO: 32 ".$en_syl_phoneme."\n";
                    $correcto++;
                    push (@flag, 1);
                }
            }else{
                #print "VACIO: ".$en_syl_phoneme."\n";
                push (@flag, 0);
            }
            if ($correcto == 0) {
                #print "INCORRECTO: ".$en_syl_phoneme."\n";
                push (@flag, 0);
            }
            
        }
    }
    #print "FLAG: \n";
    #print @flag;
    if (grep(/0/, @flag)) {
        my $fonema_no_valido = "<s>";
        foreach my $cont (sort keys %diccionario_emision) {
            foreach my $en_syl_phoneme (keys %{$diccionario_emision{$cont}}) {
                my $sec_katakana = $diccionario_emision{$cont}{$en_syl_phoneme};
                my $fonema_katakana = "<s> $en_syl_phoneme $sec_katakana </s>\n";
                $fonema_no_valido = "$fonema_no_valido $en_syl_phoneme";
                print FHO3 $fonema_katakana;
            }
        }
        #print FHO3 ">>>>>>>>>>>>>>>>KATAKANA<<<<<<<<<<<<<<<<\n";
        #foreach my $k (@diccionario_transicion){
        #    print FHO3 $k;    
        #}
        #print FHO3 "----------------------------------------\n\n";
        $fonema_no_valido = "$fonema_no_valido </s>\n";
        print FHO4 $fonema_no_valido;
    }else{
        foreach my $cont (sort keys %diccionario_emision) {
            foreach my $en_syl_phoneme (keys %{$diccionario_emision{$cont}}) {
                my $sec_katakana = $diccionario_emision{$cont}{$en_syl_phoneme};
                my $fonema_katakana = "<s> $en_syl_phoneme $sec_katakana </s>\n";
                print FHO $fonema_katakana;
            }
        }
        foreach my $k (@diccionario_transicion){
            print FHO2 $k;    
        }
    }
    
    %diccionario_emision = ();
    @flag = ();
    @diccionario_transicion = ();
    
    
}


