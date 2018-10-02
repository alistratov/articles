#!/usr/bin/perl -w
# coding: UTF-8

use v5.10;

use Benchmark qw(:all);
use Data::Dumper;

    
# ------------------------------------------------------------------------------
&main();
# ------------------------------------------------------------------------------
sub main
{
    my @a = generate();
    #say "Original: " . Dumper(\@a);
    #print_a2('Orig', @a);
    #my @c = sort_classic(@a);
    #print_a2('Classic', @c);
    #my @g = sort_grt(@a);
    #print_a2('GRT', @g);
    #my @x = sort_grt_cmp(@a);
    #print_a2('GRT_CMP', @x);
    
    timethese(100, {
        'Classic'   => sub { sort_classic(@a) },
        'GRT'       => sub { sort_grt(@a) },
        'GRT-CMP'   => sub { sort_grt_cmp(@a) },
    });
 
}
# ------------------------------------------------------------------------------
sub generate
{
    my $N = 100_000;
    my $T = 3;
    
    my @x = ();
    for (1 .. $N) {
        my @elem = ();
        for (1 .. $T) {
            push @elem, int(rand(100));
        }
        push @x, \@elem;
    }
    
    return @x;
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
sub sort_grt
{
    my (@a) = @_;
    
    #my @s = map  { my $x2 = $_ % 100; my $x0 = int($_ / 100**2); my $x1 = ($_ / 100) - $x0 * 100; [ $x0, $x1, $x2 ]; }
    #        sort { $a <=> $b }
    #        map  { my $a = $_->[0] * 100**2 + $_->[1] * 100 + $_->[2]; print "$a "; $a; }
    #        @a;
    
    my @s = map  { $x = int($_ / 100**2); $y = int($_ / 100) - $x * 100; $z = $_ % 100; [ $x, $y, $z ]; }
            sort { $a <=> $b }
            map  { $_->[0] * 100**2 + $_->[1] * 100 + $_->[2] }
            @a;
            
    #my @s = map  { my $x0 = int($_ / 100**2); my $x1 = int($_ / 100) - $x0 * 100; my $x2 = $_ % 100; [ $x0, $x1, $x2 ]; }
    #        sort { $a <=> $b }
    #        map  { $_->[0] * 100**2 + $_->[1] * 100 + $_->[2] }
    #        @a;

    return @s;
}
# ------------------------------------------------------------------------------
sub sort_grt_cmp
{
    my (@a) = @_;
    
    my @s = map  { [ unpack "C3", $_ ] }
            sort
            map  { pack "C3", @$_ }
            @a;

    return @s;
}
# ------------------------------------------------------------------------------
sub print_a2
{
    my ($title, @x) = @_;
    
    print "-- $title:\n";
    
    for my $i (@x) {
        for my $j (@$i) {
            print sprintf("%5d", $j);
        }
        print "\n";
    }
    print "\n";
}
# ------------------------------------------------------------------------------
1;
__END__

[16:16:05]  wmute@wmute.local:~/Projects/articles/pragmatic-perl/sorting% ./sorting-1-grt.pl
Benchmark: timing 100 iterations of Classic, GRT...
   Classic:  3 wallclock secs ( 3.63 usr +  0.00 sys =  3.63 CPU) @ 27.55/s (n=100)
       GRT:  3 wallclock secs ( 2.42 usr +  0.01 sys =  2.43 CPU) @ 41.15/s (n=100)
[16:17:38]  wmute@wmute.local:~/Projects/articles/pragmatic-perl/sorting% ./sorting-1-grt.pl
Benchmark: timing 1000 iterations of Classic, GRT...
   Classic: 592 wallclock secs (590.67 usr +  0.44 sys = 591.11 CPU) @  1.69/s (n=1000)
       GRT: 276 wallclock secs (274.64 usr +  0.84 sys = 275.48 CPU) @  3.63/s (n=1000)
[16:32:25]  wmute@wmute.local:~/Projects/articles/pragmatic-perl/sorting% ./sorting-1-grt.pl
Benchmark: timing 100 iterations of Classic, GRT...
   Classic: 63 wallclock secs (63.25 usr +  0.08 sys = 63.33 CPU) @  1.58/s (n=100)
       GRT: 28 wallclock secs (27.36 usr +  0.11 sys = 27.47 CPU) @  3.64/s (n=100)
[16:44:08]  wmute@wmute.local:~/Projects/articles/pragmatic-perl/sorting% ./sorting-1-grt.pl
Benchmark: timing 100 iterations of Classic, GRT...
   Classic: 66 wallclock secs (65.80 usr +  0.10 sys = 65.90 CPU) @  1.52/s (n=100)
       GRT: 29 wallclock secs (28.70 usr +  0.13 sys = 28.83 CPU) @  3.47/s (n=100)
[16:51:50]  wmute@wmute.local:~/Projects/articles/pragmatic-perl/sorting% ./sorting-1-grt.pl
Benchmark: timing 100 iterations of Classic, GRT...
   Classic: 67 wallclock secs (66.99 usr +  0.12 sys = 67.11 CPU) @  1.49/s (n=100)
       GRT: 29 wallclock secs (28.52 usr +  0.14 sys = 28.66 CPU) @  3.49/s (n=100)


[16:59:33]  wmute@wmute.local:~/Projects/articles/pragmatic-perl/sorting% ./sorting-1-grt.pl
Benchmark: timing 100 iterations of Classic, GRT, GRT-CMP...
   Classic: 67 wallclock secs (67.24 usr +  0.11 sys = 67.35 CPU) @  1.48/s (n=100)
       GRT: 28 wallclock secs (27.26 usr +  0.11 sys = 27.37 CPU) @  3.65/s (n=100)
   GRT-CMP: 53 wallclock secs (52.76 usr +  0.20 sys = 52.96 CPU) @  1.89/s (n=100)
[17:02:28]  wmute@wmute.local:~/Projects/articles/pragmatic-perl/sorting% ./sorting-1-grt.pl
Benchmark: timing 100 iterations of Classic, GRT, GRT-CMP...
   Classic: 63 wallclock secs (63.17 usr +  0.09 sys = 63.26 CPU) @  1.58/s (n=100)
       GRT: 27 wallclock secs (26.80 usr +  0.11 sys = 26.91 CPU) @  3.72/s (n=100)
   GRT-CMP: 52 wallclock secs (51.10 usr +  0.21 sys = 51.31 CPU) @  1.95/s (n=100)
[17:55:30]  wmute@wmute.dev.tools.yandex.net:~/grt-sorting$ ./sorting-1-grt.pl
Benchmark: timing 100 iterations of Classic, GRT, GRT-CMP...
   Classic: 73 wallclock secs (64.68 usr +  0.00 sys = 64.68 CPU) @  1.55/s (n=100)
       GRT: 27 wallclock secs (27.21 usr +  0.00 sys = 27.21 CPU) @  3.68/s (n=100)
   GRT-CMP: 40 wallclock secs (40.26 usr +  0.00 sys = 40.26 CPU) @  2.48/s (n=100)
[18:02:25]  wmute@wmute.dev.tools.yandex.net:~/grt-sorting$ ./sorting-1-grt.pl
Benchmark: timing 100 iterations of Classic, GRT, GRT-CMP...
   Classic: 65 wallclock secs (64.70 usr +  0.05 sys = 64.75 CPU) @  1.54/s (n=100)
       GRT: 29 wallclock secs (27.50 usr +  0.01 sys = 27.51 CPU) @  3.64/s (n=100)
   GRT-CMP: 40 wallclock secs (39.88 usr +  0.03 sys = 39.91 CPU) @  2.51/s (n=100)

