package JN::Life::Engine;

=head1 NAME

JN::Life::Engie - Engine for Jossenabe Talking API

=head1 SYNOPSIS

  use JN::Life;

  $jn = JN::Life->new();
  $jn->talk("test");
  print $jn->res;

=head1 DESCRIPTION

JN::Life::Engie is Engine for Jossenabe Talking API.

=cut

use strict;
use warnings;
use autodie;
use Carp;
use JN::Life::Engine::Main;
use JN::Life::Engine::Assist;

=head1 CONSTRUCTOR AND STARTUP

=head2 new

Creates and returns a new Board object.:

=cut

sub new {
  bless {}, shift;
}

=head1 METHODS

=head2 main

=cut

sub main {
  my $self   = shift;
  return mains(shift);
}

=head2 assist

=cut

sub assist {
  my $self   = shift;
  return assistance(shift);
}

=head2 order_main_list

get a list of sorted main engines.

=cut

sub order_main_list {
  my $self = shift;
  $self->order_main(shift);
  return $self->{order_main_list};
}

=head2 order_main

order by main engine priority

=cut

sub order_main {
  my $self = shift;
  my $engine_setting = shift;
  my $list = [];
  my $lookup;
  #エンジンの優先度を決定する。
  for my $engine (keys %$engine_setting) {
    my $val = $engine_setting->{$engine};

    #priority_fix があればその値をそのまま使う。
    $val->{priority_fix_tmp} = $val->{priority_fix} and next if $val->{priority_fix};

    #priority_range の場合は 配列間のランダムの値を取る。
    #設定されてなければ 0 にする。
    my $min   = $val->{priority_range}->[1] || 0;
    my $max   = $val->{priority_range}->[0] || 0;
    my $range = $max - $min;
    $val->{priority_fix_tmp} = rand($range) + $min;
  }

  #優先度順にエンジン名をsort
  $list = [
    sort {
      $engine_setting->{$b}->{priority_fix_tmp} <=>
      $engine_setting->{$a}->{priority_fix_tmp}
    } keys %$engine_setting
  ];
  $self->{order_main_list} = $list;
}

1;

__END__

=head1 AUTHOR

Likkradyus E<lt>perl{at}likk.jpE<gt>

=head1 SEE ALSO

JN::Life

