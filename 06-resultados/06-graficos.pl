use 5.28.1;
use utf8;
use Chart::Plotly;
use Chart::Plotly::Trace::Bar;
use Chart::Plotly::Plot;
use Chart::Plotly::Trace::Table;
use Chart::Plotly qw(show_plot);
use HTML::Show;
use Chart::Plotly::Trace::Pie;
use Chart::Plotly::Trace::Scatter;
my $x = [ "Umbral_1", "Umbral_2", "Umbral_3", "Umbral_4"];
#ENTRENAMIENTO
my $sample1 = Chart::Plotly::Trace::Bar->new( x    => $x,
                                              y    => [ map {23442} ( 1 .. ( scalar(@$x) ) ) ],
                                              name => "Total",
                                              
);
my $sample2 = Chart::Plotly::Trace::Bar->new( x    => $x,
                                              y    => [ map {18371} ( 1 .. ( scalar(@$x) ) ) ],
                                              name => "Utilizable"
);
my $sample3 = Chart::Plotly::Trace::Bar->new( x    => $x,
                                              y    => [ 10765, 13651, 15681, 16954],
                                              name => "Correcto"
);
my $sample4 = Chart::Plotly::Trace::Bar->new( x    => $x,
                                              y    => [ 7606, 4720, 2690, 1417],
                                              name => "Incorrecto"
);
my $plot = Chart::Plotly::Plot->new( traces => [ $sample1, $sample2, $sample3, $sample4 ],
                                    layout => {
                                       barmode => 'group',
                                       title  => 'Evolución de umbrales en data de entrenamiento',
                                       } );
Chart::Plotly::show_plot($plot);


#PRUEBA
$sample1 = Chart::Plotly::Trace::Bar->new( x    => $x,
                                              y    => [ map {10047} ( 1 .. ( scalar(@$x) ) ) ],
                                              name => "Total"
);
$sample2 = Chart::Plotly::Trace::Bar->new( x    => $x,
                                              y    => [ map {7980} ( 1 .. ( scalar(@$x) ) ) ],
                                              name => "Utilizable"
);
$sample3 = Chart::Plotly::Trace::Bar->new( x    => $x,
                                              y    => [ 3208, 4663, 5828, 6764],
                                              name => "Correcto"
);
$sample4 = Chart::Plotly::Trace::Bar->new( x    => $x,
                                          y    => [ 4772, 3317, 2152, 1216],
                                              name => "Incorrecto"
);
my $plot2 = Chart::Plotly::Plot->new( traces => [ $sample1, $sample2, $sample3, $sample4 ],
                                    layout => {
                                       barmode => 'group',
                                       title  => 'Evolución de umbrales en data de prueba',
                                       } );
Chart::Plotly::show_plot($plot2);


my $table = Chart::Plotly::Trace::Table->new(

    header => {
        values => [ [ "ENTRENAMIENTO" ], [ "Umbral_1" ], [ "Umbral_2" ], [ "Umbral_3" ], [ "Umbral_4" ]],
        align  => "center",
        line   => { width => 1, color => 'black' },
        fill   => { color => "grey" },
        font   => { family => "Arial", size => 12, color => "white" }
    },
    cells  => {
        values => [
            [ 'CORRECTO', 'INCORRECTO', 'UTILIZABLE', 'NO UTILIZABLE', 'TOTAL' ],
            [ 10765, 7606, 18371, 5071, 23442 ],
            [ 13651, 4720, 18371, 5071, 23442 ],
            [ 15681, 2690, 18371, 5071, 23442 ],
            [ 16954, 1417, 18371, 5071, 23442 ] ],
        align  => "center",
        line   => { color => "black", width => 1 },
        font   => { family => "Arial", size => 11, color => [ "black" ] }
    }
);
#HTML::Show::show( Chart::Plotly::render_full_html( data => [$table] ) );
show_plot([ $table ]);




my @labels = ( "Correcto", "Incorrecto" );
#my $pie = Chart::Plotly::Trace::Pie->new( labels => \@labels, values => [ map { int( rand() * 10 ) } @labels ] );
my $pie = Chart::Plotly::Trace::Pie->new( labels => \@labels,
                                         values => [ 58.6 , 41.4],
                                         text => ["Correcto - 10765", "Incorrecto - 7606"]);

#HTML::Show::show( Chart::Plotly::render_full_html( data => [$pie] ) );
show_plot([$pie]);

my $pie2 = Chart::Plotly::Trace::Pie->new( labels => \@labels,
                                         values => [ 40.2 , 59.8],
                                         text => ["Correcto - 3208", "Incorrecto - 4772"]);

#HTML::Show::show( Chart::Plotly::render_full_html( data => [$pie] ) );
show_plot([$pie2]);



my $scatter = Chart::Plotly::Trace::Scatter->new( x => [ 10765, 13651, 15681, 16954 ], y => [ 1 .. 4 ] );

#HTML::Show::show( Chart::Plotly::render_full_html( data => [$scatter] ) );
show_plot([$scatter]);







