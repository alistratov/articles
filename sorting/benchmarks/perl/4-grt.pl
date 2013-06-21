#!/usr/bin/perl -w
# coding: UTF-8

use v5.10;

use Test::More;
use Benchmark qw(timethese);
# ------------------------------------------------------------------------------

use constant SAMPLE_SIZE            => 100_000;
use constant BENCHMARK_ITERATIONS   => 100;

# ------------------------------------------------------------------------------
&main();
# ------------------------------------------------------------------------------
sub main
{
    say "Generating sample data (" . SAMPLE_SIZE . " items)...";
    my @a = generate_triplets(SAMPLE_SIZE);

    say "Checking correctness...";
    my @r1 = sort_classic(@a);
    my @r2 = sort_arithmetic(@a);
    my @r3 = sort_pack(@a);
    my @r4 = sort_bitfields(@a);

    exit 1 unless is_deeply(\@r1, \@r2);
    exit 1 unless is_deeply(\@r1, \@r3);
    exit 1 unless is_deeply(\@r1, \@r4);
    done_testing();

    say "Benchmarking...";
    timethese(BENCHMARK_ITERATIONS, {
        'Classic'       => sub { sort_classic(@a) },
        'GRT-Arithm'    => sub { sort_arithmetic(@a) },
        'GRT-Pack'      => sub { sort_pack(@a) },
        'GRT-Bits'      => sub { sort_bitfields(@a) },
    });
}
# ------------------------------------------------------------------------------
sub generate_triplets
{
    my ($num) = @_;
    my @a = ();

    for (1 .. $num) {
        my @elem = ();
        for (1 .. 3) {
            push @elem, int(rand(100));
        }
        push @a, \@elem;
    }
    return @a;
}
# ------------------------------------------------------------------------------
sub sort_classic
{
    my (@a) = @_;

    my @s = sort {
        $a->[0] <=> $b->[0] ||
        $a->[1] <=> $b->[1] ||
        $a->[2] <=> $b->[2]
    } @a;

    return @s;
}
# ------------------------------------------------------------------------------
sub sort_arithmetic
{
    my (@a) = @_;

    # Pack into hundreds, compare numerically
    my @s = map  { my $x = int($_ / 100**2); my $y = int($_ / 100) - $x * 100; my $z = $_ % 100; [ $x, $y, $z ]; }
            sort { $a <=> $b }
            map  { $_->[0] * 100**2 + $_->[1] * 100 + $_->[2] }
            @a;

    return @s;
}
# ------------------------------------------------------------------------------
sub sort_pack
{
    my (@a) = @_;

    # Pack into bytes, compare lexicographically
    my @s = map  { [ unpack "C3", $_ ] }
            sort
            map  { pack "C3", @$_ }
            @a;

    return @s;
}
# ------------------------------------------------------------------------------
sub sort_bitfields
{
    my (@a) = @_;

    # Pack each element in 7 bits, compare numerically
    my @s = map  { [ ($_ & 0b1111111_0000000_0000000) >> 14, ($_ & 0b1111111_0000000) >> 7, $_ & 0b1111111 ] }
            sort { $a <=> $b }
            map  { ($_->[0] << 14) | ($_->[1] << 7) | $_->[2] }
            @a;

    return @s;
}
# ------------------------------------------------------------------------------
1;
__END__

Generating sample data (100000 items)...

Benchmark: timing 100 iterations of Classic, GRT-Arithm, GRT-Bits, GRT-Pack...
   Classic: 66 wallclock secs (64.94 usr +  0.08 sys = 65.02 CPU) @  1.54/s (n=100)
GRT-Arithm: 28 wallclock secs (28.16 usr +  0.04 sys = 28.20 CPU) @  3.55/s (n=100)
  GRT-Bits: 21 wallclock secs (21.50 usr +  0.03 sys = 21.53 CPU) @  4.64/s (n=100)
  GRT-Pack: 52 wallclock secs (51.27 usr +  0.12 sys = 51.39 CPU) @  1.95/s (n=100)

Benchmark: timing 100 iterations of Classic, GRT-Arithm, GRT-Bits, GRT-Pack...
   Classic: 66 wallclock secs (66.47 usr +  0.09 sys = 66.56 CPU) @  1.50/s (n=100)
GRT-Arithm: 30 wallclock secs (29.04 usr +  0.05 sys = 29.09 CPU) @  3.44/s (n=100)
  GRT-Bits: 21 wallclock secs (21.83 usr +  0.03 sys = 21.86 CPU) @  4.57/s (n=100)
  GRT-Pack: 52 wallclock secs (51.56 usr +  0.13 sys = 51.69 CPU) @  1.93/s (n=100)

Benchmark: timing 100 iterations of Classic, GRT-Arithm, GRT-Bits, GRT-Pack...
   Classic: 75 wallclock secs (74.52 usr +  0.01 sys = 74.53 CPU) @  1.34/s (n=100)
GRT-Arithm: 31 wallclock secs (31.40 usr +  0.01 sys = 31.41 CPU) @  3.18/s (n=100)
  GRT-Bits: 24 wallclock secs (24.01 usr +  0.02 sys = 24.03 CPU) @  4.16/s (n=100)
  GRT-Pack: 45 wallclock secs (44.73 usr +  0.01 sys = 44.74 CPU) @  2.24/s (n=100)

   Classic: 87 wallclock secs (74.80 usr +  0.00 sys = 74.80 CPU) @  1.34/s (n=100)
GRT-Arithm: 31 wallclock secs (30.92 usr +  0.01 sys = 30.93 CPU) @  3.23/s (n=100)
  GRT-Bits: 25 wallclock secs (25.18 usr +  0.00 sys = 25.18 CPU) @  3.97/s (n=100)
  GRT-Pack: 46 wallclock secs (45.37 usr +  0.00 sys = 45.37 CPU) @  2.20/s (n=100)
