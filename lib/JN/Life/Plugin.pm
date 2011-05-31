package JN::Life::Plugin;

=head1 JN::Life::Plugin - plugin loader

=head1 SYNOPSIS

  use JN::Life::Plugin
  plugin('Logger');
  This code is equivalent to:
  JN::Life::Plugin::Logger;

=head1 DESCRIPTION

JN::Life::Plugin is a plugin loader for JN::Life;

=cut

use strict;
use warnings;
use UNIVERSAL::require;
our $VERSION = '1.00';

sub import {
  my ($class, @opts) = @_;
  my $caller  = caller();

  my $plugin_loader = sub {
    my $name = shift;
    my $module = "JN::Life::Plugin\::$name";
    $module->require or die $@;
    return $module->new();
  };

  {
    no strict 'refs'; ## no critic
    no warnings 'redefine'; ## no critic
    *{"${caller}::plugin"} = $plugin_loader;
  }
}

1;

=head1 AUTHOR

Likkradyus E<lt>perl{at}likk.jpE<gt>

=head1 SEE ALSO

JN::Life

=cut
