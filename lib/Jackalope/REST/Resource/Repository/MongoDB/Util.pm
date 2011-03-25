package Jackalope::REST::Resource::Repository::MongoDB::Util;
use strict;
use warnings;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

use Scalar::Util qw[ blessed ];
use Data::Rmap   qw[ rmap rmap_ref ];
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

sub convert_to_booleans {
    my ($data) = @_;
    rmap_ref {
        if ((blessed($_) || '') eq 'JSON::XS::Boolean') {
            $_ = $_ == JSON::XS::true ? boolean::true() : boolean::false();
        }
    } $data;
    return $data;
}

sub convert_from_booleans {
    my ($data) = @_;
    rmap_ref {
        if ((blessed($_) || '') eq 'boolean') {
            $_ = $_ ? JSON::XS::true() : JSON::XS::false();
        }
    } $data;
    $data;
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
