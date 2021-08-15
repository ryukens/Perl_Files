use warnings;
use strict;
use 5.28.1;

my $linea;
my $palabra;
my $silaba;
my $tipo;
my $posicion;
my $tamano;
my $final;
my @token;
my @token2;

#$linea = "a_words/a0000342.txt	acs	acs	única	acs";
#$linea = "o_words/o0006122.txt	útiles	ú-ti-les	primera	ú";
#$linea = "o_words/o0002792.txt	seguídamente	se-guí-da-men-te	segunda	guí";
#$linea = "a_words/a0000057.txt	abiertamente	a-bier-ta-men-te	dos	bier";
#$linea = "i_words/i0003232.txt	multifármacorresistentes	mul-ti-fár-ma-co-rre-sis-ten-tes	tercera	fár";
#$linea = "i_words/i0000936.txt	israelípalestino	is-ra-e-lí-pa-les-ti-no	cuarta	lí";
#$linea = "a_words/a0000013.txt	abandonar	a-ban-do-nar	última	nar";
#$linea = "e_words/e0002441.txt	empapada	em-pa-pa-da	penúltima	pa";
#$linea = "a_words/a0000445.txt	acústicos	a-cús-ti-cos	antepenúltima	cús";
#$linea = "o_words/o0006095.txt	íntimamente	ín-ti-ma-men-te	dos	ín";
#$linea = "a_words/a0003024.txt	boinas	boi-nas	primera	boi";
$linea = "e_words/e0004945.txt	genuina	ge-nui-na	penúltima	nui";
@token = split(/\t/,$linea);
$tipo = $token[3];
$palabra = $token[2];
$silaba = $token[4];
@token2 = split(/-/,$palabra);
$tamano = scalar @token2;

print "palabra: $palabra\n";
print "tamano: $tamano\n";
print "tipo: $tipo\n";
print "silaba: $silaba\n";

if ($palabra =~ /[áéíóú]/) {
    $palabra =~ tr/[áéíóú]/[ÁÉÍÓÚ]/;
    $palabra =~ tr/-/ /;
    print $palabra;
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
    
    print "posicion: $posicion\n";
    print "token2[posicion]: $token2[$posicion]\n";
    
    if ($token2[$posicion] =~ /ai|au|ia|ua|ei|eu|ie|iu|oi|ou|io|uo/) {
            $token2[$posicion] =~ tr/[aeo]/[AEO]/;
    }else{   
        if ($token2[$posicion] =~ /[aeiouáéíóú]/) {
            $token2[$posicion] =~ tr/[aeiouáéíóú]/[AEIOUÁÉÍÓÚ]/;
        }
    }
    print @token2;
    
    for (my $n=0; $n<$tamano; $n++) {
        if ($n > 0) {
            $final = $final." ".$token2[$n];
        } else {    
            $final = $token2[0];
        }
    }
    
    print "\ntoken @token2";

    print "\nfinal $final";
}
