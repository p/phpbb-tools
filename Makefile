all: build/phpbb-check-branch

build/phpbb-check-branch: build phpbb-check-branch lib/PHPBB/Checker.pm
	echo '#!/usr/bin/env perl' >build/phpbb-check-branch
	cat lib/PHPBB/Git.pm lib/PHPBB/Checker.pm >>build/phpbb-check-branch
	sed -e 's/^use PHPBB::.*//' <phpbb-check-branch >>build/phpbb-check-branch
	chmod +x build/phpbb-check-branch

build:
	mkdir -p build

test:
	PATH=tests/bin:$$PATH perl -I lib tests/phpbb-check-branch.t
