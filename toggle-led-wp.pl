#!/usr/bin/env perl
use strict;
use warnings;

# The wiring is that of the second project in the
# "Freenove Ultimate Starter Kit" at https://freenove.com/tutorial.html

use IO::Async::Timer::Periodic;
use IO::Async::Loop;
use RPi::WiringPi;
use RPi::Const qw(:all);

my $led_pin_num = shift || 11; # Physical numbering
my $btn_pin_num = shift || 12; # "

my $pi = RPi::WiringPi->new;

my $led_pin = $pi->pin( $pi->phys_to_gpio( $led_pin_num ) );
my $btn_pin = $pi->pin( $pi->phys_to_gpio( $btn_pin_num ) );

$led_pin->mode( OUTPUT );
$btn_pin->mode( INPUT );
$btn_pin->pull( PUD_UP );

my $current_level = LOW;

my $loop = IO::Async::Loop->new;

my $timer = IO::Async::Timer::Periodic->new(
   interval => 0.2,
   on_tick  => \&sense,
);

$timer->start;
$loop->add( $timer );
$loop->run;

sub sense {
  my $btn_level = $btn_pin->read;
  my $led_level = $led_pin->read;

  if ( $btn_level == LOW ) {
    if ( $led_level == LOW ) {
      $current_level = HIGH;
    }
    elsif ( $led_level == HIGH ) {
      $current_level = LOW;
    }
  }

  $led_pin->write( $current_level );
}
