package Test;
use strict;
use Test::More;
use Test::Warn;
use JN::Life::Plugin::Logger;

{

  my $logger;
  subtest 'prepare' => sub {
    $logger = JN::Life::Plugin::Logger->new();

    isa_ok $logger,            'JN::Life::Plugin::Logger', 'load test';
    is     $logger->buffer,    '',                         'buffer is null';

    $logger->level('error');                                #ログレベルの変更
    $logger->test_user($ENV{USER});                         #テストユーザを実行ユーザに指定

    is     $logger->level,     'error',                    'default level';
    isa_ok $logger->level_ref, 'HASH',                     'default level_ref isa';
    isa_ok $logger->files,     'HASH',                     'default level_ref isa';
    is     $logger->whereis,   'local',                    'default whereis';

  };

  subtest 'logging' => sub {
    warnings_like { $logger->error('Hoge') } qr/Hoge/, 'warn test';

    is $logger->buffer,   '',       'buffer is null after put';
  };

  done_testing();
}

