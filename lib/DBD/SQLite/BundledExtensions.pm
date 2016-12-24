package DBD::SQLite::BundledExtensions;

use strict;

use File::Find;
use File::Spec;

for my $ext (qw/spellfix csv ieee754 nextchar percentile series totype wholenumber eval/) {
    eval "sub load_${ext} {my (\$self, \$dbh)=\@_; \$self->_load_extension(\$dbh, '${ext}')}";
}

## 
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
        $sofile = File::Spec->rel2abs($sofile);
        $sofile =~ s/.(so|dll|dylib)$//;
    }

    return $sofile;
}

1;