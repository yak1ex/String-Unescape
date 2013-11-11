use Test::More;
use Test::Exception;

my @case;
push @case, ['\t\n\r\f\b\a\e', 'constant one chars'];
push @case, [join('', map { '\c'.chr($_) } 0..33,35..127), 'control chars']; # Excluding "
push @case, [join('', map { '\x{'.$_.'}' } qw(A AA AAA AAAA AAAAA AAAAAA AAAAAAA AAAAAAAA AxA)), '\x{}'];
push @case, ['\xA\xa\xq\xAAA\xaaa\x', '\x'];

# TODO: excerpt from perlop
# \N{name}     [3]    named Unicode character or character sequence
# \N{U+263D}   [4,8]  Unicode character (example: FIRST QUARTER MOON)
# \o{23072}    [6,8]  octal char        (example: SMILEY)
# \033         [7,8]  restricted range octal char  (example: ESC)

plan tests => 1 + 2 * @case;

use_ok 'String::Unescape';

foreach my $str (@case) {
	my $expected = eval "\"$str->[0]\"";
	my $got = String::Unescape::unescape($str->[0]);
	is($got, $expected, "func: $str->[1]");
	$got = String::Unescape->unescape($str->[0]);
	is($got, $expected, "class method: $str->[1]");
}
