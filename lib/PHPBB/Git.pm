package PHPBB::Git;

use strict;
use warnings;

sub shortlog($) {
    my ($branch) = @_;
    my @commits_in_branch = ();
    my %meta = ();
    
    open CMD, qq/git log --pretty=oneline "$branch" |/;
    while (<CMD>) {
        my @parts = split ' ', $_, 2;
        my $sha = $parts[0];
        push @commits_in_branch, $sha;
        $meta{$sha} = $parts[1];
    }
    close CMD;
    
    (\@commits_in_branch, \%meta);
}

sub commits_in_branch($) {
    my ($commits_in_branch, $meta) = shortlog($_[0]);
    @{$commits_in_branch};
}

sub head_commit($) {
    my ($branch) = @_;
    my $head_commit;
    
    open CMD, qq/git log --pretty=oneline -1 "$branch" |/;
    while (<CMD>) {
        my @parts = split ' ';
        $head_commit = $parts[0];
    }
    close CMD;
    
    $head_commit;
}

1;
