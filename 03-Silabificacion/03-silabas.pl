use warnings;
use strict
use utf8;
use 5.28.1;

my $file_in = '..\Documentos\results.txt';
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
    $linea = $_;
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
    my @array_jp_og = @{$_[2]};
    my $tamano = scalar @array_jp_og;
    my $en_syl_phoneme;
    my @array_en_phoneme;
    my @array_indices;
    my $contador = 0;
    my $flag = 0;
    my $orden = $linea_og;
    
    print "INDICES POR ORDENAR\n";
    print $indice;
    print "\nLINEA\n";
    print $linea_og;
    print "\nKATAKANAS\n";
    print @array_jp_og;
    
    print "\n::::::::::::::BUSQUEDA::::::::::::::::::::\n";  
    
    while ($linea_og =~ /([^\s\(\)\{\}\[\]\|\d(NULL)]+)/g) {
        push (@array_en_phoneme, $1);
    }

    $orden =~ s/[^0-9]//g;
    my @orden_actual = split('', $orden, length($orden));
    my @orden_sort = sort {$a <=> $b} @orden_actual;
    
    $linea_og =~ s/^NULL \(\{[\s\d]*\}\)/NULL \(\{ \}\)/;
    $linea_og =~ s/^(\(\{([\s\d]*)\}\))/\(\{ \}\)/;
    
    $indice =~ s/[^\d]//g;
    @array_indices = split('', $indice, length($indice));
    
    if ($indice eq "") {
        print "\nNO QUEDAN INDICES POR ORDENAR\n";
        return $linea_og;
    }
    
    foreach $en_syl_phoneme (@array_en_phoneme) {
        print "Phonema EN = ".$en_syl_phoneme."\n";
        for ($contador; $contador<$tamano; $contador++) {
            print "Contador = ".$contador."\n";
            print "Phonema JP = ".$array_jp_og[$contador]."\n";
            given($en_syl_phoneme){                
                #REGLAS GENERALIZADAS
                when($en_syl_phoneme =~ /`?[aery]\w+/ && $array_jp_og[$contador] =~ /^[アヤ]/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?[iy]\w+/ && $array_jp_og[$contador] =~ /^イ/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?[auvw]\w+/ && $array_jp_og[$contador] =~ /^ウ/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?[aeiy]\w+/ && $array_jp_og[$contador] =~ /^エ/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?[aow]\w+/ && $array_jp_og[$contador] =~ /^オ/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?[bv]\w+/ && $array_jp_og[$contador] =~ /^[バビブベボ]/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?d\w+/ && $array_jp_og[$contador] =~ /^[ダヂヅデド]/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?g\w+/ && $array_jp_og[$contador] =~ /^[ガギグゲゴ]/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?[fh]\w+/ && $array_jp_og[$contador] =~ /^フ/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?([fh]|ch)\w+/ && $array_jp_og[$contador] =~ /^[ハヘ]/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?[ak]\w+/ && $array_jp_og[$contador] =~ /^ヒ/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?[fhw]\w+/ && $array_jp_og[$contador] =~ /^ホ/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?k\w+/ && $array_jp_og[$contador] =~ /^[カキクケコ]/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?m\w+/ && $array_jp_og[$contador] =~ /^[マミムメモ]/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?n\w+/ && $array_jp_og[$contador] =~ /^[ナニヌネノ]/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?(ng?|m)\w+/ && $array_jp_og[$contador] =~ /^ン/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?p\w+/ && $array_jp_og[$contador] =~ /^[パピプペポ]/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?[rl]\w+/ && $array_jp_og[$contador] =~ /^[ラリルレロ]/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?([sz]|th)\w+/ && $array_jp_og[$contador] =~ /^[サス]/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?([szy]|th)\w+/ && $array_jp_og[$contador] =~ /^シ/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?(s|th)\w+/ && $array_jp_og[$contador] =~ /^[セソ]/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?t\w+/ && $array_jp_og[$contador] =~ /^[ツテト]/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?[td]\w+/ && $array_jp_og[$contador] =~ /^タ/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?([tz]|ch)\w+/ && $array_jp_og[$contador] =~ /^チ/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?[wv]\w+/ && $array_jp_og[$contador] =~ /^[ワヲ]/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?(y|jh)\w+/ && $array_jp_og[$contador] =~ /^[ユヨ]/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?([zs]|d)\w+/ && $array_jp_og[$contador] =~ /^ザ]/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?z\w+/ && $array_jp_og[$contador] =~ /^[ズゾ]/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?([zs]|jh)\w+/ && $array_jp_og[$contador] =~ /^ゼ/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /`?([dsz]|jh)\w+/ && $array_jp_og[$contador] =~ /^ジ/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /^`?jh\w+/ && $array_jp_og[$contador] =~ /^[ゼゲガ]/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }               
                default{$flag = 0;}
            };
            
            $orden =~ s/[^0-9]//g;
            @orden_actual = split('', $orden, length($orden));           
            #print @orden_actual;
            #print "\n";
            #print @orden_sort;
            #print "\n";
                             
            if (@orden_actual ~~ @orden_sort && $indice eq "") {
                print "\nNO QUEDAN INDICES POR ORDENAR\n";
                return $linea_og;
            }else{
                if ( grep(/$flag/, @array_indices)) {
                    $linea_og = &ordenar($linea_og, $en_syl_phoneme, $flag);
                    $orden = $linea_og;
                    print "FONEMA ALINEADO\n";
                }
                $flag = 0;
                print "\n";
            }
        }
        $contador = 0;
        print ":::::::::::::FIN FOR EACH:::::::::::::::::\n";
        };
    
    print "::::::::::::::FINAL::::::::::::::::::::\n";
    return ($linea_og);   
            
}


sub ordenar {
    my $linea_og = $_[0];
    my $en_syl_phoneme = $_[1];
    my $posicion = $_[2];
    my @indices;
    
    if ($linea_og =~ /$en_syl_phoneme (\(\{([\s1-9]*)\}\))/g) {
        push (@indices, $1);
    }
    print "\nFONEMA $en_syl_phoneme INDICES\n";
    print @indices;
    print "\nFONEMA $en_syl_phoneme INDICES\n";
    
    my $orden = $indices[0];
    $orden =~ s/[^\d]//g;
        
    my @orden_og = split('', $orden, length($orden));
    
    if (grep(/$posicion/, @orden_og)) {
        return $linea_og;
    }else{   
        push(@orden_og, $posicion);
        my @orden_sort = sort {$a <=> $b} @orden_og;                 
        
        $linea_og =~ s/$en_syl_phoneme \(\{[\s\d]*\}\)/$en_syl_phoneme \(\{ @orden_sort \}\)/;
        
        return $linea_og;
    }
}


# EJEMPLO ALINEACION
#if ($en_syl_phoneme =~ /^th$/ && $jp_syl_phoneme =~ /^[シソス]/)
# シ  apathy  アパシー; ソ method メ ソッ ド  `m_eh th_ax_d; ス athletic ア ス レ チッ ク ae_th `l_eh t_ax_k


# Establecer grupos que generalicen a los fonemas que se estan analizando.
    ####### Ej agrupar por (prioridad) - consonantes, (segundo plano) vocales. #######
# Recordar que siempre existiran excepciones.
# Luego de tener las reglas no siempre se podrá cuadrar todos los casos (3%-5%) por las excepciones existentes. (personal computer / building)
# Las siglas también son excepciones.
#
# SUGERENCIA
# Revisar -> el bloque de fonema por ejemplo:
# NULL ({ 2 }) `l_ey ({ 1 }) `aw_t ({ 3 4 5 }) si el indice 3 está bien ubicado y por ende el indice mal alineado tendrá menos opcionens en donnde entrar
# Revisar consistenciia entre fonemas.