use Test::More;
eval q{ use Test::Spelling };
plan skip_all => "Test::Spelling is not installed." if $@;
add_stopwords(map { split /[\s\:\-]/ } <DATA>);
$ENV{LANG} = 'C';
all_pod_files_spelling_ok('lib');
__DATA__
Likkradyus
perl{at}likk.jp
JN::Life
API
jossenabe
jo
ssena
be
google
STARTUP
TODO
whereis
conf
cpan
ayt
wassr
