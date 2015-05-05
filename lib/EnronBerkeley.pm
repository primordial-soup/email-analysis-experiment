package EnronBerkeley;

use Modern::Perl;
use Moo;
use Types::Path::Tiny qw/AbsDir/;
use Path::Iterator::Rule;

has directory => ( is => 'ro', isa => AbsDir, coerce => 1 );

has _message_iterator_rule => ( is => 'ro', default => sub {
		my $rule = Path::Iterator::Rule->new->file->min_depth(2)->name("*.txt");
	});

has _message_iterator => ( is => 'lazy' );
	sub _build__message_iterator {
		my ($self) = @_;
		$self->_message_iterator_rule->iter( $self->directory );
	}

has number_of_instances => ( is => 'lazy', );
	sub _build_number_of_instances {
		my ($self) = @_;
		$self->_message_iterator_rule->all( $self->directory );
	}

sub get_instances {

}


1;
