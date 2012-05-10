use strict;
use warnings;

use PHPBB::Checker;
use Test::Simple tests => 7;

my ($msg, @faults);

@faults = PHPBB::Checker::check_commit('ok');

ok(scalar @faults == 0);

@faults = PHPBB::Checker::check_commit('oneline');

ok(grep /one line/, @faults);

@faults = PHPBB::Checker::check_commit('noticket');

ok(grep /ticket reference missing/, @faults);

@faults = PHPBB::Checker::check_commit('noticket2');

ok(grep /is not mentioned in commit message footer/, @faults);

@faults = PHPBB::Checker::check_commit('nospace');

ok(grep /second line of commit message is not space/, @faults);

@faults = PHPBB::Checker::check_commit('subjectborked');

ok(grep /message subject has incorrect prefix/, @faults);

@faults = PHPBB::Checker::check_commit('longline');

ok(grep /line is .* chars long/, @faults);
