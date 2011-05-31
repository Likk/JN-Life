package JN::Life::Engine::Assist;

=head1 NAME

JN::Life::Engie::Assist - Assist engine for Jossenabe Talking API

=head1 SYNOPSIS

  use JN::Life;

  $jn = JN::Life->new();
  $jn->talk("test");
  print $jn->res;

=head1 DESCRIPTION

JN::Life::Engie::Assist is Assist engine for Jossenabe Talking API.

=cut

use strict;
use warnings;
use UNIVERSAL::require;
our $VERSION = '1.00';

sub import {
  my ($class, @opts) = @_;
  my $caller  = caller();

  my $engine_loader = sub {
    my $name = shift;
    my $module = "JN::Life::Engine::Assist\::$name";
    $module->require or die $@;
    return $module->new();
  };

  {
    no strict 'refs'; ## no critic
    no warnings 'redefine'; ## no critic
    *{"${caller}::assistance"} = $engine_loader;
  }
}

1;

__END__

=head1 AUTHOR

Likkradyus E<lt>perl{at}likk.jpE<gt>

=head1 SEE ALSO

JN::Life

