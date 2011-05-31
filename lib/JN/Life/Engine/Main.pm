package JN::Life::Engine::Main;

=head1 NAME

JN::Life::Engie::Main - Main engine for Jossenabe Talking API

=head1 SYNOPSIS

  use JN::Life;

  $jn = JN::Life->new();
  $jn->talk("test");
  print $jn->res;

=head1 DESCRIPTION

JN::Life::Engie::Main is Main engine for Jossenabe Talking API.

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
    my $module = "JN::Life::Engine::Main\::$name";
    $module->require or die $@;
    return $module->new();
  };

  {
    no strict 'refs'; ## no critic
    no warnings 'redefine'; ## no critic
    *{"${caller}::mains"} = $engine_loader;
  }
}

1;

__END__

=head1 AUTHOR

Likkradyus E<lt>perl{at}likk.jpE<gt>

=head1 SEE ALSO

JN::Life

