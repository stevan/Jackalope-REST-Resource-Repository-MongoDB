package Jackalope::REST::Service::Target::Edit;
use Moose;

our $VERSION   = '0.01';
our $AUTHORITY = 'cpan:STEVAN';

with 'Jackalope::REST::Service::Target';

sub execute {
    my ($self, $r, @args) = @_;
    my ($resource, $error) = $self->process_operation( 'update_resource' => ( $r, @args ) );
    return $error if $error;
    return $self->process_psgi_output([ 202, [], [ $resource ] ]);
}

around 'sanitize_and_prepare_input' => sub {
    my $next = shift;
    my $self = shift;
    my $input = $self->$next( @_ );
    $self->resource_repository->resource_class->new( $input );
};

__PACKAGE__->meta->make_immutable;

no Moose; 1;

__END__

=pod

=head1 NAME

Jackalope::REST::Service::Target::Edit - A Moosey solution to this problem

=head1 SYNOPSIS

  use Jackalope::REST::Service::Target::Edit;

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