#!perl

use strict;
use warnings;

use File::Temp;
use Test::More tests => 8;
use Time::HiRes qw( time sleep );

use IPC::GlobalEvent qw( eventsignal eventwait );

sub test_nofork {
  my $tf = File::Temp->new;
  eventsignal( $tf, 123 );
  my $sn = eventwait( $tf, 0, 1 );
  is $sn, 123, "got 123";

  {
    my $now = time;
    my $sn2 = eventwait( $tf, $sn, 500 );
    ok time - $now >= 0.4, "waited";
    is $sn2, $sn, "timeout";
  }
}

sub test_events {
  my $tf  = File::Temp->new;
  my $pid = fork;
  defined $pid or die $!;
  unless ( $pid ) {
    for my $sn ( 1 .. 5 ) {
      eventsignal( $tf, $sn );
      sleep 1;
    }
    exit;
  }

  sleep 0.1 until -f $tf;
  sleep 1;

  my $sn = 0;
  for my $want ( 1 .. 5 ) {
    $sn = eventwait( $tf, $sn, 5000 );
    is $sn, $want, "got $want";
  }
  wait;
}

test_nofork();
test_events();

# vim:ts=2:sw=2:et:ft=perl

