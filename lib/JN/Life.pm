package JN::Life;

=head1 NAME

JN::Life - Jossenabe Talking API

=head1 SYNOPSIS

  use JN::Life;

  $jn = JN::Life->new();
  $jn->talk("test");
  print $jn->res;

=head1 DESCRIPTION

JN::Life is Jossenabe Talking API.

=cut

use strict;
use warnings;
use autodie;
use utf8;
use Encode;
use Carp;
use String::CamelCase qw( decamelize );
use JN::Life::Plugin;
use JN::Life::Engine;

our $VERSION = '1.00';

use Any::Moose;

=head1 Accessor

=head2 logger

=cut

has logger    => (
  is      => 'ro',
  isa     => 'JN::Life::Plugin::Logger',
  default => sub {
    plugin('Logger');
  },
);

has engine    => (
  is      => 'ro',
  isa     => 'JN::Life::Engine',
  default => sub {
    JN::Life::Engine->new();
  },
);

has setting   => (
  is      => 'rw',
  isa     => 'HashRef',
  lazy    => 1,
  default => sub { {} },
);

=head2 hear

=cut

has hear      => (
  is      => 'rw',
  isa     => 'Str',
  lazy    => 1,
  default => ''
);

=head2 interpret

=cut

has interpret => (
  is      => 'rw',
  isa     => 'Str',
  lazy    => 1,
  default => ''
);

has user_name => (
  is      => 'rw',
  isa     => 'Str',
  lazy    => 1,
  default => ''
);

=head2 res

=cut

has res       => (
  is      => 'rw',
  isa     => 'Str',
  lazy    => 1,
  default => ''
);

has clear_val => (
  is      => 'rw',
  isa     => 'HashRef',
  lazy    => 1,
  default => sub {
    {
      res       => '',
      hear      => '',
      interpret => '',
      user_name => '',
    };
  }
);

__PACKAGE__->meta->make_immutable;
no Any::Moose;

=head1 METHODS

=head2 talk

TODO fixed these methods.

=cut

sub talk {
  my $self = shift;
  my $hear = shift || '';
  return '' unless $hear;
  $self->logger->info('set hear and interpret');

  #utf8フラグを強制的に立てる。
  $hear = Encode::decode_utf8($hear);

  $self->hear($hear);
  $self->interpret($hear);

  {
    my $assist = 'Summarize';
    #TODO:$selfを渡す必要ないかもね
    my $extracted = $self->engine->assist('Summarize')->run($self,$self->interpret);
    $self->interpret($extracted)
      if defined $self->{setting}->{engines}->{assist}->{$assist};
  }

  #メインエンジンを優先度順に実行
  my $order_main_list = $self->engine->order_main_list($self->{setting}->{engines}->{main});
  for my $talk_engine_name (@$order_main_list){
    #TODO:$selfを渡す必要ないかもね
    my $res = '';
    $res = $self->engine->main($talk_engine_name)->talk($self,$self->interpret);
    next if $res eq ''; #返事を作り出せなかったら次のエンジンへ。
    $self->logger->info('find response by '.$talk_engine_name);
    my $probability = $self->{setting}->{engines}->{main}->{$talk_engine_name}->{probability};
    if($probability < int(rand(100))){
      $self->logger->info('probability skipped at'. $talk_engine_name);
      next;
    }
    $self->res($res);
    last;
  }

}

=head2 clean

formatting temporary data

=cut

sub clean {
  my $self = shift;
  while(my($key ,$val) = each %{$self->clear_val}){
    $self->$key($val);
  }
}

=head2 ayt

are you there?

=cut

sub ayt {
  my $self = shift;
  my $hear = shift;
  if($self->has_engine(assist => 'AYT')){
    return $self->engine->assist('AYT')->run($hear);
  }
  return '';
}

=head2 has_engine

check at engine of setting.

=cut

sub  has_engine {
  my $self   = shift;
  my %params = @_;

  my ($type, $name) = each %params;
  return $self->{setting}->{engines}->{$type}->{$name} ?
    1 :
    0 ;
}

1;

=head1 AUTHOR

Likkradyus E<lt>perl{at}likk.jpE<gt>

=head1 SEE ALSO

jo.ssena.be

