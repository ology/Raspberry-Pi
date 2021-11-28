#!/usr/bin/env perl
use strict;
use warnings;

use RPi::WiringPi;
use RPi::Const qw(:all);

my $led_pin_num = shift || die "Usage: perl $0 GPIO-number\n";

my $pi = RPi::WiringPi->new;

my $led_pin = $pi->pin( $led_pin_num );

$led_pin->mode( OUTPUT );

$led_pin->write( LOW );
print "LED off...\n";
