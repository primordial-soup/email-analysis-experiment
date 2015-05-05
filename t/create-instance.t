use Test::More;
use v5.12;

use strict;
use warnings;

use EnronBerkeley;
use EnronBerkeley::Message;
use Text::CSV_XS;
use Path::Tiny;

use Term::ProgressBar;

use YAML qw(Dump freeze);
use Sereal qw(encode_sereal decode_sereal);
use Sereal::Encoder;
use List::UtilsBy qw( max_by );

my $maildir = '/home/zaki/sw_projects/email-analysis-experiment/email-analysis-experiment/extract/data/enron-email/berkeley/enron_with_categories';
my $dataset = EnronBerkeley->new( directory => $maildir );

my $progress = Term::ProgressBar->new({name => 'E-mails', count => $dataset->number_of_instances, remove => 1, ETA => 'linear' });
my $email_idx = 0;

my $encoder = Sereal::Encoder->new( { freeze_callbacks => 1 } );
my $decoder = Sereal::Decoder->new();
my $csv = Text::CSV_XS->new( { binary => 1, eol => $/, auto_diag => 2 } );


my $path_iter = $dataset->_message_iterator;
my $csv_output = path('features.csv')->openw_utf8;
while( defined( my $filename = $path_iter->() ) ) {
	my $file = $filename;
	my $msg = EnronBerkeley::Message->new( file => $file );

	my @cat_top_level_in_3 = grep { $_->top_level_category_id == 3 } @{ $msg->categories };
	if(@cat_top_level_in_3) {
		## The message has to have been categorised in one of the 3.* categories.

		## Which category has the largest count?
		my $largest_cat_3 = max_by { $_->count } @cat_top_level_in_3;

		## Input to learning algorithm
		my $instance = [
			$msg->file->stringify,                      # [instance name]
			$largest_cat_3->second_level_category_id,   # [label]
			$msg->body_single_line                      # [text]
		];

		## Write it out
		$csv->say( $csv_output, $instance );

		#use DDP; p $decoder->decode($encoder->encode($msg));
	}

	$progress->update(++$email_idx);
}

## Done
$csv->eof;
$csv_output->close;

# bin/mallet import-file --input /data/web/data.txt --output web.mallet

done_testing;
