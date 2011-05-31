package JN::Life::Engine::Main::Random;

=head1 NAME

JN::Life::Engine::Main::Random - Random talk.

=head1 DESCRIPTION

JN::Life::Engine::Main::Random is Random talking for Jossenabe.

=cut

use strict;
use warnings;
use Carp;
use JN::Life::Util::SearchGoogle;

use Any::Moose;
__PACKAGE__->meta->make_immutable;
no  Any::Moose;

=head1 Package::Global::Variable

=over

=item B<VERSION>

this package version.

=item B<data>

=cut

our @data = <DATA>;

=back

=head1 METHODS

=head2 talk

override talk method.

=cut

sub talk {
  my $self = shift;

  #何を言われようが関係ない！
  #my $super = shift;
  #my $hear = shift;

  return $data[int(rand(scalar @data))];
}

1;

=head1 AUTHOR

Likkradyus E<lt>perl{at}likk.jpE<gt>

=head1 SEE ALSO

JN::Life;
JN::Life::Engine;
JN::Life::Engine::Main
JN::Life::Util::SearchGoogle

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

__DATA__
最近の国の情勢はどうなんです？
け、結婚して下さい！
しりとりをしましょう。私から始めますね…「ぺんぎん！」
「ばら」って漢字で書けます？
「れもん」って漢字で書けます？
「しょうゆ」って漢字で書けます？
「くじら」って漢字で書けます？
「さば」って漢字で書けます？
「よせなべりん」って漢字で書けます？
私はこう見えても「歌」が好きなんです
うぅ～おなかが痛い～
