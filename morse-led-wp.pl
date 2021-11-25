#!/usr/bin/env perl
use strict;
use warnings;

# The wiring is that of the first project in the
# "Freenove Ultimate Starter Kit" at https://freenove.com/tutorial.html

use Convert::Morse qw( as_morse );
use IO::Prompt::Tiny qw( prompt );
use RPi::WiringPi;
use RPi::Const qw(:all);
use Time::HiRes qw( usleep );

my $message = shift || die "Usage: perl $0 'Some message'\n";
my $pin_num = shift || 17; # GPIO numbering

my $morse = as_morse( $message );
$morse =~ s/\s+/ /g;
print "Msg: '$message', Morse: $morse\n";

my $pin = $pi->pin( $pin_num );
$pin->mode( OUTPUT );

while ( 1 ) {
  my $response = prompt( 'Enter=go q=quit', 'Enter' );

  if ( $response eq 'q' ) {
    $pin->write( OFF );
    last;
  }

  for my $char ( split '', $morse ) {
    if ( $char eq ' ' ) {
      sleep 2;
      next;
    }

    $pin->write( ON );

    if ( $char eq '.' ) {
      usleep 300_000;
    }
    elsif ( $char eq '-' ) {
      sleep 1;
    }

    $pin->write( OFF );

    usleep 500_000;
  }
}

$pi->cleanup;
