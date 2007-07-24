#!/usr/bin/perl -w

=head1 NAME

example-locate.pl - GD::Graph::Cartesian example

=head1 SAMPLE OUTPUT

L<http://search.cpan.org/src/MRDVT/GD-Graph-Cartesian-0.01/bin/example-locate.png>

=cut

use strict;
use lib qw{./lib ../lib};
use GD::Graph::Cartesian;

my $obj=GD::Graph::Cartesian->new(width=>800, height=>400,
                                  borderx=>15, bordery=>25,
                                  iconsize=>2);

my $sx=-5;
my $sy=-4;
my $ex=8;
my $ey=10;
$obj->addRectangle($sx,$sy,$ex,$ey);
foreach my $x ($sx.. $ex) {
  foreach my $y ($sy .. $ey) {
    $obj->addPoint($x=>$y);
    $obj->addString($x=>$y, "$x=>$y");
  } 
}
my ($x0,$x1,$y0,$y1) = ($obj->_minmaxx, $obj->_minmaxy);
$obj->addRectangle($x0,$y0,$x1,$y1);
open(IMG, ">example-locate.png");
print IMG $obj->draw;
close(IMG);
