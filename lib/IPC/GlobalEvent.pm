package IPC::GlobalEvent;

require 5.008;

use strict;
use warnings;

use Carp qw( croak );
use Linux::Inotify2;
use Time::HiRes qw( time sleep );

use base qw( Exporter );

our $VERSION = '0.02';

our @EXPORT_OK = qw( eventsignal eventwait );

=head1 NAME

IPC::GlobalEvent - System wide event notification

=cut

sub eventsignal {
  my ( $file, $sn ) = @_;
  my $tmp = "$file.tmp";
  {
    open my $fh, '>', $tmp or croak "Can't write $tmp: $!";
    print $fh "$sn\n";
  }
  rename $tmp, $file or croak "Can't rename $tmp as $file: $!";
}

sub _read_file {
  my $file = shift;
  open my $fh, '<', $file or return undef;
  chomp( my $sn = <$fh> );
  return $sn;
}

sub eventwait {
  my ( $file, $sn, $timeout ) = @_;
  my $deadline = time + $timeout / 1000;
  while ( time < $deadline ) {
    my $nsn = _read_file( $file );
    return $nsn if defined $nsn && $nsn ne $sn;
    sleep 0.1;
  }
  return $sn;
}

1;

