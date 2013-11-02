# NAME

String::Unescape - Unescape perl-escaped string

# VERSION

version v0.0.0

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

This module is intented to be compatible with Perl's native unescaping as much as possible. After the feature complete, if the result is different, it is a bug.

# METHODS

## `unescape($str)`

Returns unescaped `$str`. For escaping, see ["Quote-and-Quote-like-Operators" in perlop](http://search.cpan.org/perldoc?perlop#Quote-and-Quote-like-Operators).

# AUTHOR

Yasutaka ATARASHI <yakex@cpan.org>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2013 by Yasutaka ATARASHI.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
