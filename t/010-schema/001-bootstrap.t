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

foreach my $type ( @{ Jackalope::Schema::Spec->new->valid_types } ) {
    validation_pass(
        $repo->validate(
            { '$ref' => 'schema/types/schema' },
            $repo->compiled_schemas->{'schema/types/' . $type},
        ),
        '... validate the ' . $type . ' schema with the schema type'
    );
}

validation_pass(
    $repo->validate(
        { '$ref' => 'schema/types/schema' },
        $repo->compiled_schemas->{'schema/types/schema'},
    ),
    '... validate the schema type with the schema type (bootstrappin)'
);

done_testing;