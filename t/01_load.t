use strict;
use Carp;
use Test::More;
use JN::Life;

{
  my $jn;
  subtest 'prepare' => sub {
    $jn = JN::Life->new();
    isa_ok $jn, 'JN::Life', 'jn load';
    isa_ok $jn->logger,                      'JN::Life::Plugin::Logger',            'logger load';
    isa_ok $jn->engine->main('Dummy'),       'JN::Life::Engine::Main::Dummy',       'main engine load';
    isa_ok $jn->engine->assist('Summarize'), 'JN::Life::Engine::Assist::Summarize', 'assist engine load';
  };

  done_testing();
}
