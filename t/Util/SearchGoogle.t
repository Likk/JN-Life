use strict;
use warnings;
use utf8;
use Test::More;
use YAML;
use JN::Life::Util::SearchGoogle;

{

  my $g;

  subtest 'prepare' => sub {
    $g = JN::Life::Util::SearchGoogle->new();
    isa_ok($g, 'JN::Life::Util::SearchGoogle', 'isa test');
    can_ok($g, 'type');

    done_testing();

  };

  subtest 'google main' => sub {
    isnt($g->search(q{google}),'','Search Google test');
    isnt($g->search(qq{日本語のテスト}),'','Search Google Japanese test');
    like($g->search(qq{日本語のテスト}),qr/日本語|テスト/, 'like test');
    done_testing();
  };

  subtest 'google calc' => sub {
    isnt($g->search(q{1 + 1}),'2','non calc test');

    $g->type(q{Calc});
    is($g->search(q{1 + 1}),'1 + 1 = 2','calc test');
    is($g->search(qq{計算：1 + 1}),'1 + 1 = 2','Japanese calc test');


    done_testing();
  };

  subtest 'google perhaps' => sub {
    $g->type('');
    isnt($g->search(q{gppgle}),'','non calc test');

    $g->type('Perhaps');
    like($g->search(q{gppgle}), qr/^もしかして：/, 'non calc test');

    done_testing();
  };

  subtest 'googke weather' => sub {
    $g->type('');
    isnt($g->search(qq{天気 五反田}),'','non calc test');

    $g->type('Weather');
    like($g->search(qq{天気 五反田}), qr/[晴雨曇雪]/, 'non calc test');

    done_testing();
  };

  done_testing();

}
