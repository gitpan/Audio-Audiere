#!/usr/bin/perl -w

use Test::More tests => 14;
use strict;

BEGIN
  {
  $| = 1;
  use blib;
  unshift @INC, '../lib';
  unshift @INC, '../blib/arch';
  chdir 't' if -d 't';
  }

use Audio::Audiere qw/AUDIO_STREAM AUDIO_BUFFER/;

my $au = Audio::Audiere->new( );

my $stream = $au->addStream ('test.wav', AUDIO_STREAM);

is (ref($stream), 'Audio::Audiere::Stream', 'addStream seemed to work');

# repeat
is ($stream->getRepeat(0), 0, 'getRepeat is 0');
is ($stream->setRepeat(1), 1, 'repeat is now 1');
is ($stream->getRepeat(), 1, 'repeat is still 1');

$stream->getRepeat(0);
$stream->play();

my $i = 0;
while ($stream->isPlaying() && $i < 3)
  {
  sleep(1); $i++;
  } 

$stream->stop();

# Pan
is ($stream->getPan(), 0, 'pan is 0');
is ( sprintf("%0.1f", $stream->setPan(0.5)), '0.5', 'pan is now 0.5');
is ( sprintf("%0.1f", $stream->getPan()), '0.5', 'pan is stil 0.5');

# Pitch
is ($stream->getPitchShift(), 1, 'pitch is 1');
is ( sprintf("%0.1f", $stream->setPitchShift(0.5)), '0.5', 'pitch is now 0.5');
is ( sprintf("%0.1f", $stream->getPitchShift()), '0.5', 'pitch is stil 0.5');

# Volume
is ($stream->getVolume(), 1, 'volume is 1');
is ( sprintf("%0.1f", $stream->setVolume(0.3)), '0.3', 'volume is now 0.3');
is ( sprintf("%0.1f", $stream->getVolume()), '0.3', 'volume is stil 0.3');

# getLength
is ($stream->getLength() != 1, 1, 'getlength is not 1');
