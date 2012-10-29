#!/usr/bin/env perl

use strict;
use warnings;

use lib qw( blib/lib blib/arch );

use IPC::GlobalEvent qw( eventwait );

use constant SYNCF => 'foo';

my $serial = 0;
while () {
  $serial = eventwait( SYNCF, $serial, 30000 );
  print "Serial updated to $serial\n";
}

# vim:ts=2:sw=2:sts=2:et:ft=perl

