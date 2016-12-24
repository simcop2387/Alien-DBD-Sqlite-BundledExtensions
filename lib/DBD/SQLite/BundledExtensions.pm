package DBD::SQLite::BundledExtensions;

use strict;

use File::Find;

sub load_spellfix {
    my ($self, $dbh) = @_;

    $self->_load_extension("spellfix");
}

sub load_csv {
    my ($self, $dbh) = @_;

    $self->_load_extension("csv");
}

## 
sub _load_extension {
    my ($self, $dbh, $extension_name) = @_;

    $dbh->sqlite_enable_load_extension(1);
    my  $sth = $dbh->prepare("select load_extension(?)")
        or die "Cannot load '$extension_name' extension: " . $dbh->errstr();
    $sth->execute($self->_loocate_extension_library($extension_name);
}

sub _locate_extension_library {
    my ($self, $extension_name) = @_;
    my $sofile;

    my $wanted = sub {
        my $file = $File::Find::name;

        if ($file =~ m/DBD-SQLite-BundledExtensions.spellfix\.(so|dll|dylib)$/i){
            $sofile = $file;
            die; # bail out on the first one we find, this might need to be more configurable
        }
    };

    eval {find($wanted, @INC);};

    return $sofile;
}