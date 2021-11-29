#!/usr/bin/env perl
use strict;
use warnings;

# The wiring is that of the second project in the
# "Freenove Ultimate Starter Kit" at https://freenove.com/tutorial.html

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

while ( 1 ) {
  my $btn_level = $btn_pin->read;

  if ( $btn_level == LOW ) {
    $led_pin->write( HIGH );
    print "LED on...\n";
  }
  else {
    $led_pin->write( LOW );
    print "LED off...\n";
  }
}
