package JN::Life::Engine::Assist::Summarize;

=head1 NAME

JN::Life::Engine::Assist::Summarize - summarize extractor

=head1 SYNOPSIS

  use JN::Life;


=head1 DESCRIPTION

JN::Life::Engine::Assist::Summarize is summarize extractor for Jossenabe.

=cut

use strict;
use warnings;
use Carp;
use autobox::Core;
use Lingua::JA::Summarize::Extract;

use Any::Moose;
has memo     => (
  is      => 'rw',
  isa     => 'Str',
  lazy    => 1,
  default => ''
);

has used_flg => (
  is      => 'rw',
  isa     => 'Int',
  lazy    => 1,
  default => 0
);

no Any::Moose;
__PACKAGE__->meta->make_immutable;

=head1 METHODS

=head2 run

Extract summarize

=cut

sub run {
  my $self = shift;
  my $super = shift;
  my $hear = shift;
  my $parser = Lingua::JA::Summarize::Extract->new();
  my $result = $parser->extract($hear);
  my $sentences = $result->sentences;
  return $hear if scalar @$sentences <= 1;
  for (@$sentences){
    my $best_samarize = $_->{text};
    return $best_samarize if defined $best_samarize and $best_samarize ne '';
  };
}

1;
