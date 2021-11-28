#!/usr/bin/env perl
use strict;
use warnings;

# The wiring is that of project 5.1 in the
# "Freenove Ultimate Starter Kit" at
#  https://freenove.com/tutorial.html

# * This must be run as root

use IO::Async::Timer::Periodic;
use IO::Async::Loop;
use RPi::WiringPi;
use RPi::Const qw(:all);

my $pin_num_red   = shift || 17; # GPIO numbering
my $pin_num_green = shift || 18; # "
my $pin_num_blue  = shift || 27; # "

my $pi = RPi::WiringPi->new;

my $pin_red   = $pi->pin( $pin_num_red );
my $pin_green = $pi->pin( $pin_num_green );
my $pin_blue  = $pi->pin( $pin_num_blue );

$pin_red->mode( PWM_OUT );
$pin_green->mode( PWM_OUT );
$pin_blue->mode( PWM_OUT );

my $loop = IO::Async::Loop->new;

my $timer = IO::Async::Timer::Periodic->new(
   interval => 1,
   on_tick  => \&multi,
);

$timer->start;
$loop->add( $timer );
$loop->run;

sub multi {
  my $r = int rand 101;
  my $g = int rand 101;
  my $b = int rand 101;
  print "RGB = [$r, $g, $b]\n";

  $pin_red->pwm( $r );
  $pin_green->pwm( $g );
  $pin_blue->pwm( $b );
}
