use inc::Module::Install;
name 'JN-Life';
all_from 'lib/JN/Life.pm';

# requires '';

tests 't/*.t';
author_tests 'xt';

test_requires 'Test::More';
auto_set_repository;
auto_include;
WriteAll;
