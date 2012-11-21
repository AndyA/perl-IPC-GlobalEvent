#!/usr/bin/perl -w

require 5.008001;

use strict;

use ExtUtils::MakeMaker;

WriteMakefile(
  ( MM->can( 'signature_target' ) ? ( SIGN => 1 ) : () ),
  license( 'perl' ),
  NAME          => 'IPC::GlobalEvent',
  AUTHOR        => 'Andy Armstrong <andy@hexten.net>',
  VERSION_FROM  => 'lib/IPC/GlobalEvent.pm',
  ABSTRACT_FROM => 'lib/IPC/GlobalEvent.pm',
  PL_FILES      => {},
  PREREQ_PM     => {
    'Linux::Inotify2' => '1.22',
    'Test::More'      => 0,
  },
  dist  => { COMPRESS => 'gzip -9f', SUFFIX => 'gz', },
  clean => { FILES    => 'IPC-GlobalEvent-*' },
);

sub license {
  my $lic = shift;
  local $^W = 0;    # Silence warning about non-numeric version
  return
   unless $ExtUtils::MakeMaker::VERSION >= '6.31';
  return ( LICENSE => $lic );
}
