package JN::Life::Engine::Main::GoogleWeather;

=head1 NAME

JN::Life::Engine::Main::GoogleWeather - Weather news.

=head1 DESCRIPTION

JN::Life::Engine::Main::GoogleWeather is Weather news by google for Jossenabe.

=cut

use strict;
use warnings;
use Carp;
use JN::Life::Util::SearchGoogle;

use Any::Moose;
__PACKAGE__->meta->make_immutable;
no  Any::Moose;

=head1 METHODS

=head2 talk

override talk method.

=cut

sub talk {
  my $self = shift;
  my $super = shift;
  my $hear = shift;

  my $google = JN::Life::Util::SearchGoogle->new();
  $google->type('Weather');
  return $google->search($hear);
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

