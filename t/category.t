use Test::More;

use Modern::Perl;
use EnronBerkeley::Category;

my %data = (
	'1,1,5' => { count => 5, second_id => 1, second_desc => 'Company Business, Strategy, etc. (elaborate in Section 3 [Topics])' },
	'1,3,2' => { count => 2, second_id => 3, second_desc => 'Personal but in professional context (e.g., it was good working with you)' },
);

plan tests => scalar keys %data;

for my $category_string ( keys %data ) {
	subtest "Category $category_string" => sub {
		my $cat = EnronBerkeley::Category->parse_category( $category_string );
		ok( $cat, 'built category' );
		is( $cat->count, $data{$category_string}{count}, 'count');
		is( $cat->second_level_category_id, $data{$category_string}{second_id}, '2nd level ID');
		is( $cat->second_level_category_description, $data{$category_string}{second_desc}, '2nd level description');
	}
}


done_testing;
