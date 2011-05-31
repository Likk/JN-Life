package JN::Life::Engine::Main::GoogleCalc;

=head1 NAME

JN::Life::Engine::Main::GoogleCalc - Calculation at google.

=head1 DESCRIPTION

JN::Life::Engine::Main::GoogleCalc is Calculation at google for Jossenabe.

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
  $google->type('Calc');
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

