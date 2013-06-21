#!/usr/bin/perl -w
# coding: UTF-8

use v5.10;

use Test::More;
use Benchmark qw(timethese);
# ------------------------------------------------------------------------------

use constant SAMPLE_SIZE            => 30_000;
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
        push @a, int(rand(DISTANCE)) . ','. int(rand(DISTANCE));
    }
    return @a;
}
# ------------------------------------------------------------------------------
sub veclen
{
    my ($x, $y) = split(',', $_[0]);
    return sqrt($x ** 2 + $y ** 2);
}
# ------------------------------------------------------------------------------
sub sort_classic
{
    my (@a) = @_;
    my @s = sort { veclen($a) <=> veclen($b) } @a;
    return @s;
}
# ------------------------------------------------------------------------------
sub sort_om
{
    my (@a) = @_;

    my %cache;
    my @s = sort {
        ( $cache{$a} //= veclen($a) ) <=>
        ( $cache{$b} //= veclen($b) )
    } @a;

    return @s;
}
# ------------------------------------------------------------------------------
sub sort_st
{
    my (@a) = @_;

    my @s = map  { $_->[0] }
            sort { $a->[1] <=> $b->[1] }
            map  { [$_, veclen($_)] }
                 @a;

    return @s;
}
# ------------------------------------------------------------------------------
1;
__END__

Generating sample data (10000 items)...

Benchmark: timing 100 iterations of Classic, OM, ST...
   Classic: 28 wallclock secs (28.08 usr +  0.01 sys = 28.09 CPU) @  3.56/s (n=100)
        OM:  4 wallclock secs ( 3.67 usr +  0.00 sys =  3.67 CPU) @ 27.25/s (n=100)
        ST:  6 wallclock secs ( 6.06 usr +  0.01 sys =  6.07 CPU) @ 16.47/s (n=100)

Benchmark: timing 100 iterations of Classic, OM, ST...
   Classic: 28 wallclock secs (27.96 usr +  0.01 sys = 27.97 CPU) @  3.58/s (n=100)
        OM:  3 wallclock secs ( 3.50 usr +  0.01 sys =  3.51 CPU) @ 28.49/s (n=100)
        ST:  6 wallclock secs ( 5.62 usr +  0.01 sys =  5.63 CPU) @ 17.76/s (n=100)


Generating sample data (30000 items)...

Benchmark: timing 100 iterations of Classic, OM, ST...
   Classic: 90 wallclock secs (87.98 usr +  0.02 sys = 88.00 CPU) @  1.14/s (n=100)
        OM: 11 wallclock secs (10.80 usr +  0.00 sys = 10.80 CPU) @  9.26/s (n=100)
        ST: 15 wallclock secs (15.41 usr +  0.00 sys = 15.41 CPU) @  6.49/s (n=100)

Benchmark: timing 100 iterations of Classic, OM, ST...
   Classic: 87 wallclock secs (86.30 usr +  0.02 sys = 86.32 CPU) @  1.16/s (n=100)
        OM: 10 wallclock secs (10.46 usr +  0.00 sys = 10.46 CPU) @  9.56/s (n=100)
        ST: 16 wallclock secs (15.28 usr +  0.00 sys = 15.28 CPU) @  6.54/s (n=100)

Benchmark: timing 100 iterations of Classic, OM, ST...
   Classic: 91 wallclock secs (85.66 usr +  0.00 sys = 85.66 CPU) @  1.17/s (n=100)
        OM: 10 wallclock secs (10.55 usr +  0.00 sys = 10.55 CPU) @  9.48/s (n=100)
        ST: 16 wallclock secs (15.45 usr +  0.00 sys = 15.45 CPU) @  6.47/s (n=100)
