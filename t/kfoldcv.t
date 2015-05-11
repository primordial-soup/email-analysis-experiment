use Test::More tests => 1;

use strict;
use warnings;

use List::AllUtils qw(uniq);
use Set::Scalar;
use EnronBerkeley::KFoldCrossValidation;


subtest "3-fold on 9 instances" => sub {
	my $N = 9;
	my $k = 3;
	my $cv_it = EnronBerkeley::KFoldCrossValidation->kfold_iterator( $k, $N );
	my $fold = 0;
	while( my ($train, $test) = $cv_it->() ) {
		my @both = (@$train, @$test);
		my $train_set = Set::Scalar->new( @$train );
		my $test_set = Set::Scalar->new( @$test );
		cmp_ok ~~@$train, '>=', ~~@$test, 'training set is >= to the testing set';
		is ~~ uniq(@both), $N, 'testing and training are subsets of the full dataset';
		ok $train_set != $test_set, 'testing and training are disjoint';
		$fold++;
	}
	is $fold, 3, 'there were 3 folds';
};

done_testing;
