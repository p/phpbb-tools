package PHPBB::Checker;

use strict;
use warnings;

#use Exporter;
#use vars qw/@ISA @EXPORT/;

#@ISA = qw/Exporter/;
#@EXPORT = qw/shortlog commits_in_branch head_commit check_line check_commit/;

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

sub check_line($$) {
    my ($sha, $line) = @_;
    my $length = length $line;
    if ($length >= 80) {
        print "In $sha: line is ${length} chars long: $line\n";
    }
}

sub check_commit($) {
    my ($sha) = @_;
    my @faults = ();
    open CMD, qq/git show $sha -s --pretty=medium |/;
    my (@header_lines, @message_lines) = (), ();
    my $in_header = 1;
    while (<CMD>) {
        if ($in_header) {
            if (/^$/) {
                $in_header = 0;
            } else {
                push @header_lines, $_;
            }
        } else {
            my $line;
            if (length($_) > 4) {
                $line = substr($_, 4);
            } else {
                $line = $_;
            }
            push @message_lines, $line;
        }
    }
    close CMD;
    
    if (grep /^Merge/, @header_lines) {
        # merge commit
        goto quit;
    }
    
    my $subject = $message_lines[0];
    check_line $sha, $subject;
    my $space = $message_lines[1];
    unless (defined $space) {
        push @faults, "In $sha: commit message is only one line\n";
        goto quit;
    }
    if ($space !~ /^\s*$/) {
        push @faults, "In $sha: second line of commit message is not space: $space\n";
        goto quit;
    }
    for (@message_lines) {
        check_line $sha, $_;
    }
    my $ticket_ok = 0;
    for my $line (reverse @message_lines) {
        if ($line =~ /^PHPBB3-\d+$/) {
            if ($ticket_ok) {
                print "In $sha: ticket reference too early: $line\n";
            } else {
                $ticket_ok = 1;
            }
        } elsif ($line =~ /^\s+$/) {
            # skip
        } else {
            unless ($ticket_ok) {
                push @faults, "In $sha: ticket reference missing\n";
                goto quit;
            }
        }
    }
    
    quit:
    @faults;
}

1;
