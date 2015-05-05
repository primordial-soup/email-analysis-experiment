package EnronBerkeley::Category;

use Modern::Perl;
use List::AllUtils qw(zip);
use Moo;
use File::Slurp 'read_file';
use MooX::HandlesVia;

our $top_level_categories = {
	1 => "Coarse genre",
	2 => "Included/forwarded information",
	3 => "Primary topics (if coarse genre 1.1 is selected)",
	4 => "Emotional tone (if not neutral)",
};
our $second_level_categories = { map { chomp; split ' ', $_, 2 } read_file( \*DATA ) };

has category_info => (
	is => 'rw',
	handles_via => 'Array',
	handles => {
		do {
			## What each number in the category string represents in order.
			my @numbers_rep = qw(top_level_category_id second_level_category_id count);
			map { $numbers_rep[$_] => [ 'get', $_ ] }  0..@numbers_rep-1;
		}
	},
);
has [ qw(top_level_category_description
         second_level_category_description) ] => ( is => 'lazy' );

sub _build_top_level_category_description {
	my ($self) = @_;
	$top_level_categories->{$self->top_level_category_id};
}
sub _build_second_level_category_description {
	my ($self) = @_;
	$second_level_categories->{"@{[$self->top_level_category_id]}.@{[$self->second_level_category_id]}"};
}

sub parse_category {
	my ($klass, $category_string) = @_;
	# Parse a string for the category information: n1,n2,n3
	my @numbers = split ',', $category_string;
	EnronBerkeley::Category->new( category_info => \@numbers );
}

sub FREEZE { $_[0]->category_info }
sub THAW { __PACKAGE__->new( category_info => $_[2] ) }

1;
__DATA__
1.1 Company Business, Strategy, etc. (elaborate in Section 3 [Topics])
1.2 Purely Personal
1.3 Personal but in professional context (e.g., it was good working with you)
1.4 Logistic Arrangements (meeting scheduling, technical support, etc)
1.5 Employment arrangements (job seeking, hiring, recommendations, etc)
1.6 Document editing/checking (collaboration)
1.7 Empty message (due to missing attachment)
1.8 Empty message
2.1 Includes new text in addition to forwarded material
2.2 Forwarded email(s) including replies
2.3 Business letter(s) / document(s)
2.4 News article(s)
2.5 Government / academic report(s)
2.6 Government action(s) (such as results of a hearing, etc)
2.7 Press release(s)
2.8 Legal documents (complaints, lawsuits, advice)
2.9 Pointers to url(s)
2.10 Newsletters
2.11 Jokes, humor (related to business)
2.12 Jokes, humor (unrelated to business)
2.13 Attachment(s) (assumed missing)
3.1 regulations and regulators (includes price caps)
3.2 internal projects -- progress and strategy
3.3 company image -- current
3.4 company image -- changing / influencing
3.5 political influence / contributions / contacts
3.6 california energy crisis / california politics
3.7 internal company policy
3.8 internal company operations
3.9 alliances / partnerships
3.10 legal advice
3.11 talking points
3.12 meeting minutes
3.13 trip reports
4.1 jubilation
4.2 hope / anticipation
4.3 humor
4.4 camaraderie
4.5 admiration
4.6 gratitude
4.7 friendship / affection
4.8 sympathy / support
4.9 sarcasm
4.10 secrecy / confidentiality
4.11 worry / anxiety
4.12 concern
4.13 competitiveness / aggressiveness
4.14 triumph / gloating
4.15 pride
4.16 anger / agitation
4.17 sadness / despair
4.18 shame
4.19 dislike / scorn
