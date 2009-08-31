#!/usr/bin/perl

=head1 NAME

GD-Graph-Cartesian-example.pl - GD::Graph::Cartesian general example

=cut

use strict;
use warnings;
use GD::Graph::Cartesian;
use GD qw{gdSmallFont};

my($x0,$y0,$x1,$y1,$x,$y)=qw{45 20 55 30 50 40};
my $obj=GD::Graph::Cartesian->new(height=>400, width=>800);
$obj->addPoint(50=>25);
$obj->addLine(50=>25, 51=>26);
$obj->addRectangle(45=>20, 55=>30);
$obj->addString(50=>25, "Hello World!");
$obj->font(gdSmallFont);  #sets the current font from GD exports
$obj->color("blue");      #sets the current color from Graphics::ColorNames
$obj->color([0,0,0]);     #sets the current color [red,green,blue]
print $obj->draw;
