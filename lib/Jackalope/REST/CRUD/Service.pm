package Jackalope::REST::CRUD::Service;
use Moose;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

with 'Jackalope::REST::Service',
     'Jackalope::REST::Service::Role::WithRouter';

has 'schema'          => ( is => 'ro', isa => 'HashRef', required => 1 );
has 'compiled_schema' => (
    is      => 'ro',
    lazy    => 1,
    default => sub {
        my $self = shift;
        $self->schema_repository->register_schema( $self->schema )
    }
);

has 'resource_repository' => (
    is       => 'ro',
    does     => 'Jackalope::REST::Resource::Repository',
    required => 1
);

sub get_all_linkrels { (shift)->compiled_schema->{'links'} }

{
    my %REL_TO_TARGET_CLASS = (
        create      => 'Jackalope::REST::CRUD::Service::Target::Create',
        edit        => 'Jackalope::REST::CRUD::Service::Target::Update',
        list        => 'Jackalope::REST::CRUD::Service::Target::List',
        read        => 'Jackalope::REST::CRUD::Service::Target::Read',
        delete      => 'Jackalope::REST::CRUD::Service::Target::Delete',
        describedby => 'Jackalope::REST::Service::Target::DescribedBy',
    );

    around 'get_linkrels_to_target_map' => sub {
        my $next = shift;
        my $self = shift;
        return +{
            %REL_TO_TARGET_CLASS,
            %{ $self->$next() }
        }
    };
}

sub generate_read_link_for_resource {
    my ($self, $resource) = @_;
    $self->router->uri_for( 'read' => { id => $resource->id } )->{'href'};
}

sub generate_links_for_resource {
    my ($self, $resource) = @_;
    $resource->add_links(
        map {
            $self->router->uri_for(
                $_->{'rel'},
                (exists $_->{'uri_schema'}
                    ? { id => $resource->id }
                    : {} )
            )
        } sort {
            $a->{rel} cmp $b->{rel}
        } values %{ $self->compiled_schema->{'links'} }
    );
}

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

=pod

=head1 NAME

Jackalope::REST::CRUD::Service - A Moosey solution to this problem

=head1 SYNOPSIS

  use Jackalope::REST::CRUD::Service;

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

Copyright 2010 Infinity Interactive, Inc.

L<http://www.iinteractive.com>

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
