#!/usr/bin/env perl

use strict;
use warnings;
use Data::Dumper;
use DBI;
use File::Find;
use lib './lib';
use DBD::SQLite::Ext::Spellfix;

my $dbh=DBI->connect('dbi:SQLite:dbname=:memory:',
    "",
    "",
    { RaiseError => 1, PrintError => 0 }
);

DBD::SQLite::Ext::Spellfix::load_spellfix($dbh);
my (@a) = $dbh->selectrow_array('SELECT spellfix1_editdist("PLYMRY", "PLYMR");');


print Dumper(\@a);
