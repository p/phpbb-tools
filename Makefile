all: build/phpbb-check-branch build/phpbb-merge

build/phpbb-check-branch: build phpbb-check-branch lib/PHPBB/Git.pm lib/PHPBB/Checker.pm
	echo '#!/usr/bin/env perl' >build/phpbb-check-branch
	cat lib/PHPBB/Git.pm lib/PHPBB/Checker.pm >>build/phpbb-check-branch
	sed -e 's/^use PHPBB::.*//' <phpbb-check-branch >>build/phpbb-check-branch
	chmod +x build/phpbb-check-branch

build/phpbb-merge: build phpbb-merge lib/PHPBB/Git.pm
	echo '#!/usr/bin/env perl' >build/phpbb-merge
	cat lib/PHPBB/Git.pm >>build/phpbb-merge
	sed -e 's/^use PHPBB::.*//' <phpbb-merge >>build/phpbb-merge
	chmod +x build/phpbb-merge

build:
	mkdir -p build

test:
	PATH=tests/bin:$$PATH perl -I lib tests/determine_base.t
	PATH=tests/bin:$$PATH perl -I lib tests/phpbb-check-branch.t

buildploy: all
	mv build/phpbb-check-branch build/phpbb-merge .
	rm -r lib tests build

.PHONY: buildploy
