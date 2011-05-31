package JN::Life::Engine::Assist::AYT;

=head1 NAME

JN::Life::Engine::Assist::AYT - are you there.

=head1 DESCRIPTION

JN::Life::Engine::Assist::AYT is are you there for Jossenabe.

=cut

use strict;
use warnings;
use Carp;

use Any::Moose;
__PACKAGE__->meta->make_immutable;
no  Any::Moose;

=head1 METHODS

=head2 run

override talk method.

=cut

sub run {
  my $self = shift;
  my $hear = shift;
  return $hear =~ m{^(A(?:re)*|R)(?:\s*)(Y(?:ou)*|U)(?:\s*)T(?:here)?(?:\?)?$}i ? '[yes]' : '';
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

