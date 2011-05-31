package JN::Life::Plugin::Logger;

=head1 NAME

JN::Life::Plugin::Logger - Logging plugin for JN

=head1 SYNOPSIS

  use JN::Life::Plugin::Logger;

  $logger = JN::Life::Plugin::Logger->new();
  try {
    # anything warnings;
  }
  catch {
    $logger->warn(shift);
  };

  $logger->put;

=head1 DESCRIPTION

JN::Life::Plugin::Logger is Logging plugin for JN

=cut

use strict;
use warnings;
use autodie;
use Carp;
use Encode;
use Time::Piece;
use Try::Tiny;
use String::CamelCase qw( decamelize );

use Any::Moose;
use MooseX::Params::Validate;

=head1 Accessor

=head2 buffer

=cut


has buffer    => (
  is      => 'rw',
  isa     => 'Str',
  lazy    => 1,
  default => ''
);

=head2 level

=cut

has level    => (
  is      => 'rw',
  isa     => 'Str',
  lazy    => 1,
  default => 'error'
);

=head2 level_ref

=cut

has level_ref => (
  is      => 'rw',
  isa     => 'HashRef',
  lazy    => 1,
  default => sub {
    {
      'debug' => 50,
      'info'  => 40,
      'warn'  => 30,
      'error' => 20,
      'fatal' => 10,
      'none'  => 0,
    };
  }
);

=head2 files

=cut

has files     => (
  is => 'rw',
  isa => 'HashRef',
  lazy => 1,
  default => sub {
    return {
      path => $ENV{HOME}.'/tmp/log/',
      file => 'talk_debug.logs',
      ymd  => 1,
    };
  }
);

=head2 whereis

=cut

has whereis   => (
  is      => 'rw',
  isa     => 'Str',
  lazy    => 1,
  default => 'local'
);

=head2 test_user

=cut

has test_user   => (
  is      => 'rw',
  isa     => 'Str',
  lazy    => 1,
  default => 'hoo'
);


no Any::Moose;

=head1 METHODS

=head2 put

print log at file or standard error.

=cut


sub put {
  my $self = shift;

  my $log     = $self->buffer();
  return unless $log;
  my $files   = $self->files();
  my $whereis = 0;

  try {
    $whereis = $self->whereis;
  }
  catch{
    my $e = shift;
    warn $e;
  };

  my $suffix = '';
  if(defined $files->{ymd} and $files->{ymd} == 1){
    my $t = localtime;
    $suffix = $t->ymd("");
  }

  {
    if($ENV{USER} eq $self->test_user){
      warn $log;
    }else{
      #scorp for local
      my $path = sprintf(
        "%s%s.%s.%s",
        (
          $files->{path},
          $files->{file},
          $whereis,
          $suffix
        )
      );

      try {
        open (my $fh_wk, '>>', $path);
        print $fh_wk Encode::encode_utf8($log)."\n";
        close ($fh_wk);
      }
      catch {
        my $error = shift;
        die __PACKAGE__.' FileIOerror:'.$error;
      }
    }
  }
  $self->buffer('');
}

=head2 debug
=head2 info
=head2 warn
=head2 error
=head2 fatal

logging level.

=cut

sub debug { shift->_logging('debug', shift)}
sub info  { shift->_logging('info' , shift)}
sub warn  { shift->_logging('warn' , shift)}
sub error { shift->_logging('error', shift)}
sub fatal { shift->_logging('fatal', shift)}

=head1 PRIVATE METHODS

=over

=item B<_logging>

=cut

sub _logging {
  my $self = shift;
  my $unit_level = shift;
  my $message = shift;
  return if $self->level eq 'none';
  return if $self->_chk_level($unit_level) > 0;
  my $ymd = localtime->datetime;
  $ymd =~ tr{-T}{/ };
  my $string = sprintf("%s(%s): [%s] %s",($ymd, $self->_times(), $unit_level, $message, ));
  $self->buffer("$string");
  $self->put;
}

=item B<_chk_level>

=cut

sub _chk_level {
  my $self = shift;
  my $unit_level = shift;
  my $pgm_level = $self->level();
  my $level_ref = $self->level_ref();
  return ($level_ref->{$unit_level}||0) <=> ($level_ref->{$pgm_level}||0);
}

=item B<_clear_buffer>

=cut

sub _clear_buffer {
  my $self = shift;
  $self->buffer('');
}

=item B<_times>

=cut

sub _times {
  my ($utime,$stime,$cutime,$cstime) = times();
  my $user_time = $utime + $cutime;
  my $sys_time = $stime + $cstime;
  my $cpus_time = $user_time + $sys_time;
  return $cpus_time;
}

1;

=back

=head1 AUTHOR

Likkradyus E<lt>perl{at}likk.jpE<gt>

=head1 SEE ALSO

jo.ssena.be


