use Test::More;
use v5.12;

use strict;
use warnings;

use Path::Iterator::Rule;
use List::AllUtils qw(nsort_by uniq);
use Path::Class;
use YAML qw(DumpFile LoadFile);

my $maildir = '/home/zaki/sw_projects/email-analysis-experiment/email-analysis-experiment/extract/data/enron-email/cmu/enron_mail_20110402/maildir';
my $datafile = 'enron-count.yml';

sub main {
	my $counts;
	if( -r $datafile ) {
		$counts = LoadFile( $datafile );
	} else {
		$counts = process_data();
		DumpFile( $datafile, $counts );
	}
	analyse_data( $counts );
}

sub process_data {
	my $mailboxes_rule = Path::Iterator::Rule->new->dir->min_depth(1)->max_depth(1);
	my $subfolder_rule = Path::Iterator::Rule->new->dir;
	my $message_rule = Path::Iterator::Rule->new->file;

	my $mailboxes_iter = $mailboxes_rule->iter( $maildir );

	my $mailbox_subfolder_count = {};
	my $mailbox_message_count = {};

	while( defined( my $mailbox_dir = $mailboxes_iter->() ) ) {
		my $mailbox_name = dir( $mailbox_dir )->basename;
		say $mailbox_dir;
		$mailbox_subfolder_count->{ $mailbox_name } = $subfolder_rule->all( $mailbox_dir );
		$mailbox_message_count->{ $mailbox_name } = $message_rule->all( $mailbox_dir );
	} 
	return {
		subfolder_count => $mailbox_subfolder_count,
		message_count => $mailbox_message_count,
	};
}

sub analyse_data {
	my ($data) = @_;

	my $mailbox_subfolder_count = $data->{subfolder_count};
	my $mailbox_message_count = $data->{message_count};

	my @mailbox_names = keys $mailbox_subfolder_count;

	my @mailbox_by_subfolder_count_desc = reverse nsort_by { $mailbox_subfolder_count->{$_} } @mailbox_names;
	my @mailbox_by_message_count_desc = reverse nsort_by { $mailbox_message_count->{$_} } @mailbox_names;

	my @largest_mailboxes = uniq @mailbox_by_subfolder_count_desc[0..10], @mailbox_by_message_count_desc[0..10];
	for my $boxname (@mailbox_names) {
		say sprintf "%20s %5d %5d", $boxname, $mailbox_subfolder_count->{$boxname}, $mailbox_message_count->{ $boxname };
	}
}

main;
