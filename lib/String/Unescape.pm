package String::Unescape;

use strict;
use warnings;

# ABSTRACT: Unescape perl-escaped string
# VERSION

require Exporter;
our (@EXPORT_OK) = qw(unescape);

use Carp;

my %map = (
	t => "\t",
	n => "\n",
	r => "\r",
	f => "\f",
	b => "\b",
	a => "\a",
	e => "\e",
);

my %mapc = map { chr($_) => chr($_ ^ 0x60) } 97..122;

my %convs = (
	l => sub { lcfirst shift },
	u => sub { ucfirst shift },
);

my %convp = (
	L => sub { lc shift },
	U => sub { uc shift },
);

my $convert = sub {
	return $map{$1} if defined $1;
	return exists $mapc{$2} ? $mapc{$2} : chr(ord($2) ^ 0x40) if defined $2;
	return chr(hex($3)) if defined $3;
	return chr(hex($4)) if defined $4;
	return chr(oct($5)) if defined $5;
	return chr(oct($6)) if defined $6 && $^V ge v5.14.0;
	return 'o{'.$6.$7.'}' if defined $6 && $^V ge v5.14.0;
	return $convs{$8}($9) if defined $8;
	return $convp{$10}($11) if defined $10;
	return $12;
};

sub unescape
{
	shift if @_ && eval { $_[0]->isa(__PACKAGE__); };
	croak 'No string is given' unless @_;
	croak 'More than one argument are given' unless @_ == 1;
	my $ret = $_[0];
	while($ret =~ s/\G
		\\([tnrfbae]) |                  # $1 : one char
		\\c(.) |                         # $2 : control
		\\x\{([0-9a-fA-F]*)[^}]*\} |     # $3 : \x{}
		\\x([0-9a-fA-F]{0,2}) |          # $4 : \x
		\\([0-7]{1,3}) |                 # $5 : \077
		\\o\{([0-7]*)([^}]*)\} |         # $6, $7 : \o{}

		\\(l|u)(.?) |                    # $8, $9 : \l, \u
		\\(L|U)(.*?)(?:\\E|\Z) |         # $10, $11 : \L, \U, \E

		\\?(.)                           # $12

		/$convert->()/gxse) {
		last unless defined pos($ret)
	}

	return $ret;
}

1;
__END__

=head1 SYNOPSIS

  # Call as class method
  print String::Unescape->unescape('\t\c@\x41\n');

  # Call as function
  use String::Escape qw(unescape);
  print unescape('\t\c@\x41\n');

=head1 DESCRIPTION

This module provides just one function, Perl's unescaping without variable interpolation. Sometimes, I want to provide a string including a character difficult to represent without escaping, outside from Perl. Also, sometimes, I can not rely on shell expansion.

  # App-count
  count -t '\t'

C<eval> can handle this situation but it has too more power than required. This is the purpose for this module.

This module is intented to be compatible with Perl's native unescaping as much as possible. After the feature complete, if the result is different, it is a bug.

=method C<unescape($str)>

Returns unescaped C<$str>. For escaping, see L<perlop/Quote-and-Quote-like-Operators>.

=cut
