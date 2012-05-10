use strict;
use warnings;

use PHPBB::Checker;
use Test::Simple tests => 4;

my ($msg, @faults);

@faults = PHPBB::Checker::check_commit('ok');

ok(scalar @faults == 0);

@faults = PHPBB::Checker::check_commit('oneline');

ok(grep /one line/, @faults);

@faults = PHPBB::Checker::check_commit('noticket');

ok(grep /ticket reference/, @faults);

@faults = PHPBB::Checker::check_commit('nospace');

ok(grep /second line of commit message is not space/, @faults);
