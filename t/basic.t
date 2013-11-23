use Test::More;
use Test::Exception;

#use charnames qw(:full);

my @case;
push @case, ['\t\n\r\f\b\a\e', 'constant one chars'];
push @case, [join('', map { '\c'.chr($_) } 0..33,35..127), 'control chars']; # Excluding "
push @case, [join('', map { '\x{'.$_.'}' } qw(A AA AAA AAAA AAAAA AAAAAA AAAAAAA AAAAAAAA AxA)), '\x{}'];
push @case, ['\xA\xa\xq\xAAA\xaaa\x', '\x'];
push @case, ['\0A\128\0128\18\1111\0111', '\0']; # TODO: check fatal error case
push @case, [join('', map { '\N{'.$_.'}' } ('FIRST QUARTER MOON', 'WHITE SMILING FACE', 'U+263D', 'U+263A')), '\N{}']; # An invalid name/value causes a compilation error
# [from 5.14]
push @case, [join('', map { '\o{'.$_.'}' } qw(1 11 111 1111 11111 111111 1111111 11111111 1x1)), '\o{}'];

plan tests => 1 + 2 * @case;

use_ok 'String::Unescape';

foreach my $str (@case) {
# At least, perl 5.8.9 requires 'use charnames qw(:full)' in each eval
    my $expected = eval "use charnames qw(:full); \"$str->[0]\"";
    my $got = String::Unescape::unescape($str->[0]);
    is($got, $expected, "func: $str->[1]");
    $got = String::Unescape->unescape($str->[0]);
    is($got, $expected, "class method: $str->[1]");
}
