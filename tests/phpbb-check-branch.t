use strict;
use warnings;

use PHPBB::Checker;
use Test::Simple tests => 2;

my ($msg, @faults);

@faults = PHPBB::Checker::check_commit('ok');

ok(scalar @faults == 0);

@faults = PHPBB::Checker::check_commit('oneline');

ok(grep /one line/, @faults);
