#!perl -T

use warnings;
use strict;

use Test::More tests => 2;

use HTML::Tidy;

use Encode;

my $bytes_string = "\x{c2}\x{a0}"; #UTF8 nbsp
my $perl_chars   = Encode::decode('utf8',$bytes_string); #perl chars of utf8 byte string

my $expected_after_tidy = "&nbsp;\n"; # HTML::Tidy adds a \n and should convert the nbsp to an HTML entity
$expected_after_tidy = "&nbsp;\x0D\x0A" if $^O eq 'MSWin32'; #As it is passed from C code, it is not converted to \n

my $tidy = HTML::Tidy->new({ show_body_only => 1 });

is( $tidy->clean( $perl_chars ), $expected_after_tidy, 'Perl chars OK' );
is( $tidy->clean( $bytes_string ), $expected_after_tidy, 'Byte string OK' );
