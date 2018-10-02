#!/usr/bin/perl -w
# coding: UTF-8

use v5.10;

use Test::More;
use Benchmark qw(timethese);
# ------------------------------------------------------------------------------

use constant SAMPLE_SIZE            => 40_000;
use constant BENCHMARK_ITERATIONS   => 100;

# ------------------------------------------------------------------------------
&main();
# ------------------------------------------------------------------------------
sub main
{
    say "Generating sample data (" . SAMPLE_SIZE . " items)...";
    my @a = generate_points(SAMPLE_SIZE);

    say "Checking correctness...";
    my @r1 = sort_classic(@a);
    my @r2 = sort_om(@a);
    my @r3 = sort_st(@a);
    
    exit 1 unless is_deeply(\@r1, \@r2);
    exit 1 unless is_deeply(\@r1, \@r3);
    done_testing();
    
    say "Benchmarking...";
    timethese(BENCHMARK_ITERATIONS, {
        'Classic'       => sub { sort_classic(@a) },
        'OM'            => sub { sort_om(@a) },
        'ST'            => sub { sort_st(@a) },
    });
}
# ------------------------------------------------------------------------------
sub generate_points
{
    my ($num) = @_;
    my @a = ();
    
    use constant DISTANCE => 10;

    for (1 .. $num) {
        my @elem = ();
        for (1 .. 2) {
            push @elem, rand(2 * DISTANCE) - DISTANCE;
        }
        push @a, \@elem;
    }
    return @a;
}
# ------------------------------------------------------------------------------
sub veclen
{
    return sqrt($_[0] ** 2 + $_[1] ** 2);
}
# ------------------------------------------------------------------------------
sub sort_classic
{
    my (@a) = @_;
    my @s = sort { veclen(@$a) <=> veclen(@$b) } @a;
    return @s;
}
# ------------------------------------------------------------------------------
sub sort_om
{
    my (@a) = @_;

    my %cache;
    my @s = sort {
        #( $cache{$a->[0] . ',' . $a->[1]} ||= veclen(@$a) ) <=>
        #( $cache{$b->[0] . ',' . $b->[1]} ||= veclen(@$b) )
        ( $cache{$a} ||= veclen(@$a) ) <=>
        ( $cache{$b} ||= veclen(@$b) )
    } @a;
    
    return @s;
}
# ------------------------------------------------------------------------------
sub sort_st
{
    my (@a) = @_;
    
    my @s = map  { $_->[0] }
            sort { $a->[1] <=> $b->[1] }
            map  { [$_, veclen(@$_)] }
                 @a;

    return @s;
}
# ------------------------------------------------------------------------------
1;
__END__

Generating sample data (40000 items)...

Benchmark: timing 100 iterations of Classic, OM, ST...
   Classic: 68 wallclock secs (67.36 usr +  0.04 sys = 67.40 CPU) @  1.48/s (n=100)
        OM: 54 wallclock secs (54.40 usr +  0.09 sys = 54.49 CPU) @  1.84/s (n=100)
        ST: 26 wallclock secs (25.56 usr +  0.03 sys = 25.59 CPU) @  3.91/s (n=100)
        
Benchmark: timing 100 iterations of Classic, OM, ST...
   Classic: 73 wallclock secs (72.46 usr +  0.09 sys = 72.55 CPU) @  1.38/s (n=100)
        OM: 58 wallclock secs (58.49 usr +  0.14 sys = 58.63 CPU) @  1.71/s (n=100)
        ST: 26 wallclock secs (25.84 usr +  0.03 sys = 25.87 CPU) @  3.87/s (n=100)

Benchmark: timing 100 iterations of Classic, OM, ST...
   Classic: 79 wallclock secs (78.13 usr +  0.00 sys = 78.13 CPU) @  1.28/s (n=100)
        OM: 46 wallclock secs (45.89 usr +  0.03 sys = 45.92 CPU) @  2.18/s (n=100)
        ST: 23 wallclock secs (23.24 usr +  0.00 sys = 23.24 CPU) @  4.30/s (n=100)

Benchmark: timing 100 iterations of Classic, OM, ST...
   Classic: 79 wallclock secs (77.94 usr +  0.03 sys = 77.97 CPU) @  1.28/s (n=100)
        OM: 46 wallclock secs (45.59 usr +  0.00 sys = 45.59 CPU) @  2.19/s (n=100)
        ST: 23 wallclock secs (23.17 usr +  0.00 sys = 23.17 CPU) @  4.32/s (n=100)

Benchmark: timing 100 iterations of Classic, OM, ST...
   Classic: 79 wallclock secs (78.82 usr +  0.00 sys = 78.82 CPU) @  1.27/s (n=100)
        OM: 46 wallclock secs (46.11 usr +  0.00 sys = 46.11 CPU) @  2.17/s (n=100)
        ST: 23 wallclock secs (22.98 usr +  0.00 sys = 22.98 CPU) @  4.35/s (n=100)
