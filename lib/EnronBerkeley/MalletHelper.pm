package EnronBerkeley::MalletHelper;

use strict;
use warnings;

use Env qw(@PATH);
use autodie qw(:all);
use EnronBerkeley::ProjectHelper;

our $MALLET_PATH;
BEGIN {
	my $toplevel_path = EnronBerkeley::ProjectHelper->top_level_directory_path;

	$MALLET_PATH = $toplevel_path->child( qw(dep Mallet bin) );
	die "Mallet is not installed in $MALLET_PATH" unless -d $MALLET_PATH;

	## Add path to mallet script to $ENV{PATH}
	push @PATH, "$MALLET_PATH";
}

sub run_mallet {
	my ($self, @rest) = @_;
	system( qw(mallet), @rest);
}


1;
