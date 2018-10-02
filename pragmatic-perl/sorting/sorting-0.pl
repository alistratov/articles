#!/usr/bin/perl -w
# coding: UTF-8

use v5.10;

# ------------------------------------------------------------------------------

#use sort 'stable';	# guarantee stability
#use sort '_quicksort';	# use a quicksort algorithm
#use sort '_mergesort';	# use a mergesort algorithm
#use sort 'defaults';	# revert to default behavior
#no sort 'stable';	# stability not important
#use sort '_qsort';	# alias for quicksort

use sort qw(stable);

use Data::Dumper;

my $current;

BEGIN {
    $current = sort::current();	# identify prevailing algorithm
}
    
# ------------------------------------------------------------------------------
&main();
# ------------------------------------------------------------------------------
sub main
{
    say "Sorting: " . Dumper($current);
}
# ------------------------------------------------------------------------------
1;
