#!/usr/bin/perl -w

use Test::More tests => 5;
use strict;

BEGIN
  {
  $| = 1;
  use blib;
  unshift @INC, '../lib';
  unshift @INC, '../blib/arch';
  chdir 't' if -d 't';
  use_ok ('Audio::Audiere');
  }

can_ok ('Audio::Audiere', qw/ 
  new
  addStream
  addTone
  addSquareWave
  addPinkNoise
  addWhiteNoise
  getVersion
  /);

my $au = Audio::Audiere->new( );

is (ref($au), 'Audio::Audiere', 'new seemed to work');
  
is ($au->getVersion() =~ /^Audiere /, 1, 'version');

print "# audio device is: ", $au->getName(),"\n";
isnt (length($au->getName()), 0, 'some name returned');

