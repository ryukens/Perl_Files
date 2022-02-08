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

my $file_in = '..\Documentos\results.txt';
#my $file_in = '..\Documentos\results_test.txt';
my $file_out = '..\Documentos\results_final.txt';
my $linea;
my $string;
my $orden;
my @orden_og;
my @orden_sort;
my $tamano;
my @array_og;
my @array_jp;


open(FH, '<', $file_in) or die $!;
open(FHO, '+>', $file_out) or die $!;

while (<FH>) {
    $linea = decode("utf-8", $_);
    $orden = $linea;
    given($linea){
        when($linea =~ /[|]/){
            print "palabra multiple\n";
            print $linea;
            $string = $linea;
            my $valor;
            my $inicio = '';
            
            my @linea_og = split(/\|+ /, $string, length($string));
            my $cont = 0;
            
            foreach my $palabra (@linea_og){
                #print "palabra: $palabra \n";
                while ($palabra =~ /NULL (\(\{([\s\d]*)\}\))/g) {
                    $valor = $1;
                }
                while ($palabra =~ /^(\(\{([\s\d]*)\}\))/g) {
                    $valor = $1;
                }
                if($palabra =~ /- \(\{ (\d+ )+\}\)/) {
                    my $caracter_especial;
                    while ($palabra =~ /(- \(\{ (\d+ )+\}\))/g) {
                        $caracter_especial = $1;
                    }
                    my @indices_esp = $caracter_especial =~ /(\d+)/g;                
                    my @indices_val = $valor =~ /(\d+)/g;                
                    my @indices_total = ();
                    push (@indices_total, @indices_esp);
                    push (@indices_total, @indices_val);                
                    my @orden_sort = sort {$a <=> $b} @indices_total;
                    $valor = "({ @orden_sort })";                
                }
                my $resto = &reemplazo($valor,$palabra,\@array_jp);
                if ($cont == 0) {
                    $inicio = $resto;
                }else{
                    $inicio = $inicio."| ".$resto;
                }                    
                $cont = $cont+1;
            }
            $linea = $inicio;
            
            print "LINEA FINAL: $linea \n";
            print FHO $linea;
            
            print "+++++++++++++++++ORDENADO++++++++++++++++++\n";
        }
        
        when($linea =~ /NULL/ && $linea !~ /[|]/){
            print "palabra simple\n";
            print $linea;
            $string = $linea;           
            
            my $valor;
            while ($string =~ /NULL (\(\{([\s\d]*)\}\))/g) {
                $valor = $1;
            }
            
            if($string =~ /- \(\{ (\d+ )+\}\)/) {
                my $caracter_especial;
                while ($string =~ /(- \(\{ (\d+ )+\}\))/g) {
                    $caracter_especial = $1;
                }
                my @indices_esp = $caracter_especial =~ /(\d+)/g;                
                my @indices_val = $valor =~ /(\d+)/g;                
                my @indices_total = ();
                push (@indices_total, @indices_esp);
                push (@indices_total, @indices_val);                
                my @orden_sort = sort {$a <=> $b} @indices_total;
                $valor = "({ @orden_sort })";                
            }
            
            $linea = &reemplazo($valor,$linea,\@array_jp);
            
            print "LINEA FINAL: $linea \n";
            print FHO $linea;
            
            print "----------------ORDENADO----------------------\n";
            
        }
        when ($linea !~ /[0-9]/){
            #print "palabra japonesa:\n";
            @array_jp = split(/\s/,$linea);
            #print @array_jp;
            #print "\n";
            #foreach my $katakana (@array_jp) {print $katakana."\n"};
            #print "ooooooooooooooooooooooooooo\n";
            print FHO $linea;
        }
        default {print FHO $linea;}
    }    
}


close(FH);
close(FHO);


# FUNCIONES

sub reemplazo {
    print "::::::::::::::INICIO::::::::::::::::::::\n";
    my $indice = $_[0];
    my $linea_og = $_[1];
    my @array_katakana = @{$_[2]};
    my $tamano = scalar @array_katakana;
    my $en_syl_phoneme;
    my @array_en_phoneme;
    my @array_indices;
    my $flag = 0;
    my $orden = $linea_og;
    
    print "INDICES POR ORDENAR\n";
    print $indice;
    print "\nLINEA\n";
    print $linea_og;
    print "\nKATAKANAS\n";
    print @array_katakana;
    
    print "\n::::::::::::::BUSQUEDA::::::::::::::::::::\n";  
    
    while ($linea_og =~ /([^\s\(\)\{\}\[\]\|\d(NULL)]+)/g) {
        push (@array_en_phoneme, $1);
    }

    #$orden =~ s/[^\d+]//g;
    #print "ORDEN: $orden \n";
    #my @orden_actual = split('', $orden, length($orden));
    my @orden_actual = $orden =~ /(\d+)/g;
    my @orden_sort = sort {$a <=> $b} @orden_actual;
        
    foreach my $k (@orden_actual){
        print "OA: $k \n";
    }    
    
    $linea_og =~ s/^NULL \(\{[\s\d]*\}\)/NULL \(\{ \}\)/;
    $linea_og =~ s/^(\(\{([\s\d]*)\}\))/\(\{ \}\)/;
    $linea_og =~ s/- \(\{ (\d+ )+\}\) //;
    $linea_og =~ s/- \(\{ \}\) //;
    
    #@array_indices = split('', $indice, length($indice));
    @array_indices = $indice =~ /(\d+)/g;
    $indice =~ s/[^\d]//g;
    
    foreach my $k (@array_indices){
        print "AI: $k \n";
    }    
    
    if (@orden_actual ~~ @orden_sort && @array_indices == 0) {
        print "\n1 NO QUEDAN INDICES POR ORDENAR\n";
        return $linea_og;
    }
    
    foreach my $i (@array_indices){        
        foreach $en_syl_phoneme (@array_en_phoneme) {
            print "Phonema EN = ".$en_syl_phoneme."\n";
            print "Phonema JP = ".$array_katakana[$i-1]."\n";            
            #REGLAS GENERALIZADAS
            if($en_syl_phoneme =~ /`?[aery]\w*/ && $array_katakana[$i-1] =~ /^(ア|ヤ)/){
                print "ENCONTRADO: 1 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?[iy]|ax\w*/ && $array_katakana[$i-1] =~ /^イ/){
                print "ENCONTRADO: 2 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?[auvw]\w*/ && $array_katakana[$i-1] =~ /^ウ/){
                print "ENCONTRADO: 3 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?[aeiy]\w*/ && $array_katakana[$i-1] =~ /^エ/){
                print "ENCONTRADO: 4 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?[aow]\w*/ && $array_katakana[$i-1] =~ /^オ/){
                print "ENCONTRADO: 5 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?[bv]\w*/ && $array_katakana[$i-1] =~ /^(バ|ビ|ブ|ベ|ボ)/){
                print "ENCONTRADO: 6 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?d\w*/ && $array_katakana[$i-1] =~ /^(ダ|ヂ|ヅ|デ|ド)/){
                print "ENCONTRADO: 7 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?g\w*/ && $array_katakana[$i-1] =~ /^(ガ|ギ|グ|ゲ|ゴ)/){
                print "ENCONTRADO: 8 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?[fh]\w*/ && $array_katakana[$i-1] =~ /^フ/){
                print "ENCONTRADO: 9 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?([fh]|ch)\w*/ && $array_katakana[$i-1] =~ /^(ハ|ヘ)/){
                print "ENCONTRADO: 10 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?[fhak]\w*/ && $array_katakana[$i-1] =~ /^ヒ/){
                print "ENCONTRADO: 11 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?[fhw]\w*/ && $array_katakana[$i-1] =~ /^ホ/){
                print "ENCONTRADO: 12 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?k\w*/ && $array_katakana[$i-1] =~ /^(カ|キ|ク|ケ|コ)/){
                print "ENCONTRADO: 13 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?m\w*/ && $array_katakana[$i-1] =~ /^(マ|ミ|ム|メ|モ)/){
                print "ENCONTRADO: 14 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?n\w*/ && $array_katakana[$i-1] =~ /^(ナ|ニ|ヌ|ネ|ノ)/){
                print "ENCONTRADO: 15 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?(ng?|m)\w*/ && $array_katakana[$i-1] =~ /^ン/){
                print "ENCONTRADO: 16 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?p\w*/ && $array_katakana[$i-1] =~ /^(パ|ピ|プ|ペ|ポ)/){
                print "ENCONTRADO: 17 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?[rl]\w*/ && $array_katakana[$i-1] =~ /^(ラ|リ|ル|レ|ロ)/){
                print "ENCONTRADO: 18 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?([sz]|th)\w*/ && $array_katakana[$i-1] =~ /^(サ|ス)/){
                print "ENCONTRADO: 19 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?([szy]|th)\w*/ && $array_katakana[$i-1] =~ /^シ/){
                print "ENCONTRADO: 20 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?(s|th)\w*/ && $array_katakana[$i-1] =~ /^(セ|ソ)/){
                print "ENCONTRADO: 21 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?t\w*/ && $array_katakana[$i-1] =~ /^(ツ|テ|ト)/){
                print "ENCONTRADO: 22 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?[td]\w*/ && $array_katakana[$i-1] =~ /^タ/){
                print "ENCONTRADO: 23 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?([tz]|ch)\w*/ && $array_katakana[$i-1] =~ /^チ/){
                print "ENCONTRADO: 24 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?([wv]|er)\w*/ && $array_katakana[$i-1] =~ /^(ワ|ヲ)/){
                print "ENCONTRADO: 25 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?(y|jh)\w*/ && $array_katakana[$i-1] =~ /^(ユ|ヨ)/){
                print "ENCONTRADO: 26 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?([zsd])\w*/ && $array_katakana[$i-1] =~ /^ザ/){
                print "ENCONTRADO: 27 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?z\w*/ && $array_katakana[$i-1] =~ /^(ズ|ゾ)/){
                print "ENCONTRADO: 28 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?([zs]|jh)\w*/ && $array_katakana[$i-1] =~ /^ゼ/){
                print "ENCONTRADO: 29 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?([dsz]|jh)\w*/ && $array_katakana[$i-1] =~ /^ジ/){
                print "ENCONTRADO: 30 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /^`?jh\w*/ && $array_katakana[$i-1] =~ /^(ゼ|ゲ|ガ)/){
                print "ENCONTRADO: 31 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            if($en_syl_phoneme =~ /`?(n_ay)|(n_ax)/ && $array_katakana[$i-1] =~ /^ナイ/){
                print "ENCONTRADO: 32 ".$en_syl_phoneme."\n";
                $flag = $i;
            }
            @orden_actual = $orden =~ /(\d+)/g;
            #$orden =~ s/[^0-9]//g;           
            #@orden_actual = split('', $orden, length($orden));
            
            print @orden_actual;
            print "\n";
            print @orden_sort;
            print "\n";
            print "FLAG = $flag INDICE: $indice\n";
                             
            if (@orden_actual ~~ @orden_sort && $indice eq "") {
                print "\n2 NO QUEDAN INDICES POR ORDENAR\n";
                return $linea_og;
            }else{
                if ( grep(/$flag/, @array_indices)) {
                $linea_og = &ordenar($linea_og, $en_syl_phoneme, $flag, \@array_en_phoneme, \@orden_sort);
                $orden = $linea_og;
                print "*$orden*";
                print "FONEMA ALINEADO\n";
                }
                $flag = 0;
                $indice = "";
                print "\n";
            }
            print ":::::::::::::FIN FOR EACH:::::::::::::::::\n";
        };   
    }
    print "::::::::::::::FINAL::::::::::::::::::::\n";
    return ($linea_og);         
}


sub ordenar {
    my $linea_og = $_[0];
    my $en_syl_phoneme = $_[1];
    my $posicion = $_[2];
    my @array_en_phoneme = @{$_[3]};
    my @orden_sort = @{$_[4]};
    my @indices;
    my $indice;
    
    if ($linea_og =~ /$en_syl_phoneme (\(\{([\s\d]*)\}\))/) {
        #push (@indices, $1);
        print "ensylpho: $en_syl_phoneme 1: $1\n";
        $indice = $1;
    }

    print "\nFONEMA $en_syl_phoneme INDICES $indice\n";
    print "\nINDICES ORDENADOS\n";
    foreach my $v (@orden_sort){
        print $v;    
    }
    print "\nINDICES ORDENADOS\n";
    
    #my $orden = $indice;
    my @orden_og = $indice =~ /(\d+)/g;
    
    if (grep(/$posicion/, @orden_og)) {
        return $linea_og;
    }else{
        push(@orden_og, $posicion);
        my @orden_sort2 = sort {$a <=> $b} @orden_og;
        my $ord = @orden_sort2;
        print "@orden_sort2\n";
        
        my $c = 0;
        my $e = 0;
        my $i = $orden_sort2[0];
        $i--;
        for (my $j=0; $j<$ord; $j++){
            print "i: $i / sort: $orden_sort[$i] / e: $e / og: $orden_sort2[$e]\n";
            if ($orden_sort[$i]!=$orden_sort2[$e]) {
                $c++;
            }
            $e++;
            $i++;
        }
        print "c: $c\n";
        if ($c == 0) {
            $linea_og =~ s/$en_syl_phoneme \(\{[\s\d]*\}\)/$en_syl_phoneme \(\{ @orden_sort2 \}\)/;
        }       

        return $linea_og;
    }
}