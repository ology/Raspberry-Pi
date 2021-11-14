#!/usr/bin/env perl
use strict;
use warnings;

# The wiring is that of the first project in the
# "Freenove Ultimate Starter Kit" at https://freenove.com/tutorial.html

use Convert::Morse qw( as_morse );
use HiPi qw( :rpi );
use HiPi::GPIO;
use IO::Prompt::Tiny qw( prompt );
use Time::HiRes qw( usleep );

my $message = shift || die "Usage: perl $0 'Some message'\n";
my $pin_num = shift || 11; # 1 .. 40

my $morse = as_morse( $message );
$morse =~ s/\s+/ /g;
print "Msg: '$message', Morse: $morse\n";

my $pin_name  = 'RPI_PIN_' . $pin_num;
my $pin_value = __PACKAGE__->$pin_name;
print "Pin: $pin_name, Value: $pin_value\n\n";

my $gpio = HiPi::GPIO->new;

my $pin = $gpio->get_pin( $pin_value );
$pin->mode( RPI_MODE_OUTPUT );

while ( 1 ) {
  my $response = prompt( 'Enter=go q=quit', 'Enter' );

  if ( $response eq 'q' ) {
    $pin->value( RPI_LOW );
    last;
  }

  for my $char ( split '', $morse ) {
    if ( $char eq ' ' ) {
      sleep 2;
      next;
    }

    $pin->value( RPI_HIGH );

    if ( $char eq '.' ) {
      usleep 300_000;
    }
    elsif ( $char eq '-' ) {
      sleep 1;
    }

    $pin->value( RPI_LOW );

    usleep 500_000;
  }
}
