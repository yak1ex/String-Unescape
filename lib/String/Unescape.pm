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

sub unescape
{
	shift if @_ && eval { $_[0]->isa(__PACKAGE__); };
	croak 'No string is given' unless @_;
	croak 'More than one argument are given' unless @_ == 1;
	my $ret = $_[0];
	$ret =~ s/\\([tnrfbae])/$map{$1}/ge;
	$ret =~ s/\\c(.)/exists $mapc{$1} ? $mapc{$1} : chr(ord($1) ^ 0x40)/gse;
	$ret =~ s/\\x\{([0-9a-fA-F]*)[^}]*\}/chr(hex($1))/ge;
	$ret =~ s/\\x([0-9a-fA-F]{0,2})/chr(hex($1))/ge;
	$ret =~ s/\\([0-7]{1,3})/chr(oct($1))/ge;
	$ret =~ s/\\o\{([0-7]*)[^}]*\}/chr(oct($1))/ge;

	$ret =~ s/\\(l|u)(.?)/$1 eq 'l' ? lcfirst($2) : ucfirst($2)/ge;
	$ret =~ s/\\(L)(.*?)(?:\\E|\Z)/lc($2)/ge;
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
