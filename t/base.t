# -*- perl -*-

#
# $Id: base.t,v 0.1 2006/02/21 eserte Exp $
# Author: Michael R. Davis
#

=head1 NAME

base.t - Good examples concerning how to use this module

=cut

use strict;

BEGIN {
    if (!eval q{
	use Test;
	1;
    }) {
	print "1..0 # tests only works with installed Test module\n";
	exit;
    }
}

BEGIN { plan tests => 9 }

use GD::Graph::Cartesian;

my $obj = GD::Graph::Cartesian->new(width=>106,
                                height=>108,
                                borderx=>3,
                                bordery=>4,
                                rgbfile=>"./rgb.txt");  #no standard location
ok(ref $obj, "GD::Graph::Cartesian");

foreach my $x (-33, 22, 11, -50, 50) {
  foreach my $y (55, -34, 56, 25, -44) {
    $obj->addPoint($x,$y);
  }
}
ok($obj->_scaley(15), 15);
ok($obj->_scalex(15), 15);
my($x,$y)=$obj->_imgxy_xy(5,7);
ok($x,58);
ok($y,53);
ok($obj->color([1,2,3]));
ok($obj->minx, -50);
ok($obj->miny, -44);
my $skip = 0;
eval q{use Graphics::ColorNames};
$skip = 1 if $@;
skip($skip, sub{$obj->color("blue")});
