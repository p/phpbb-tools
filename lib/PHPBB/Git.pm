package PHPBB::Git;

use strict;
use warnings;

sub commits_in_branch($) {
    my ($branch) = @_;
    my @commits_in_branch = ();
    
    open CMD, qq/git log --pretty=oneline "$branch" |/;
    while (<CMD>) {
        my @parts = split ' ', $_, 2;
        my $sha = $parts[0];
        push @commits_in_branch, $sha;
    }
    close CMD;
    
    @commits_in_branch;
}

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
    my ($branch, $prefix, $branch_commits) = @_;
    my @branch_commits;
    unless (defined $prefix) {
        $prefix = '';
    }
    if (defined $branch_commits) {
        @branch_commits = @{$branch_commits};
    } else {
        @branch_commits = commits_in_branch($branch);
    }
    # Important: base list should be arranged in the same order
    # in which merges are done.
    my @bases = qw/develop-olympus develop/;
    my %base_commits = ();
    for my $base (@bases) {
        my @commits = commits_in_branch($prefix . $base);
        my %commits_hash = ();
        for (@commits) {
            $commits_hash{$_} = 1;
        }
        $base_commits{$base} = \%commits_hash;
    }
    
    for my $sha (@branch_commits) {
        for my $base (@bases) {
            if ($base_commits{$base}->{$sha}) {
                return $prefix . $base;
            }
        }
    }
    undef;
}

1;
