#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Jackalope;

BEGIN {
    use_ok('Jackalope');
    use_ok('Jackalope::Schema::Repository');
    use_ok('Jackalope::Schema::Spec');
}

my $repo = Jackalope::Schema::Repository->new;
isa_ok($repo, 'Jackalope::Schema::Repository');

my @pass = (
    undef,
    1,
    "two",
    3.1,
    [ 4, 5, 6 ],
    { seven => 8 }
);

foreach my $data (@pass) {
    validation_pass(
        $repo->validate( { type => 'any' }, $data ),
        '... validate against the any type'
    );
}

done_testing;