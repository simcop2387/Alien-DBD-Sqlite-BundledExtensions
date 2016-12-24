#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
use DBI;
use File::Find;
use DBD::SQLite::BundledExtensions;

use Test::Simple;

#ok(defined $dbh, "Can create SQLite in memory DB");

for (qw/spellfix csv ieee754 nextchar percentile series totype wholenumber eval/) {
    # Can't seem to load more than one extension at a time.  I'm not sure why.
    my $dbh=DBI->connect('dbi:SQLite:dbname=:memory:',
        "",
        "",
        { RaiseError => 1, PrintError => 0 }
    );
    use Data::Dumper;
    ok(DBD::SQLite::BundledExtensions->_load_extension($dbh, $_), "Load extension $_");
}

#my (@a) = $dbh->selectrow_array('SELECT spellfix1_editdist("PLYMRY", "PLYMR");');

#print Dumper(\@a);
