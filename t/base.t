use Test::More;
use Test::Exception;

my @case;
push @case, ['\t\n\r\f\b\a\e', 'constant one chars'];
push @case, [join('', map { '\c'.chr($_) } 0..33,35..127), 'control chars']; # Excluding "

plan tests => 1 + 2 * @case;

use_ok 'String::Unescape';

foreach my $str (@case) {
	my $expected = eval "\"$str->[0]\"";
	my $got = String::Unescape::unescape($str->[0]);
	is($got, $expected, "func: $str->[1]");
	$got = String::Unescape->unescape($str->[0]);
	is($got, $expected, "class method: $str->[1]");
}
