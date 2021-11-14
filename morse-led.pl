#!/usr/bin/env perl
use strict;
use warnings;

# The wiring is that of the first project in the
# "Freenove Ultimate Starter Kit" at https://freenove.com/tutorial.html

use Convert::Morse qw( as_morse );
use HiPi qw( :rpi );
use HiPi::GPIO;
use IO::Prompt::Tiny 'prompt';
use Time::HiRes qw( usleep );

my $message = shift || die "Usage: perl $0 'Some message'\n";

my $morse = as_morse( $message );
$morse =~ s/\s+/ /g;
print "'$message => $morse\n";

my $gpio = HiPi::GPIO->new;

my $pin = $gpio->get_pin( RPI_PIN_11 );
$pin->mode( RPI_MODE_OUTPUT );

#$pin->value( RPI_LOW ); exit; # Oops!

while ( 1 ) {
  my $response = prompt( 'Enter=go q=quit', 'Enter' );

  if ( $response eq 'q' ) {
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
