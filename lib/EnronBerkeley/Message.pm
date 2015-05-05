package EnronBerkeley::Message;

use Modern::Perl;
use autodie qw(:all);
use Moo;
use Types::Path::Tiny qw/AbsFile/;
use File::Slurp::Tiny qw(read_lines);
use EnronBerkeley::Category;
use Mail::Message;

has file => ( is => 'ro', isa => AbsFile, coerce => 1 );

has mail_message => ( is => 'lazy' );
	sub _build_mail_message {
		my ($self) = @_;
		Mail::Message->read( $self->file->openr_utf8 );
	}

has _category_file => ( is => 'lazy', isa => AbsFile, coerce => 1 );
	sub _build__category_file {
		my ($self) = @_;
		$self->file =~ s/\.txt$/.cats/r;
	}

has categories => ( is => 'lazy' );
	sub _build_categories {
		my ($self) = @_;
		[ map { EnronBerkeley::Category->parse_category($_) }
			read_lines( $self->_category_file, chomp => 1 ) ];
	}

has body => ( is => 'lazy' );
	sub _build_body {
		my ($self) = @_;
		$self->mail_message->decoded->string;
	}

has body_single_line => ( is => 'lazy' );
	sub _build_body_single_line {
		my ($self) = @_;
		$self->body =~ s/\n+/ /gmr;
	}

sub FREEZE {
	my $data = {};
	$data->{$_} = $_[0]->$_ for qw(file categories body_single_line);
	$data;
}
sub THAW { __PACKAGE__->new( $_[2] ) }


1;
