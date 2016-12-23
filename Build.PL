#!/usr/bin/env perl
use strict;
use warnings;
use Config;

use Alien::Base::ModuleBuild;
 
my $cc = $Config{cc};

my $builder = Alien::Base::ModuleBuild->new(
  module_name => 'Alien::DBD::SQLite::Ext::Spellfix',

  license => 'artistic_2',

  configure_requires => {
    'Alien::Base::ModuleBuild' => '0.005',
    'Module::Build' => '0.28',
  },
  requires => {
    'Alien::Base' => '0.005',
  },
   
  # this is the default:
  alien_build_commands => [
    "$cc -o  source/spellfix.c",
  ],
   
  alien_install_commands => [
    "cp spellfix.so %s",
  ],
);

$builder->create_build_script;

