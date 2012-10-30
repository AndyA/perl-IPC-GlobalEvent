package IPC::GlobalEvent;

require 5.008;

use strict;
use warnings;
use Carp;
use base qw( DynaLoader Exporter );

our @EXPORT_OK = qw( eventsignal eventwait );

=head1 NAME

IPC::GlobalEvent - System wide event notification

=cut

BEGIN {
  our $VERSION = '0.06';
  bootstrap IPC::GlobalEvent $VERSION;
}

1;

