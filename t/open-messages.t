use Test::More;
use v5.12;

use strict;
use warnings;

use Path::Iterator::Rule;
use Mail::Message;
use Path::Class;

use MongoDB;
use Term::ProgressBar;

# tf-idf active learning
# Lucy computes tf-idf
# Bayesian query expansion


my $maildir = '/home/zaki/sw_projects/email-analysis-experiment/email-analysis-experiment/extract/data/enron-email/cmu/enron_mail_20110402/maildir';
my $client = MongoDB::MongoClient->new(host => 'localhost', port => 27017);
my $db = $client->get_database( 'enron_email' );


my $rule = Path::Iterator::Rule->new->file;
my $path_iter = $rule->iter( $maildir );
my $email_count = $rule->all;
my $progress = Term::ProgressBar->new({name => 'E-mails', count => $email_count, remove => 1, ETA => 'linear' });
my $email_idx = 0;

my $message_coll = $db->get_collection('messages');

while( defined( my $filename = $path_iter->() ) ) {
	my $file = file($filename);
	my $file_fh = $file->open('r');
	my $msg = Mail::Message->read( $file_fh );
	my $msg_id = $msg->messageID;

	my $msg_info = {
		message_id => $msg_id,
		subject => $msg->subject,
		file => $filename,
	};

	$message_coll->update(
		{ message_id => $msg_id },
		$msg_info,
		{ upsert => 1 });
	$progress->update(++$email_idx);
}
 
#$db->drop;

done_testing;
