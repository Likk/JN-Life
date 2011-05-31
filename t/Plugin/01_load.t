use strict;
use Carp;
use Test::More;
use JN::Life::Plugin;

{
  my $logger = plugin('Logger');
  isa_ok $logger, 'JN::Life::Plugin::Logger', 'loger load';
  done_testing();
}
