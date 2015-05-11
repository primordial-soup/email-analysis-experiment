package EnronBerkeley::LIBSVMHelper;

use strict;
use warnings;

use Config;
use Env qw(@PATH);
use autodie qw(:all);
use EnronBerkeley::ProjectHelper;

our $LIBSVM_PATH;
our $LIBSVM_VERSION;

BEGIN {
	my $toplevel_path = EnronBerkeley::ProjectHelper->top_level_directory_path;

	$LIBSVM_VERSION = "3.20";
	$LIBSVM_PATH = $toplevel_path->child( qw(dep libsvm), "libsvm-$LIBSVM_VERSION" );
	die "LIBSVM is not installed in $LIBSVM_PATH" unless -d $LIBSVM_PATH;

	## Add path to LIBSVM binaries to $ENV{PATH}
	push @PATH, "$LIBSVM_PATH";
}

1;
