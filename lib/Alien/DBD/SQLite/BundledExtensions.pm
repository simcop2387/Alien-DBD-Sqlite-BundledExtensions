package Alien::DBD::SQLite::BundledExtensions;

our $VERSION=0.0001;

1;
__END__
=head1 NAME

Alien::DBD::SQLite::BundledExtesions - builds a series of SQLite extensions provided with the SQLite source to be compatible with DBD::SQLite

It provides the following extensions from the SQLite source:

=over

=item csv

=item eval

=item ieee754 

=item nextchar 

=item percentile 

=item series 

=item spellfix 

=item totype 

=item wholenumber 

=back