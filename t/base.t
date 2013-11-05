use Test::More;
use Test::Exception;

my @case = qw(\t \n \r \f \b \a \e);

plan tests => 1 + 2 * @case;

use_ok 'String::Unescape';

foreach my $str (@case) {
	my $expected = eval "\"$str\"";
	my $got = String::Unescape::unescape($str);
	is($got, $expected, "func: $str");
	$got = String::Unescape->unescape($str);
	is($got, $expected, "class method: $str");
}
