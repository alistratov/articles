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
    my @a = generate_data(SAMPLE_SIZE);

    say "Checking correctness...";
    
    my @r1 = sort_asc(@a);
    my @r2 = sort_desc(@a);
    my @r3 = sort_desc_minus(@a);
    my @r4 = sort_desc_reverse(@a);
    
    my @r5 = sort_lex_asc(@a);
    my @r6 = sort_lex_desc(@a);
    my @r7 = sort_lex_desc_minus(@a);
    my @r8 = sort_lex_desc_reverse(@a);
    
    exit 1 unless is_deeply(\@r1, [ reverse(@r2) ]);
    exit 1 unless is_deeply(\@r1, [ reverse(@r3) ]);
    exit 1 unless is_deeply(\@r1, [ reverse(@r4) ]);
    exit 1 unless is_deeply(\@r5, [ reverse(@r6) ]);
    exit 1 unless is_deeply(\@r5, [ reverse(@r7) ]);
    exit 1 unless is_deeply(\@r5, [ reverse(@r8) ]);
    done_testing();
    
    say "Benchmarking...";
    timethese(BENCHMARK_ITERATIONS, {
        'NUM ASC'        => sub { sort_asc(@a) },
        'NUM DESC'       => sub { sort_desc(@a) },
        'NUM DESC MINUS' => sub { sort_desc_minus(@a) },
        'NUM DESC REV'   => sub { sort_desc_reverse(@a) },
        'LEX ASC'        => sub { sort_lex_asc(@a) },
        'LEX DESC'       => sub { sort_lex_desc(@a) },
        'LEX DESC MINUS' => sub { sort_lex_desc_minus(@a) },
        'LEX DESC REV'   => sub { sort_lex_desc_reverse(@a) },
    });
}
# ------------------------------------------------------------------------------
sub generate_data
{
    my ($num) = @_;
    my @a = ();

    for (1 .. $num) {
        push @a, int(rand(SAMPLE_SIZE / 2));
    }
    return @a;
}
# ------------------------------------------------------------------------------
sub sort_asc
{
    my (@a) = @_;
    my @s = sort { $a <=> $b } @a;
    return @s;
}
# ------------------------------------------------------------------------------
sub sort_desc
{
    my (@a) = @_;
    my @s = sort { $b <=> $a } @a;
    return @s;
}
# ------------------------------------------------------------------------------
sub sort_desc_minus
{
    my (@a) = @_;
    my @s = sort { -($a <=> $b) } @a;
    return @s;
}
# ------------------------------------------------------------------------------
sub sort_desc_reverse
{
    my (@a) = @_;
    my @s = sort { $a <=> $b } @a;
    return reverse(@s);
}
# ------------------------------------------------------------------------------
sub sort_lex_asc
{
    my (@a) = @_;
    my @s = sort @a;
    return @s;
}
# ------------------------------------------------------------------------------
sub sort_lex_desc
{
    my (@a) = @_;
    my @s = sort { $b cmp $a } @a;
    return @s;
}
# ------------------------------------------------------------------------------
sub sort_lex_desc_minus
{
    my (@a) = @_;
    my @s = sort { -($a cmp $b) } @a;
    return @s;
}
# ------------------------------------------------------------------------------
sub sort_lex_desc_reverse
{
    my (@a) = @_;
    my @s = sort @a;
    return reverse(@s);
}
# ------------------------------------------------------------------------------
1;
__END__

Generating sample data (100000 items)...

Benchmark: timing 100 iterations of LEX ASC, LEX DESC, LEX DESC MINUS, LEX DESC REV, NUM ASC, NUM DESC, NUM DESC MINUS, NUM DESC REV...
   LEX ASC: 18 wallclock secs (17.49 usr +  0.09 sys = 17.58 CPU) @  5.69/s (n=100)
  LEX DESC: 18 wallclock secs (17.92 usr +  0.10 sys = 18.02 CPU) @  5.55/s (n=100)
LEX DESC MINUS: 30 wallclock secs (29.88 usr +  0.10 sys = 29.98 CPU) @  3.34/s (n=100)
LEX DESC REV: 19 wallclock secs (18.93 usr +  0.11 sys = 19.04 CPU) @  5.25/s (n=100)
   NUM ASC:  6 wallclock secs ( 5.81 usr +  0.01 sys =  5.82 CPU) @ 17.18/s (n=100)
  NUM DESC:  6 wallclock secs ( 5.63 usr +  0.01 sys =  5.64 CPU) @ 17.73/s (n=100)
NUM DESC MINUS: 18 wallclock secs (18.14 usr +  0.02 sys = 18.16 CPU) @  5.51/s (n=100)
NUM DESC REV:  8 wallclock secs ( 7.99 usr +  0.01 sys =  8.00 CPU) @ 12.50/s (n=100)

Benchmark: timing 100 iterations of LEX ASC, LEX DESC, LEX DESC MINUS, LEX DESC REV, NUM ASC, NUM DESC, NUM DESC MINUS, NUM DESC REV...
   LEX ASC: 18 wallclock secs (17.54 usr +  0.09 sys = 17.63 CPU) @  5.67/s (n=100)
  LEX DESC: 18 wallclock secs (18.16 usr +  0.11 sys = 18.27 CPU) @  5.47/s (n=100)
LEX DESC MINUS: 32 wallclock secs (31.57 usr +  0.12 sys = 31.69 CPU) @  3.16/s (n=100)
LEX DESC REV: 21 wallclock secs (21.37 usr +  0.13 sys = 21.50 CPU) @  4.65/s (n=100)
   NUM ASC:  6 wallclock secs ( 5.49 usr +  0.00 sys =  5.49 CPU) @ 18.21/s (n=100)
  NUM DESC:  5 wallclock secs ( 5.39 usr +  0.01 sys =  5.40 CPU) @ 18.52/s (n=100)
NUM DESC MINUS: 18 wallclock secs (17.76 usr +  0.01 sys = 17.77 CPU) @  5.63/s (n=100)
NUM DESC REV:  8 wallclock secs ( 7.93 usr +  0.01 sys =  7.94 CPU) @ 12.59/s (n=100)

Benchmark: timing 100 iterations of LEX ASC, LEX DESC, LEX DESC MINUS, LEX DESC REV, NUM ASC, NUM DESC, NUM DESC MINUS, NUM DESC REV...
   LEX ASC: 16 wallclock secs (15.48 usr +  0.01 sys = 15.49 CPU) @  6.46/s (n=100)
  LEX DESC: 15 wallclock secs (15.23 usr +  0.02 sys = 15.25 CPU) @  6.56/s (n=100)
LEX DESC MINUS: 26 wallclock secs (26.32 usr +  0.00 sys = 26.32 CPU) @  3.80/s (n=100)
LEX DESC REV: 16 wallclock secs (16.05 usr +  0.00 sys = 16.05 CPU) @  6.23/s (n=100)
   NUM ASC:  4 wallclock secs ( 4.75 usr +  0.00 sys =  4.75 CPU) @ 21.05/s (n=100)
  NUM DESC:  5 wallclock secs ( 4.83 usr +  0.00 sys =  4.83 CPU) @ 20.70/s (n=100)
NUM DESC MINUS: 16 wallclock secs (16.05 usr +  0.00 sys = 16.05 CPU) @  6.23/s (n=100)
NUM DESC REV:  7 wallclock secs ( 6.90 usr +  0.00 sys =  6.90 CPU) @ 14.49/s (n=100)

Benchmark: timing 100 iterations of LEX ASC, LEX DESC, LEX DESC MINUS, LEX DESC REV, NUM ASC, NUM DESC, NUM DESC MINUS, NUM DESC REV...
   LEX ASC: 15 wallclock secs (15.03 usr +  0.00 sys = 15.03 CPU) @  6.65/s (n=100)
  LEX DESC: 16 wallclock secs (15.31 usr +  0.01 sys = 15.32 CPU) @  6.53/s (n=100)
LEX DESC MINUS: 28 wallclock secs (26.63 usr +  0.02 sys = 26.65 CPU) @  3.75/s (n=100)
LEX DESC REV: 15 wallclock secs (15.67 usr +  0.01 sys = 15.68 CPU) @  6.38/s (n=100)
   NUM ASC:  5 wallclock secs ( 4.76 usr +  0.00 sys =  4.76 CPU) @ 21.01/s (n=100)
  NUM DESC:  5 wallclock secs ( 4.82 usr +  0.00 sys =  4.82 CPU) @ 20.75/s (n=100)
NUM DESC MINUS: 19 wallclock secs (18.96 usr +  0.00 sys = 18.96 CPU) @  5.27/s (n=100)
NUM DESC REV:  8 wallclock secs ( 7.41 usr +  0.00 sys =  7.41 CPU) @ 13.50/s (n=100)
