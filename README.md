# NAME

String::Unescape - Unescape perl-escaped string

# VERSION

version v0.0.1

# SYNOPSIS

    # Call as class method
    print String::Unescape->unescape('\t\c@\x41\n');

    # Call as function
    use String::Escape qw(unescape);
    print unescape('\t\c@\x41\n');

# DESCRIPTION

This module provides just one function, Perl's unescaping without variable interpolation. Sometimes, I want to provide a string including a character difficult to represent without escaping, outside from Perl. Also, sometimes, I can not rely on shell expansion.

    # App-count
    count -t '\t'

`eval` can handle this situation but it has too more power than required. This is the purpose for this module.

This module is intented to be compatible with Perl's native unescaping as much as possible, with the following limitation.
If the result is different from one by Perl beyond the limitation, it is considered as a bug. Please report it.

## LIMITATION

There are the following exceptions that Perl's behavior is not emulated.

1. Whether warning is produced or not.
2. Strings that perl doesn't accept. For those strings, the results by this module are undefined.
3. \\L in \\U and \\U in \\L. By perl, they are not stacked, which means all \\Q, \\L, \\U and \\F (if available) modifiers from the prior \\L, \\U or \\F become to have no effect then restart the new \\L, \\U or \\F conversion. By this module, stacked.
4. \\L\\u and \\U\\l. By Perl, they are swapped as \\u\\L and \\l\\U, respectively. By this module, not swapped.

For 3 and 4, t/quirks\_in\_perl.t contains actual examples.

# METHODS

## `unescape($str)`

Returns unescaped `$str`. For escaping, see ["Quote-and-Quote-like-Operators" in perlop](https://metacpan.org/pod/perlop#Quote-and-Quote-like-Operators).

# REMARKS

[charnames](https://metacpan.org/pod/charnames) in Perl 5.6 does not have required functionality that is Unicode name <-> code conversion in runtime, thus Perl 5.6 support is explicitly dropped.

# AUTHOR

Yasutaka ATARASHI <yakex@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Yasutaka ATARASHI.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
