#!/usr/bin/perl

use strict;
use warnings;

use Test::More;
use Test::Fatal;
use Test::Moose;
use Test::Jackalope::REST::ResourceRepositoryTestSuite;

use Try::Tiny;

BEGIN {
    use_ok('Jackalope');
    use_ok('Jackalope::REST::Resource::Repository::MongoDB');
}

my $mongo = try {
    MongoDB::Connection->new( host => 'localhost', port => 27017 );
} catch {
    diag('... no MongoDB instance to connect too');
    done_testing();
    exit();
};

# get rid of any old DBs
$mongo->get_database('jackalope-test')->drop;

my $db    = $mongo->get_database('jackalope-test');
my $coll  = $db->get_collection('resources');

my $repo = Jackalope::REST::Resource::Repository::MongoDB->new( collection => $coll );

Test::Jackalope::REST::ResourceRepositoryTestSuite->new(
    fixtures => [
        { body => { foo => 'bar'   } },
        { body => { bar => 'baz'   } },
        { body => { baz => 'gorch' } },
        { body => { gorch => 'foo' } },
    ],
    id_callback => sub {
        my ($tester, $repo) = @_;

        # grab all the IDs we just created ...
        my @ids = map {
            $_->{_id}->value;
        } $repo->collection->find->all;

        # add them to the fixtures
        foreach my $fixture ( @{ $tester->fixtures } ) {
            $fixture->{id} = shift @ids;
        }

        # make sure to sort the fixtures now
        $tester->sort_fixtures(sub {
            $_[0]->{id} cmp $_[1]->{id}
        });
    }
)->run_all_tests( $repo );

$mongo->get_database('jackalope-test')->drop;

done_testing;




