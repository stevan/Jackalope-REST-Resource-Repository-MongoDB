package Jackalope::REST::Resource::Repository::MongoDB::Util;
use strict;
use warnings;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

use Scalar::Util qw[ blessed refaddr ];
use Data::Rmap   qw[ rmap rmap_scalar ];
use boolean  ();
use JSON::XS ();

use Sub::Exporter;

my @exports = qw/
    convert_to_booleans
    convert_from_booleans
    convert_query_params
/;

Sub::Exporter::setup_exporter({
    exports => \@exports,
    groups  => { default => \@exports }
});

# NOTE:
# So, ... I kind of do something evil down
# here, Data::Rmap is a really nice module
# and actually does the job much faster then
# Data::Visitor::Callback was able to.
# However it does not re-visit any nodes
# that have already been visited, which is
# correct except that I am trying to find
# all the instance of boolean::{true,false}
# and JSON::XS::{true,false} and those are
# always going to be the same instances
# (they are constants). So this means that
# I have to futz with the Data::Rmap seen
# hash and remove the note about seeing this
# particular item so that it will get
# visited again. Believe me, I don't like it
# any more then you do, but it has to be
# done.
#
# In theory there should be no chance of
# infinity recursion, because we only delete
# the refaddr for the boolean or JSON::XS
# object and not anything else. Additionally
# there are no circular refs coming out of
# MongoDB (which is the intended usage of
# this, use it for something else and perhaps
# pay the price).
#
# Anyway, it works, so we leave it.
# - SL

sub convert_to_booleans {
    my ($data) = @_;
    rmap_scalar {
        if ((blessed($_) || '') eq 'JSON::XS::Boolean') {
            delete $_[0]->seen->{ refaddr( $_ ) } if refaddr( $_ );
            $_ = $_ == JSON::XS::true ? boolean::true() : boolean::false();
        }
    } $data;
    return $data;
}

sub convert_from_booleans {
    my ($data) = @_;
    rmap_scalar {
        if ((blessed($_) || '') eq 'boolean') {
            delete $_[0]->seen->{ refaddr( $_ ) } if refaddr( $_ );
            $_ = $_ ? JSON::XS::true() : JSON::XS::false();
        }
    } $data;
    return $data;
}

sub convert_query_params {
    my ($query) = @_;
    rmap {
        if ( $_ eq 'true' ) {
            $_ = boolean::true();
        }
        elsif ( $_ eq 'false' ) {
            $_ = boolean::false();
        }
        elsif ( Scalar::Util::looks_like_number( $_ ) ) {
            $_ = $_ + 0;
        }
        elsif ( $_ =~ /^\/(.*)\/$/ ) {
            my $regexp = $1;
            $_ = qr/$regexp/;
        }
    } $query;
    return $query;
}

1;

__END__

=pod

=head1 NAME

Jackalope::REST::Resource::Repository::MongoDB::Util - A Moosey solution to this problem

=head1 SYNOPSIS

  use Jackalope::REST::Resource::Repository::MongoDB::Util;

=head1 DESCRIPTION

=head1 METHODS

=over 4

=item B<>

=back

=head1 BUGS

All complex software has bugs lurking in it, and this module is no
exception. If you find a bug please either email me, or add the bug
to cpan-RT.

=head1 AUTHOR

Stevan Little E<lt>stevan.little@iinteractive.comE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright 2011 Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
