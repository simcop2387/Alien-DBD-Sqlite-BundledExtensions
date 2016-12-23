package DBD::SQLite::Ext::Spellfix;

use strict;
use warnings;

use File::Find;

sub load_spellfix {
    my $dbh = shift;

    $dbh->sqlite_enable_load_extension(1);
    my  $sth = $dbh->prepare("select load_extension(?)")
        or die "Cannot load spellfix extension: " . $dbh->errstr();
    $sth->execute(_find_spellfix_so());
}

sub _find_spellfix_so {
    my $sofile;
    my $wanted = sub {
        my $file = $File::Find::name;

        if ($file =~ m/SQLite.spellfix\.(so|dll|dylib)$/i){
            $sofile = $file;
            die; # bail out on the first one we find, this might need to be more configurable
        }
    };

    eval {find($wanted, @INC);};

    return $sofile;
}

1;
