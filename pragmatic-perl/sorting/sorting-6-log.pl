#!/usr/bin/perl -w
# coding: UTF-8

use v5.10;

# ------------------------------------------------------------------------------

use constant SAMPLE_SIZE            => 1000;

# ------------------------------------------------------------------------------
&main();
# ------------------------------------------------------------------------------
sub main
{
    say "Generating sample data (" . SAMPLE_SIZE . " items)...";
    my @a = generate_numbers(SAMPLE_SIZE);

    my $i = 0;

    my @sorted = sort {
                    $i++;
                    $a <=> $b;
                 } @a;

    say "Items: " . SAMPLE_SIZE;
    say "Comparisons: " . $i;
}
# ------------------------------------------------------------------------------
sub generate_numbers
{
    my ($num) = @_;
    my @a = ();

    for (1 .. $num) {
        push @a, int(rand(SAMPLE_SIZE));
    }
    return @a;
}
# ------------------------------------------------------------------------------
1;
__END__
