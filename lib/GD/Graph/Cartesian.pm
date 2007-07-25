package GD::Graph::Cartesian;

=head1 NAME

GD::Graph::Cartesian - Make cartesian graph using GD package

=head1 SYNOPSIS

  use GD::Graph::Cartesian;
  my $obj=GD::Graph::Cartesian->new(height=>400, width=>800);
  $obj->addPoint(50=>25);
  $obj->addLine($x0=>$y0, $x1=>$y1);
  $obj->addRectangle($x0=>$y0, $x1=>$y1);
  $obj->addString($x=>$y, "Hello World!");
  $obj->font(gdSmallFont);  #sets the current font from GD exports
  $obj->color("blue");      #sets the current color from Graphics::ColorNames
  $obj->color([0,0,0]);     #sets the current color [red,green,blue]
  print $obj->draw;

=head1 DESCRIPTION

=cut

use strict;
use vars qw($VERSION);
use GD qw{gdSmallFont};

$VERSION = sprintf("%d.%02d", q{Revision: 0.02} =~ /(\d+)\.(\d+)/);

=head1 CONSTRUCTOR

=head2 new

The new() constructor. 

  my $obj = GD::Graph::Cartesian->new(               #default values
                  width=>640,     #width in pixels
                  height=>480,    #height in pixels
                  ticksx=>10,     #number of major ticks
                  ticksy=>10,     #number of major ticks
                  borderx=>2,     #pixel border left and right
                  bordery=>2,     #pixel border top and bottom
                  rgbfile=>"/usr/X11R6/lib/X11/rgb.txt"
                  minx=>{auto},   #data minx
                  miny=>{auto},   #data miny
                  maxx=>{auto},   #data maxx
                  maxy=>{auto},   #data maxy
                  points=>[[$x,$y,$color],...],             #addPoint method
                  lines=>[[$x0=>$y0,$x1,$y1,$color],...]    #addLine method
                  strings=>[[$x0=>$y0,'String',$color],...] #addString method
                      );

=cut

sub new {
  my $this = shift();
  my $class = ref($this) || $this;
  my $self = {};
  bless $self, $class;
  $self->initialize(@_);
  return $self;
}

=head1 METHODS

=cut

sub initialize {
  my $self = shift();
  %$self=@_;
  $self->{'points'}  = [] unless ref($self->{'points'}) eq 'ARRAY';
  $self->{'lines'}   = [] unless ref($self->{'lines'}) eq 'ARRAY';
  $self->{'strings'} = [] unless ref($self->{'strings'}) eq 'ARRAY';
  $self->{'width'}   = 640 unless defined($self->{'width'});
  $self->{'height'}  = 480 unless defined($self->{'height'});
  $self->{'ticksx'}  =  10 unless defined($self->{'ticksx'});
  $self->{'ticksy'}  =  10 unless defined($self->{'ticksy'});
  $self->{'borderx'} =   2 unless defined($self->{'borderx'});
  $self->{'bordery'} =   2 unless defined($self->{'bordery'});
  $self->{'gdimage'}  = GD::Image->new($self->{'width'}, $self->{'height'});
  eval 'use Graphics::ColorNames';
  unless($@) {
    my $rgb;
    foreach (qw{
                 /usr/share/X11/rgb.txt
                 /usr/X11R6/lib/X11/rgb.txt
                 /etc/X11/rgb.txt
                 ./rgb.txt
                 ../rgb.txt
               }) {
      $rgb=$_ if -r;
    }
    $self->{'rgbfile'}=$self->{'rgbfile'} || $rgb;
    die('Error: Cannot read rgb.txt file "'. $self->{'rgbfile'}. '"') unless -r $self->{'rgbfile'};
    $self->{'ColorNames'}=Graphics::ColorNames->new($self->{'rgbfile'});
  }

  # make the background transparent and interlaced
  $self->{'gdimage'}->transparent($self->color([255,255,255]));
  $self->{'gdimage'}->interlaced('true');
  
  # Put a frame around the picture
  $self->{'gdimage'}->rectangle(0, 0, $self->{'width'}-1, $self->{'height'}-1, $self->color([0,0,0]));

  $self->font(gdSmallFont);
  $self->color([0,0,0]);
}

=head2 addPoint

Method to add a point to the graph.

  $obj->addPoint(50=>25);
  $obj->addPoint(50=>25, [$r,$g,$b]);

=cut

sub addPoint {
  my $self = shift();
  my $x=shift();
  my $y=shift();
  my $c=shift() || $self->color();
  my $p=$self->points();
  push @$p, [$x=>$y, $c];
  return scalar(@$p);
}

=head2 addLine

Method to add a line to the graph.

  $obj->addLine(50=>25, 75=>35);
  $obj->addLine(50=>25, 75=>35, [$r,$g,$b]);

=cut

sub addLine {
  my $self = shift();
  my $x0=shift();
  my $y0=shift();
  my $x1=shift();
  my $y1=shift();
  my $c=shift() || $self->color();
  my $l=$self->lines();
  push @$l, [$x0=>$y0, $x1=>$y1, $c];
  return scalar(@$l);
}

=head2 addString

Method to add a string to the graph.

  $obj->addString(50=>25, 'String');
  $obj->addString(50=>25, 'String', [$r,$g,$b]);
  $obj->addString(50=>25, 'String', [$r,$g,$b], $font); #$font is a gdfont

=cut

sub addString {
  my $self=shift();
  my $x=shift();
  my $y=shift();
  my $s=shift();
  my $c=shift() || $self->color();
  my $f=shift() || $self->font();
  my $a=$self->strings();
  push @$a, [$x=>$y, $s, $c, $f];
  return scalar(@$a);
}

=head2 addRectangle

  $obj->addRectangle(50=>25, 75=>35);
  $obj->addRectangle(50=>25, 75=>35, [$r,$g,$b]);

=cut

sub addRectangle {
  my $self=shift();
  my $x0=shift();
  my $y0=shift();
  my $x1=shift();
  my $y1=shift();
  my $c=shift() || $self->color();
  $self->addLine($x0=>$y0, $x0=>$y1, $c);
  $self->addLine($x0=>$y1, $x1=>$y1, $c);
  $self->addLine($x1=>$y1, $x1=>$y0, $c);
  return $self->addLine($x1=>$y0, $x0=>$y0, $c);
}

=head2 points 

  Returns the points array reference.

=cut

sub points {
  return shift->{'points'};
}

=head2 lines 

  Returns the lines array reference.

=cut

sub lines {
  return shift->{'lines'};
}

=head2 strings 

  Returns the strings array reference.

=cut

sub strings {
  return shift->{'strings'};
}

=head2 color

Method to set or return the current drawing color

  my $colorobj=$obj->color("blue");     #if Graphics::ColorNames available
  my $colorobj=$obj->color([77,82,68]); #rgb=>[decimal,decimal,decimal]
  my $colorobj=$obj->color;

=cut

sub color {
  my $self = shift();
  if (@_) {
    my $color=shift();
    if (ref($color) eq "ARRAY") {
      my ($r, $g, $b)= @$color;
      unless (defined($self->{'colors'}->{$r}->{$g}->{$b})) {
        $self->{'colors'}->{$r}->{$g}->{$b} =
          $self->{'gdimage'}->colorAllocate(@$color);
      }
      $self->{'color'}=$self->{'colors'}->{$r}->{$g}->{$b};
    } else {
      if (defined($self->{'ColorNames'})) {
        my @rgb=$self->{'ColorNames'}->rgb($color);
        @rgb=(0,0,0) unless scalar(@rgb) == 3;
        $self->{'color'}=$self->color(\@rgb);
      } else {
        $self->{'color'}=$self->color([0,0,0]);
      }
    }
  }
  return $self->{'color'};
}

=head2 font

Method to set or return the current drawing font (only needed by the very few)

  use GD qw(gdGiantFont gdLargeFont gdMediumBoldFont gdSmallFont gdTinyFont);
  $obj->font(gdSmallFont); #the default
  $obj->font;

=cut

sub font {
  my $self = shift();
  if (@_) { $self->{'font'} = shift() } #sets value
  return $self->{'font'};
}

=head2 draw

Method returns a PNG binary blob.

  my $png_binary=$obj->draw;

=cut

sub draw {
  my $self=shift();
  my $p=$self->points;
  foreach (@$p) {
    my $i=$self->{'iconsize'}||7; #point size of 7 px
    my $x=$_->[0];
    my $y=$_->[1];
    my $c=ref($_->[2]) eq 'ARRAY' ? $self->color($_->[2]) : $self->color;
    $self->{'gdimage'}->arc($self->_imgxy_xy($x,$y),$i,$i,0,360,$c);
  }
  my $l=$self->lines;
  foreach (@$l) {
    my $x0=$_->[0];
    my $y0=$_->[1];
    my $x1=$_->[2];
    my $y1=$_->[3];
    my $c=ref($_->[4]) eq 'ARRAY' ? $self->color($_->[4]) : $self->color;
    $self->{'gdimage'}->line($self->_imgxy_xy($x0, $y0),
                            $self->_imgxy_xy($x1, $y1), $c);
  }
  my $s=$self->strings;
  foreach (@$s) {
    my $x=$_->[0];
    my $y=$_->[1];
    my $s=$_->[2];
    my $c=ref($_->[3]) eq 'ARRAY' ? $self->color($_->[3]) : $self->color;
    my $f=$_->[4] || $self->font;
    $self->{'gdimage'}->string($f, $self->_imgxy_xy($x, $y), $s, $c);
  }
  return $self->{'gdimage'}->png;
}

=head2 minx

=cut

sub minx {
  my $self=shift();
  my ($min, $max)=$self->_minmaxx;
  return defined($self->{'minx'}) ? $self->{'minx'} : $min;
}

=head2 maxx

=cut

sub maxx {
  my $self=shift();
  my ($min, $max)=$self->_minmaxx;
  return defined($self->{'maxx'}) ? $self->{'maxx'} : $max;
}

=head2 miny

=cut

sub miny {
  my $self=shift();
  my ($min, $max)=$self->_minmaxy;
  return defined($self->{'miny'}) ? $self->{'miny'} : $min;
}

=head2 maxy

=cut

sub maxy {
  my $self=shift();
  unless (defined($self->{'maxy'})) {
    my ($min, $max)=$self->_minmaxy;
    $self->{'maxy'}=$max;
  }
  return $self->{'maxy'};
}

sub _minmaxx {
  my $self=shift();
  my $p=$self->points;
  my $l=$self->lines;
  my $s=$self->strings;
  my @x=();
  push @x, map {$_->[0]} @$p;
  push @x, map {$_->[0], $_->[2]} @$l;
  push @x, map {$_->[0]} @$s;
  @x=sort {$a <=> $b} @x;
  return @x[0, -1];
}

sub _minmaxy {
  my $self=shift();
  my $p=$self->points;
  my $l=$self->lines;
  my $s=$self->strings;
  my @x=();
  push @x, map {$_->[1]} @$p;
  push @x, map {$_->[1], $_->[3]} @$l;
  push @x, map {$_->[1]} @$s;
  @x=sort {$a <=> $b} @x;
  return @x[0,-1];
}

=head2 _scalex

Method returns the parameter scaled to the pixels.

=cut

sub _scalex {
  my $self=shift();
  my $x=shift(); #units
  my $max=$self->maxx;
  my $min=$self->minx;
  my $s=1;
  if (defined($max) and defined($min) and $max-$min) {
    $s=($max - $min) / ($self->{'width'} - 2 * $self->{'borderx'}); #units/pixel
  }
  return $x / $s; #pixels
}

=head2 _scaley

Method returns the parameter scaled to the pixels.

=cut

sub _scaley {
  my $self=shift();
  my $y=shift(); #units
  my $max=$self->maxy;
  my $min=$self->miny;
  my $s=1;
  if (defined($max) and defined($min) and $max-$min) {
    $s=($max - $min) / ($self->{'height'} - 2 * $self->{'bordery'}); #units/pixel
  }
  return $y / $s; #pixels
}

=head2 _imgxy_xy

Method to convert xy to imgxy cordinates

=cut

sub _imgxy_xy {
  my $self = shift();
  my $x=shift();
  my $y=shift();
  return ($self->_imgx_x($x), $self->_imgy_y($y));
}

sub _imgx_x {
  my $self=shift();
  my $x=shift();
  return $self->{'borderx'} + $self->_scalex($x - $self->minx);
}

sub _imgy_y {
  my $self=shift();
  my $y=shift();
  return $self->{'height'} - ($self->{'bordery'} + $self->_scaley($y - $self->miny));
}

1;

__END__

=head1 TODO

The color method creates a new color for each call.  Does this really create a new color in the GD package?  Or, is it smart enough to consolidate color pallet.

=head1 BUGS

Please send to the geo-perl email list.

=head1 LIMITS

=head1 AUTHOR

Michael R. Davis qw/perl michaelrdavis com/

=head1 LICENSE

Copyright (c) 2006 Michael R. Davis (mrdvt92)

This library is free software; you can redistribute it and/or modify it under the same terms as Perl itself.

=head1 SEE ALSO

L<GD>
L<Geo::Constants>
L<Geo::Functions>
L<GD::Graph::Polar>
