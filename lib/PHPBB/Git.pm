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

sub determine_base($) {
    my ($branch, $prefix, $branch_commits, $branch_meta) = @_;
    unless (defined $prefix) {
        $prefix = '';
    }
    unless (defined $branch_commits) {
        ($branch_commits, $branch_meta) = shortlog($branch);
    }
    my @branch_commits = @{$branch_commits};
    my @bases = qw/develop develop-olympus/;
    my %base_commits = ();
    for my $base (@bases) {
        $base_commits{$base} = head_commit($prefix . $base);
    }
    
    for my $sha (@branch_commits) {
        for my $base (@bases) {
            my $base_commit = $base_commits{$base};
            if ($sha eq $base_commit) {
                return $prefix . $base;
            }
        }
    }
    undef;
}

1;
