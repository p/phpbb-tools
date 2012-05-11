use strict;
use warnings;

use PHPBB::Git;
use Test::Simple tests => 4;

my $base;

$base = PHPBB::Git::determine_base('d-foo');

ok(defined $base);
ok($base eq 'develop');

$base = PHPBB::Git::determine_base('d-o-bar');

ok(defined $base);
ok($base eq 'develop-olympus');
