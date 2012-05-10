use strict;
use warnings;

use PHPBB::Checker;
use Test::Simple tests => 1;

my ($msg, @faults);

@faults = PHPBB::Checker::check_commit('ok');

ok(scalar @faults == 0);
