package JN::Life::Engine::Main::Dummy;

=head1 NAME

JN::Life::Engine::Main::Dummy - dummy (test) talking engine.

=head1 DESCRIPTION

JN::Life::Engine::Main::Dummy is dummy talking engine for Jossenabe.

=cut

use strict;
use warnings;
use Carp;

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
  return 'dummy: '.$hear;
}

1;

=head1 AUTHOR

Likkradyus E<lt>perl{at}likk.jpE<gt>

=head1 SEE ALSO

JN::Life;
JN::Life::Engine;

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

