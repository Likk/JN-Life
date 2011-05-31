use strict;
use Test::More;
use YAML;
use JN::Life;
use utf8;

{
  our ($string,$perhaps,$calc,$jcalc) =
  ('google','gppgle','1+1',"計算：65535 * 256");
  my $setting = {
    engines => {
      main => {
        GoogleCalc => {
          priority_fix => 200,
          probability  => 100,
        },
        GoogleWeather => {
          priority_fix => 200,
          probability  => 100,
        },
        GooglePerhaps => {
          priority_fix => 200,
          probability  => 100,
        },
        Google => {
          priority_fix => 50,
          probability  => 100,
        },
      },
    }
  };

  subtest 'google main' => sub {
    my $jn = JN::Life->new(setting => $setting);
    $jn->talk($string);
    isnt($jn->res,'','SearchGoogle test');
    $jn->clean;

    $jn->talk($calc);
    is($jn->res,'1 + 1 = 2','Google_Calc test');
    $jn->clean;


    $jn->talk($jcalc);
    is($jn->res,'65,535 * 256 = 16,776,960','Google_jCalc test');
    $jn->clean;


    $jn->talk($perhaps);
    is($jn->res,"もしかして：google",'Google_Perhaps test');
    $jn->clean;

  };

  subtest 'google doller' => sub {
    my $jn = JN::Life->new(setting => $setting);

    $jn->talk(q{1 dollar});
    like($jn->res,qr/円/,'Google_Calc test');
    $jn->clean;

  };

  subtest 'google weather' => sub {
    my $jn = JN::Life->new(setting => $setting);

    $jn->talk(qq{天気 五反田});
    like($jn->res,qr/[晴曇雨雷]/,'Google_Weather test');

  };
  done_testing();
}
