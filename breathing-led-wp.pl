#!/usr/bin/env perl
use strict;
use warnings;

# The wiring is that of project 4.1 in the
# "Freenove Ultimate Starter Kit" at
#  https://freenove.com/tutorial.html

use IO::Async::Timer::Periodic;
use IO::Async::Loop;
use RPi::WiringPi;
use RPi::Const qw(:all);

my $led_pin_num = shift || 18; # GPIO numbering

my $pi = RPi::WiringPi->new;

my $led_pin = $pi->pin( $led_pin_num );

$led_pin->mode( PWM_OUT );

my $loop = IO::Async::Loop->new;

my $i = 0;
my $direction = 1;
my $top = 63;

my $timer = IO::Async::Timer::Periodic->new(
   interval => 0.2,
   on_tick  => \&breathe,
);

$timer->start;
$loop->add( $timer );
$loop->run;

sub breathe {
  $led_pin->pwm( $i );

  if ( $direction ) {
    if ( $i >= $top ) {
      $i--;
      $direction = 0;
      print "Change direction to down.\n";
    }
    else {
      $i++;
    }
  }
  else {
    if ( $i <= 0 ) {
      $i++;
      $direction = 1;
      print "Change direction to up.\n";
    }
    else {
      $i--;
    }
  }
}
