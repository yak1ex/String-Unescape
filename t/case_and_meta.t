use Test::More;
use Test::Exception;

my @case;
push @case, ['ABC\lABC\labc\l', '\l'];
push @case, ['ABC\uABC\uabc\u', '\u'];
push @case, ['ABC\LABC\Eabc\Labc\EABC\LABC', '\L'];
push @case, ['ABC\UABC\Eabc\Uabc\EABC\Uabc', '\U'];
push @case, ['[]\Q[]\E[]\Q[]\E[]\Q[]', '\Q'];

plan tests => 1 + 2 * @case;

use_ok 'String::Unescape';

foreach my $str (@case) {
	my $expected = eval "\"$str->[0]\"";
	my $got = String::Unescape::unescape($str->[0]);
	is($got, $expected, "func: $str->[1]");
	$got = String::Unescape->unescape($str->[0]);
	is($got, $expected, "class method: $str->[1]");
}
