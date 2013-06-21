#!/usr/bin/perl -w

use strict;
use warnings;

use Benchmark;

sub get_list {
    my @list;
    for ( 0 .. 10000 ) {
        $list[$_] = rand( 100000 );
    }
    return @list;
}

#my $z1 = sub {
#    my @x = sort { $b <=> $a } get_list();
#};
#
#my $z2 = sub {
#    sort { $b <=> $a } get_list();
#};
#
#
#$z1->();
#$z2->();

my @x = sort { $b <=> $a } get_list();

sort { $b <=> $a } get_list();


#timethese(1000,
#    {
#        'reverse' => sub {
#            my @x = reverse sort { $a <=> $b } get_list();
#        },
#
#        'b_a' => sub {
#            my @x = sort { $b <=> $a } get_list();
#        },
#
#        'b_a_ns' => sub {
#            sort { $b <=> $a } get_list();
#        },
#    }
#);
