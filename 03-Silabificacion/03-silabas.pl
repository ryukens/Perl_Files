use warnings;
use strict;
use 5.28.1;

#my $filename = 'C:\Users\jjmor\Documents\JJMB\Documentos\results.txt';
#my $filename = 'C:\Users\jjmor\Documents\JJMB\Documentos\results_test.txt';
my $filename = '..\Documentos\results_test.txt';
my $linea;
my $string;
my $orden;
my @orden_og;
my @orden_sort;
my $tamano;
my @array_og;
my @array_jp;


open(FH, '<', $filename) or die $!;

while (<FH>) {
    $linea = $_;
    $orden = $linea;
    given($linea){
        when($linea =~ /[|]/){
            print "palabra multiple\n";
            print $linea;
            $orden =~ s/[^0-9]//g;
            @orden_og = split('', $orden, length($orden));
            print "orden: $orden\n";
            print @orden_og;
            print "\n";
            @orden_sort = sort {$a <=> $b} @orden_og;
            print @orden_sort;
            print "\n";
            if (@orden_og ~~ @orden_sort) {
                printf "Esta ordenado correctamente\n"
            }else{
                printf "Se debe ordenar\n";                
                $string = $linea;
                
                my $valor;
                while ($string =~ /NULL (\(\{([\s\d]*)\}\))/g) {
                    $valor = $1;
                }
                
                my $a = &reemplazo($valor,$linea,\@array_jp);
                
                print "A: $a \n";
                
            }    
            print "+++++++++++++++++ORDENADO++++++++++++++++++\n";
        }
        
        when($linea =~ /NULL/ && $linea !~ /[|]/){
            print "palabra simple\n";
            print $linea;
            print "\n";
            $orden =~ s/[^0-9]//g;
            @orden_og = split('', $orden, length($orden));
            print @orden_og;
            print "\n";
            @orden_sort = sort {$a <=> $b} @orden_og;
            print @orden_sort;
            print "\n";
            if (@orden_og ~~ @orden_sort) {
                printf "Esta ordenado correctamente\n";
            }else{
                printf "Se debe ordenar\n";                
                $string = $linea;
                
                #my ($pal) = $string =~ /(\(\{(\s\*[\s1-9]\s\*)\}\))/;
                my $valor;
                while ($string =~ /NULL (\(\{([\s\d]*)\}\))/g) {
                    $valor = $1;
                }
                
                my $a = &reemplazo($valor,$linea,\@array_jp);
                
                print "A: $a \n";
                
                #my ($pal) = $string =~ /(\(\{([\s1-9]*)\}\))/g;
                #print "pal: ".$pal;
                
                #my $string = '[48:31.8] Sent: >33*1311875297587*eval*0*frame[0]*"A"<';
                #my ($number) = $string =~ /\*(\d+)\*eval\*/;
                #print $number;                
                
            }                
            
            print "----------------ORDENADO----------------------\n";
            
        }
        when ($linea !~ /[0-9]/){
            #print "palabra japonesa:\n";
            @array_jp = split(/\s/,$linea);
            #print @array_jp;
            #print "\n";
            #foreach my $katakana (@array_jp) {print $katakana."\n"};
            #print "ooooooooooooooooooooooooooo\n";
        }
        #default {print "-\n";}
    }
    
    #if ($linea =~ /[|]/) {
    #    print "\n linea: ".$linea;
    #}
    
    
    #if ($linea =~ /NULL\s\(\{\s\}\)/ | $linea =~ /\|\s\(\{\s\}\)/) {
    #    $orden =~ s/[^0-9]//g;
    #    print "\n linea: ".$linea;
    #    print "\n orden: ".$orden;
    #}
    
}



close(FH);


# FUNCIONES

sub reemplazo {
    print "::::::::::::::INICIO::::::::::::::::::::\n";
    my $indice = $_[0];
    my $linea_og = $_[1];
    my @array_jp_og = @{$_[2]};
    my $tamano = scalar @array_jp_og;
    my $en_syl_phoneme;
    my $jp_syl_phoneme;
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
    
    $linea_og =~ s/NULL \(\{[\s\d]*\}\)/NULL \(\{ \}\)/;
    
    $indice =~ s/[^\d]//g;
    @array_indices = split('', $indice, length($indice));
    
    foreach $en_syl_phoneme (@array_en_phoneme) {
        print "Phonema EN = ".$en_syl_phoneme."\n";
        for ($contador; $contador<$tamano; $contador++) {
            print "Contador = ".$contador."\n";
            print "Phonema JP = ".$array_jp_og[$contador]."\n";
            given($en_syl_phoneme){
                when($en_syl_phoneme =~ /y/ && $array_jp_og[$contador] =~ /イ/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /t/ && $array_jp_og[$contador] =~ /ト/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                when($en_syl_phoneme =~ /s/ && $array_jp_og[$contador] =~ /ス/){
                    print "ENCONTRADO: ".$en_syl_phoneme."\n";
                    $flag = $contador + 1;
                }
                default{$flag = 0;}
                #PENDIENTE ANALIZAR CUANDO UN MISMO FONEMA APARECE REPETIDO
            };
            
            $orden =~ s/[^0-9]//g;
            @orden_actual = split('', $orden, length($orden));           
            print @orden_actual;
            print "\n";
            print @orden_sort;
            print "\n";
                             
            if (@orden_actual ~~ @orden_sort) {
                print "\nNO QUEDAN INDICES POR ORDENAR\n";
                return $linea_og;
            }else{
                if ( grep(/$flag/, @array_indices)) {
                    $linea_og = &ordenar($linea_og, $en_syl_phoneme, $flag);
                    $orden = $linea_og;
                    print "ALGO FUE ORDENADO\n";
                }
                $flag = 0;
                
                #REEMPLAZAR / AÑADIR EL INDICE AL FONEMA EN INGLÉS
                
                #print "SYL: ".$en_syl_phoneme." PARA ORDENAR: ".$linea_og."\n";
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
    print "\nFONEMA INDICES\n";
    print @indices;
    print "\nFONEMA INDICES\n";
    
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













