package EnronBerkeley::KFoldCrossValidation;

use strict;
use warnings;
use List::AllUtils qw(shuffle);

sub kfold_iterator {
	my ($class, $k_folds, $number_of_instances) = @_;
	my @instance_idx = 0..$number_of_instances-1;
	@instance_idx = shuffle @instance_idx;
	my @folds;
	for my $fold_num (0..$k_folds-1) {
		my $start = int($number_of_instances/$k_folds*$fold_num);
		my $stop  = int($number_of_instances/$k_folds*($fold_num+1)) - 1;
		push @folds, [ @instance_idx[ $start..$stop ] ];
	}
	my $fold_idx = 0;
	return sub {
		return if $fold_idx >= $k_folds;
		my $test = $folds[$fold_idx];
		my $train = [ map { $_ == $fold_idx ? () : @{ $folds[$_] } } 0..$k_folds-1 ];
		($train, $test, $fold_idx++);
	}
}

1;
