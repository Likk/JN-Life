package JN::Life::Util::SearchGoogle;

=head1 NAME

JN::Life::Util::SearchGoogle - google search for Jossenabe.

=head1 SYNOPSIS

  use JN::Life::Util::SearchGoogle;

  $g = JN::Life::Util::SearchGoogle->new();
  print $g->search("test");

=head1 DESCRIPTION

JN::Life::Util::SearchGoogle is google search for Jossenabe Talking API.

=cut

use strict;
use warnings;
use Carp;
use Encode;
use URI;
use Web::Scraper;
use Try::Tiny;
use parent qw/Class::Accessor::Fast/;
  __PACKAGE__->mk_accessors(qw/type/);
no parent;

=head1 Package::Global::Variable

=over

=item B<VERSION>

this package version.

=item B<splitter>
=item B<calculator>
=item B<year>
=item B<month>
=item B<day>
=item B<perhaps>
=item B<today>
=item B<tomorrow>
=item B<wave_dash>

=back

=cut

our $VERSION    = '1.00';
our $splitter   = qq{(?:。|[.,:;\n])};
our $calculator = Encode::decode_utf8 "計算：";
our $year       = Encode::decode_utf8 "年";
our $month      = Encode::decode_utf8 "月";
our $day        = Encode::decode_utf8 "日";
our $perhaps    = Encode::decode_utf8 "もしかして：";
our $today      = Encode::decode_utf8 "今日：";
our $tomorrow   = Encode::decode_utf8 "明日：";
our $wave_dash  = Encode::decode_utf8 '～';

=head1 CONSTRUCTOR AND STARTUP

=head2 new

Creates and returns a new Board object.:

=cut

sub new {
  my $class = shift;
  my %args = @_;
  bless \%args,$class;
}

=head1 METHODS

=head2 search

=cut

sub search {
  my $self = shift;

  my $res    = "";
  my $string = shift          || '';
  my $types  = $self->type    || '';
  if($string =~ m/^$calculator/){
    $string =~ s/^$calculator//;
  }

  try {
    if($types eq 'Calc'){
      $res = $self->_gcalc($string);
    }
    elsif($types eq 'Perhaps'){
      $res = $self->_gperhaps($string);
    }
    elsif($types eq 'Weather'){
      $res = $self->_gweather($string);
    }
    else{
      $res = $self->_gcalc($string);
      $res = $self->_gperhaps($string) if(!defined $res or $res eq '');
      $res = $self->_gsearch($string) if(!defined $res or $res eq '');
    }
  }
  catch {
    my $e = shift;
    warn $e;
    $res = "";
  };

  return $res;
}

=head1 PRIVATE METHODS

=over

=item B<_gcalc>

google 電卓を使う

=cut

sub _gcalc {
  my $self = shift;
  my $data = shift;
  $data =~ s/(\W)/'%' . unpack('H2', $1)/eg;
  my $url = qq|http://www.google.co.jp/search?complete=1&hl=ja&q=$data&lr=|;
  if($data){
    my $answer = scraper {
        process 'h2.r>b',price=>'TEXT';
        result qw/price priced/;
    }->scrape(URI->new($url));
    if(defined $answer->{'price'} and $answer->{'price'} ne ''){
      return "" if $answer->{'price'} !~ m{=};
      $answer->{'price'} =~ s{(\d) (\d)}{$1,$2}g;
      return $answer->{'price'};
    }
  }
  return '';
}


=item B<_gweather>

google 天気予報を使う
expect: 今日：曇のち晴 31℃, 明日：曇時々雨 19°℃～25°℃
=cut

sub _gweather {
  my $self = shift;
  my $data = Encode::encode_utf8(shift);
  $data =~ s/(\W)/'%' . unpack('H2', $1)/eg;
  my $url = qq|http://www.google.co.jp/search?complete=1&hl=ja&q=$data&lr=|;
  if($data){
    my $answer = scraper {
        process  '//tr[2]', 'block'=> scraper{
            process  '//b', 'now[]' => 'TEXT';
          result qw/now/;
        };
        process  '//table[@class="obcontainer"]/tr/td/div/table/tr/td/img',
            'after[]' => '@alt';
        process  '//table[@class="obcontainer"]/tr/td/div/table/tr/td',
            'cel[]' => 'TEXT';
        result qw/block after cel/;
    }->scrape(URI->new($url));
    return "" if !defined $answer->{block}->[0];
    return "" if !defined $answer->{after}->[0] or !defined $answer->{after}->[1];
    return "" if !defined $answer->{cel}->[18] or !defined $answer->{cel}->[19];
    my $result = $today.$answer->{after}->[0].' '.$answer->{block}->[0].'。'.
        $tomorrow.$answer->{after}->[1].' '.$answer->{cel}->[19].$wave_dash.$answer->{cel}->[18];
    $result =~ s{\|}{};
    return $result;
  }
  return "";
}

=item B<_gperhaps>

google もしかして：

=cut


sub _gperhaps {
  my $self = shift;
  my $data = Encode::encode_utf8(shift);
  $data =~ s/(\W)/'%' . unpack('H2', $1)/eg;
  my $url = qq|http://www.google.co.jp/search?complete=1&hl=ja&q=$data&lr=|;
  if($data){
    my $answer = scraper {
        process  'div#res.med>p>a.spell>b>i', perhaps=>'TEXT';
        result qw/perhaps/;
    }->scrape(URI->new($url));
    return "" if !defined $answer or $answer eq '';
    return $perhaps.$answer
  }
  return "";
}

=item B<_gsearch>

通常の検索

=cut


sub _gsearch {
  my $self = shift;
  my $data = Encode::decode_utf8(shift);
  $data .= qq{ -2ch};
  $data =~ s/(\W)/'%' . unpack('H2', $1)/eg;
  my $url = qq|http://www.google.co.jp/search?complete=1&hl=ja&q=$data&lr=|;
  if($data){
    my $answer = scraper {
        process  'li.g>div.s','subscribe[]'=>'TEXT';
        result qw/datas releve subscribe/;
    }->scrape(URI->new($url));
    return "" if ref $answer->{subscribe} ne 'ARRAY';
    return "" if scalar(@{$answer->{subscribe}}) <1;
    my $skip_pdf = Encode::decode_utf8(qq{(?:^ファイルタイプ)|(?:PDF/|HTMLバージョン)});
    my $cash     = Encode::decode_utf8(qq{(?:キャッシュ|関連ページ|メモをとる|投稿)});
    my $result = "";
LIST:    for my $num (int(rand($#{@{$answer->{subscribe}}}))..$#{@{$answer->{subscribe}}}){
      my $line = $answer->{subscribe}->[$num];
      if(defined $line and $line ne ""){
        my @sp1 = split /(\.\.\.|\n)/,$line;
BLOCK:      for my $block (@sp1){
          next LIST if $block =~ m{$skip_pdf};
          next LIST if $block =~ m{Amazon\.co\.jp};
          my @sp2 = split m{(?:$splitter|\s)},$block;
SENTENCE:        for (@sp2){
            next if $_ !~ m{[^[:ascii:]]};
            next if $_ eq "";
            next LIST if $_ =~ m{(?:\d{2,4}$year)?(?:\d{1,2}$month)+(?:\d{1,2}$day)+};
            next LIST if $_ =~ m{(?:\d{2,4}/)?(?:\d{1,2}/)+(?:\d{1,2})+};
            next LIST if $_ =~ m{$cash};
            next LIST if ($num < $#{@{$answer->{subscribe}}} and int(rand(2))==0);
            return $_
          }
        }
      }
    }
  }
  return "";
}

=back

=head1 AUTHOR

Likkradyus E<lt>perl{at}likk.jpE<gt>

=head1 SEE ALSO

google

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut


1;
