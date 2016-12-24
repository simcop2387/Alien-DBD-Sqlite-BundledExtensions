package DBD::SQLite::BundledExtensions;

use strict;

use File::Find;
use File::Spec;

for my $ext (qw/spellfix csv ieee754 nextchar percentile series totype wholenumber eval/) {
    eval "sub load_${ext} {my (\$self, \$dbh)=\@_; \$self->_load_extension(\$dbh, '${ext}')}";
}

sub _load_extension {
    my ($self, $dbh, $extension_name) = @_;

    my $file = $self->_locate_extension_library($extension_name);

    $dbh->sqlite_enable_load_extension(1);
    $dbh->do("select load_extension(?)", {}, $file)
        or die "Cannot load '$extension_name' extension: " . $dbh->errstr();
}

sub _locate_extension_library {
    my ($self, $extension_name) = @_;
    my $sofile;

    my $wanted = sub {
        my $file = $File::Find::name;

        if ($file =~ m/DBD-SQLite-BundledExtensions.\Q$extension_name\E\.(so|dll|dylib)$/i){
            $sofile = $file;
            die; # bail out on the first one we find, this might need to be more configurable
        }
    };

    eval {find({wanted => $wanted, no_chdir => 1}, @INC);};

    if ($sofile) {
        $sofile = File::Spec->rel2abs($sofile); # Make it an absolute path, if it isn't already.  Aids in portability
    }

    return $sofile;
}

1;
__END__
=head1 NAME

DBD::SQLite::BundledExtesions - Provide a series of C extensions for DBD::SQLite and some helper functions to load them

=head1 METHODS

=head2 load_csv

    Loads the csv extension that allows you to use a CSV file as a virtual table

=head2 load_eval

    Loads the eval extension that gives you the C<eval()> SQL function.  Works pretty much like eval in perl but for SQL.  Probably dangerous.

=head2 load_ieee754 

    Gives you some functions for dealing with ieee754 specific issues.

=head2 load_nextchar

=head2 load_percentile 

=head2 load_series 

=head2 load_spellfix 

=head2 load_totype 

=head2 load_wholenumber 

=back

=head1 KNOWN ISSUES

=over

=item Loading multiple extensions doesn't work properly

=back


=head1 AUTHORS
 
Ryan Voots E<lt>simcop2387@simcop2387.infoE<gt>

=head1 COPYRIGHT
 
Copyright 2016 by Ryan Voots E<lt>simcop2387@simcop2387.infoE<gt>.
 
The perl parts of this program are redistributable under the Artistic 2.0 license.
The SQLite Extensions are redistributable under the terms described in the SQLite source code itself.
 
=cut