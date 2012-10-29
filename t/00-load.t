use Test::More tests => 1;

BEGIN {
  use_ok( 'IPC::GlobalEvent' );
}

diag( "Testing IPC::GlobalEvent $IPC::GlobalEvent::VERSION" );
diag( "ISA @IPC::GlobalEvent::ISA" );
