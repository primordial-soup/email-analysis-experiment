package EnronBerkeley::MalletHelper;

use strict;
use warnings;

use Config;
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

sub Inline {
	my ($class, $lang) = @_;
	return unless $lang eq 'Java';
	my $mallet_dir = $MALLET_PATH->parent;
	my $classpath = join $Config{path_sep}, ( $mallet_dir->child('class'), $mallet_dir->child(qw(lib mallet-deps.jar)) );
	{ AUTOSTUDY => 1, CLASSPATH => $classpath, };
}


1;
