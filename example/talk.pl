#!/usr/bin/perl
use strict;
use warnings;
use autodie;
use Carp;
use Encode;
use FindBin;
use lib "$FindBin::RealBin/../lib";
use JN::Life;
#$SIG{__DIE__}  = \&Carp::confess;
#$SIG{__WARN__} = \&Carp::cluck;

my $setting = {
  engines => {
    main => {
#      Dummy => {
#        priority_range => [ 0,0 ],
#        probability    => 100,
#      },
      GoogleCalc => {
        priority_fix => 200,
        probability  => 100,
      },
      GoogleWeather => {
        priority_fix => 199,
        probability  => 100,
      },
      GooglePerhaps => {
        priority_fix => 198,
        probability  => 100,
      },
      Google => {
        priority_range => [50, 20 ],
        probability    => 100,
      },
      Random => {
        priority_range => [30,0],
        probability    => 100,
      }
    },
    assist => {
      Summarize => 1,
      AYT       => 1,
    }
  },
};

local $\ ="\n";

my $jn = JN::Life->new(
  setting => $setting
);

while(1){
  my $t = <STDIN>;
  chomp($t);
  next if $t eq '';
  last if $t eq 'quit';
  my $ayt = $jn->ayt($t) ? '[yes]': '';
  print $ayt and next if $ayt eq '[yes]';
  $jn->talk($t);
  my $res = Encode::encode_utf8 $jn->res;
  print $res;
  $jn->clean();
}
