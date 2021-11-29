#!/usr/bin/env perl
use strict;
use warnings;

# The wiring is that of project 4.1 in the
# "Freenove Ultimate Starter Kit" at
#  https://freenove.com/tutorial.html

# * This must be run as root

use IO::Async::Timer::Periodic;
use IO::Async::Loop;
use Iterator::Breathe;
use RPi::WiringPi;
use RPi::Const qw(:all);

my $led_pin_num = shift || 12; # Physical numbering

my $pi = RPi::WiringPi->new;

my $led_pin = $pi->pin( $pi->phys_to_gpio( $led_pin_num ) );

$led_pin->mode( PWM_OUT );

my $it = Iterator::Breathe->new( top => 63 );

my $loop = IO::Async::Loop->new;

my $timer = IO::Async::Timer::Periodic->new(
   interval => 0.2,
   on_tick  => \&breathe,
);

$timer->start;
$loop->add( $timer );
$loop->run;

sub breathe {
  print $it->i, "\n";

  $led_pin->pwm( $it->i );

  $it->iterate;
}
