#!/usr/bin/env perl
use strict;
use warnings;

# The wiring is that of project 5.1 in the
# "Freenove Ultimate Starter Kit" at
#  https://freenove.com/tutorial.html

use IO::Async::Timer::Periodic;
use IO::Async::Loop;
use RPi::WiringPi;
use RPi::Const qw(:all);

my $pin_num_red   = shift || 11; # Physical numbering
my $pin_num_green = shift || 12; # "
my $pin_num_blue  = shift || 13; # "

my $pi = RPi::WiringPi->new;

my $pin_red   = $pi->pin( $pi->phys_to_gpio( $pin_num_red ) );
my $pin_green = $pi->pin( $pi->phys_to_gpio( $pin_num_green ) );
my $pin_blue  = $pi->pin( $pi->phys_to_gpio( $pin_num_blue ) );

$pin_red->mode( OUTPUT );
$pin_green->mode( OUTPUT );
$pin_blue->mode( OUTPUT );

$pin_red->write( ON );
$pin_green->write( ON );
$pin_blue->write( ON );

my $loop  = IO::Async::Loop->new;
my $timer = IO::Async::Timer::Periodic->new(
   interval => 1,
   on_tick  => \&multi,
);

$timer->start;
$loop->add( $timer );
$loop->run;

sub multi {
  my $pin = ( $pin_red, $pin_green, $pin_blue )[ int rand 3 ];
  $pin->write( not $pin->read );
}
