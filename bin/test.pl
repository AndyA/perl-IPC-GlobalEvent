#!/usr/bin/env perl

use strict;
use warnings;

use lib qw( blib/lib blib/arch );

use IPC::GlobalEvent qw( eventsignal eventwait );

use constant SYNCF => 'foo';

my $pid = fork;
defined $pid or die $!;
unless ( $pid ) {
  my $serial = 0;
  while () {
    $serial = eventwait( SYNCF, $serial, 30000 );
    print "Serial updated to $serial\n";
  }
}

my $serial = 0;
while () {
  sleep( ( rand() & 15 ) + 5 );
  print "\nUpdating\n";
  eventsignal( SYNCF, $serial++ );
}

# vim:ts=2:sw=2:sts=2:et:ft=perl

