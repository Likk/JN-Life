use strict;
use Test::More;
use YAML;
use JN::Life;

{
  my $setting = {
    engines => {
      main   => {},
      assist => {
        AYT => 1,
      },
    }
  };
  my $jn  = JN::Life->new(setting => $setting);

  subtest 'simple are you therr?' => sub {
    is   $jn->ayt('ayt'),  '[yes]', 'normal ayt';
    isnt $jn->ayt('aty'), '[yes]', 'not ayt';
  };

  subtest 'any pattern aut' => sub {
    my $pattern = [
      'are you there',
      'are you there?',
      'Are You There',
      'R you there?',
      'are U there',
      'A Y there?',
      'AUThere?',
    ];
    for (@$pattern){
      is $jn->ayt($_), '[yes]', $_. ' -> [yes]';
      $jn->clean;
    }
  };
  done_testing();
}
