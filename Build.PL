#!/usr/bin/env perl
use strict;
use warnings;
use Config;

use Alien::Base::ModuleBuild;
use File::ShareDir 'dist_dir';

my $dbd_dist = dist_dir('DBD-SQLite');
my $cc = $Config{cc};

# TODO this probably doesn't work on windows anyway.  Need to look into how to make that work correctly anyway.
my $lib_ext = $^O =~ 'mswin' ? 'dll' : 'so';

my @extensions = qw/spellfix csv ieee754 nextchar percentile series totype wholenumber eval/;

# TODO this needs to support mswin32
my @build_commands = map {"$cc -shared -I$dbd_dist -O2 -fPIC -o $_.$lib_ext ext/misc/$_.c"} @extensions;
my @install_commands = map {"cp $_.$lib_ext %s"} @extensions;

my $builder = Alien::Base::ModuleBuild->new(
  module_name => 'Alien::DBD::SQLite::BundledExtensions',

  license => 'artistic_2', # TODO this might need to change based on the license of the extensions I'm bundling with this.  Do more research.
  alien_repository => {
    protocol => 'local',
    location => 'source/',
    pattern  => qr{^sqlite-src-([0-9\.]+)\.zip$},
  },

  configure_requires => {
    'Alien::Base::ModuleBuild' => '0.005',
    'Module::Build' => '0.28',
    'DBD::SQLite' => 0,
    'Archive::Zip' => 0,
  },
  requires => {
    'Alien::Base' => '0.005',
    'DBD::SQLite' => 0,
  },
  
  alien_build_commands => \@build_commands,
  alien_install_commands => \@install_commands,
);

$builder->create_build_script;

