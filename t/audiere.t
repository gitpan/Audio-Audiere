#!/usr/bin/perl -w

use Test::More tests => 7;
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
  getVersion
  /);

is (Audio::Audiere::_device_in_use(), 0, 'device not in use');

{
  my $au = Audio::Audiere->new( );

  is (ref($au), 'Audio::Audiere', 'new seemed to work');
  
  is ($au->getVersion() =~ /^Audiere /, 1, 'version');

  is (Audio::Audiere::_device_in_use(), 1, 'device now in use');
}

is (Audio::Audiere::_device_in_use(), 0, 'device not in use');


