#!/usr/bin/env perl
use strict;
use warnings;

# The wiring is that of the third project in the
# "Freenove Ultimate Starter Kit" at https://freenove.com/tutorial.html

use HiPi qw( :rpi );
use HiPi::GPIO;

my $led_pin_num = shift || 11; # 1 .. 40
my $btn_pin_num = shift || 12; # 1 .. 40

my $led_pin_value = get_pin_value( $led_pin_num );
my $btn_pin_value = get_pin_value( $btn_pin_num );

my $gpio = HiPi::GPIO->new;

my $led_pin = $gpio->get_pin( $led_pin_value );
my $btn_pin = $gpio->get_pin( $btn_pin_value );

$led_pin->mode( RPI_MODE_OUTPUT );
$btn_pin->mode( RPI_MODE_INPUT );
$btn_pin->set_pud( RPI_PUD_UP );

my $current_level = RPI_LOW;

while ( 1 ) {
  my $btn_level = $btn_pin->value;
  my $led_level = $led_pin->value;

  if ( $btn_level == RPI_LOW ) {
    if ( $led_level == RPI_LOW ) {
      $current_level = RPI_HIGH;
    }
    elsif ( $led_level == RPI_HIGH ) {
      $current_level = RPI_LOW;
    }
  }

  $led_pin->value( $current_level );
}

sub get_pin_value {
  my ( $pin_num ) = @_;
  my $pin_name  = 'RPI_PIN_' . $pin_num;
  my $pin_value = __PACKAGE__->$pin_name;
  return $pin_value;
}
