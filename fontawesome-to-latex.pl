#!/usr/bin/perl

=head1 NAME

fontawesome-to-latex.pl

=head1 DESCRIPTION

Generate LaTeX definitions from a Font Awesome icon metadata JSON file.

=head1 USAGE

fontawesome-to-latex.pl FA_ICON_METADATA_FILE OUT_FILE

Example: fontawesome-to-latex.pl icons.json fontawesome.sty

=head2 PARAMETERS

=head3 FA_ICON_METADATA_FILE

Font Awesome icon metadata JSON file.

This should be located in the Font Awesome archive:
    advanced_options/metadata/icons.json

=head3 OUT_FILE

File to output the LaTeX definitions to.

If the file exists it will be overwritten.

=cut

use strict;
use warnings;

use feature qw( say );

use FileHandle;
use File::Slurp qw( read_file );
use JSON;
use List::Util qw( uniq );
use Pod::Usage;

my ( $fa_metadata, $out_file ) = @ARGV;

_exit_error( 'Font Awesome icon metadata JSON file required' ) unless( defined $fa_metadata and -e $fa_metadata );
_exit_error( 'Destination file required' ) unless( defined $out_file and -e $out_file );

my $data = read_file( $fa_metadata ) or _exit_error( "Failed to read file: $!" );
my $json = JSON->new();
my $metadata = $json->decode( $data ) or _exit_error( "Unable to parse '$fa_metadata': $!" );

my $fh = FileHandle->new( $out_file, 'w' );

# Determine the Font-Awesome version
my @versions;
foreach my $icon ( keys %{ $metadata } )
{
    my $changes = $metadata->{ $icon }->{ 'changes' };
    @versions = ( @versions, @{ $changes } );
}

my @uniq_versions = sort { _cmp_version( $a, $b ) } uniq( @versions );
my $latest_version = $uniq_versions[-1];

# Generate LaTeX definitions for each Font-Awesome icon
foreach my $icon ( sort keys %{ $metadata } )
{
    my $code = uc( $metadata->{ $icon }->{ 'unicode' } );
    my $name = _numbers_to_words( $icon );
    $name = _title_case( '-', $name );

    my $line = '\def\fa' . $name . '{\symbol{"' . $code . '}}';
    say $fh $line;
}

exit( 0 );

# _cmp_version
#
# Comparison function for sorting semantic version strings.

sub _cmp_version
{
    my ( $val_a, $val_b ) = @_;

    my ( $a_major, $a_minor, $a_patch ) = split( /\./, $val_a, 3 );
    my ( $b_major, $b_minor, $b_patch ) = split( /\./, $val_b, 3 );
    
    return(
        ( $a_major // 0 ) <=> ( $b_major // 0 ) or
        ( $a_minor // 0 ) <=> ( $b_minor // 0 ) or
        ( $a_patch // 0 ) <=> ( $b_patch // 0 )
    );
}

# _exit_error
#
# Output error message and exit.
#
# Command usage will also be included.

sub _exit_error
{
    my ( $message ) = @_;

    pod2usage({
        '-exitval' => 1,
        '-message' => $message,
    });
}

# _numbers_to_words
#
# Given a string, replaces any digits to words e.g. 'Num 11' => 'Num OneOne'.
#
# Returns translated string.

sub _numbers_to_words
{
    my ( $string ) = @_;

    my $number_map = {
        '0' => 'Zero',
        '1' => 'One',
        '2' => 'Two',
        '3' => 'Three',
        '4' => 'Four',
        '5' => 'Five',
        '6' => 'Six',
        '7' => 'Seven',
        '8' => 'Eight',
        '9' => 'Nine',
    };

    foreach my $num ( 0 .. 9 )
    {
        my $word = $number_map->{ $num };
        $string =~ s/$num/$word/g;
    }

    return $string;
}

# _title_case
#
# Given a word separator and string, converts words to title case
# e.g. with a separator of '-', 'a-test' is converted to 'ATest'.
#
# Returns converted string.

sub _title_case
{
    my ( $separator, $string ) = @_;

    my @parts = split( qr/$separator/, $string );
    @parts = map { ucfirst $_ } @parts;
    $string = join( '', @parts );

    return $string;
}
