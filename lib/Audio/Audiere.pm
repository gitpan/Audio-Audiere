
# Use Audiere (http://audiere.sf.net) in Perl

package Audio::Audiere;

# (C) by Tels <http://bloodgate.com/>

use strict;

require Exporter;

use vars qw/@ISA $VERSION @EXPORT_OK/;
@ISA = qw/Exporter/;

@EXPORT_OK = qw/AUDIO_STREAM AUDIO_BUFFER/;

$VERSION = '0.03';

package Audio::Audiere::Audiere_perl;

use vars qw/@ISA/;
require DynaLoader;
@ISA = qw/DynaLoader/;

bootstrap Audio::Audiere::Audiere_perl $Audio::Audiere::VERSION;

package Audio::Audiere;

#use Audio::Audiere::Audiere_perl;	# load our .so/.dll object
use Audio::Audiere::Stream;

use constant AUDIO_STREAM => 0;
use constant AUDIO_BUFFER => 1;

##############################################################################

sub new
  {
  # create a new instance of Audio::Audiere - there can be only one
  my $class = shift;
  my $self = {}; bless $self, $class;

  $self->{error} = '';
  if (!$self->_init_device( $_[0] || '', $_[1] || '' ))
    {
    return
      Audio::Audiere::Error->new("Could not init device '$_[0]'");
    }

  $self;
  }

sub DESTROY
  {
  my $self = shift;

  $self->_drop_device();
  }

sub error
  {
  my $self = shift;

  undef;
  }

##############################################################################

sub addStream
  {
  my $self = shift;

  Audio::Audiere::Stream->new(@_);
  }

sub addTone
  {
  my $self = shift;
  Audio::Audiere::Stream->tone(@_);
  }

sub addSquareWave
  {
  my $self = shift;
  Audio::Audiere::Stream->square_wave(@_);
  }

sub addWhiteNoise
  {
  my $self = shift;
  Audio::Audiere::Stream->white_noise();
  }

sub addPinkNoise
  {
  my $self = shift;
  Audio::Audiere::Stream->pink_noise();
  }

sub dropStream
  {
  my $self = shift;
  # TODO: streams are not registered, so nothing to do now
  }

1; # eof

__END__

=pod

=head1 NAME

Audio::Audiere - use the Audiere sound library in Perl

=head1 SYNOPSIS

	use Audio::Audiere qw/AUDIO_STREAM AUDIO_BUFFER/;
	use strict;
	use warnings;

	my $audiere = Audio::Audiere->new();

	if ($audiere->error())
	  {
	  die ("Cannot get audio device: ". print $audiere->error());
	  }

	# now we have the driver, add some sound streams

	# stream the sound from the disk
	my $stream = $audiere->addStream( 'media/sample.ogg', AUDIO_STREAM);

	# always check for errors:
	if ($stream->error())
	  {
	  print "Cannot load sound: ", $stream->error(),"\n";
	  }
	
	# load sound into memory (if possible), this is also the default
	my $sound = $audiere->addStream( 'media/effect.wav', AUDIO_BUFFER);
	
	# always check for errors:
	if ($sound->error())
	  {
	  print "Cannot load sound: ", $sound->error(),"\n";
	  }

	$stream->setVolume(0.5);	# 50%
	$stream->setRepeat(1);		# loooop
	if ($stream->isSeekable())
	  {
	  $stream->setPosition(100);	# skip some bit
	  }
	$stream->play();		# start playing
	
 	$sound->play();			# start playing

	# free sound device (not neccessary, will be done automatically)
	# $driver = undef;

=head1 EXPORTS

Exports nothing on default. Can export C<AUDIO_BUFFER> and C<AUDIO_STREAM>
on request.

=head1 DESCRIPTION

This package provides you with an interface to the audio library I<Audiere>.

=head1 METHODS

=over 2

=item new()
	
	my $audiere = Audio::Audiere->new( $devicename, $parameters );

Creates a new object that holds the I<Audiere> driver to the optional
C<$devicename> and the optional C$parameters>.

The latter is a comma-separated list like C<buffer=100,rate=44100>.

When C<$audiere> goes out of scope or is set to undef, the device will
be automatically released.

In case you wonder how you can play multiple sounds at once with only once
device: these are handled as separate streams, and once you have the Audiere
driver, you can add (almost infinitely) many of them via L<addStream> (or
any of the other C<add...()> methods.

=item getVersion

Returns the version of Audiere you are using as string.

=item getName

Returns the name of the audio device, like 'oss' or 'directsound'.

=item addStream

	$stream = $audiere->addStream( $file, $stream_flag )

Create a new sound stream object, and return it. See L<METHODS ON STREAMS>
on what methods you can use to manipulate the stream object. Most popular
will be C<play()>, of course :)

You should always check for errors before using the stream object:
	
	if ($stream->error())
	  {
	  print "Cannot load sound: ", $stream->error(),"\n";
	  }

=item addTone

	$audiere->addTone( $frequenzy );

Create a stream object that produces a tone at the given C<$frequenzy>.

See also L<addStream> and L<Methods on streams>.

=item addSquareWave

	$audiere->addSquareWave( $frequenzy );

Create a stream object that produces a swaure wave at the given C<$frequenzy>.

See also L<addStream> and L<Methods on streams>.

=item addWhiteNoise

	$audiere->addWhiteNoise( );

Create a stream object that produces white noise.

See also L<addStream> and L<Methods on streams>.

=item addPinkNoise

	$audiere->addPinkNoise( );

Create a stream object that produces pink noise, which is noise with an equal
power distribution among octaves (logarithmic), not frequencies.

See also L<addStream> and L<Methods on streams>.

=item dropStream

	$audiere->dropStream($stream);

This will stop the sound playing from this stream and release it's memory. You
can also do it like this or just have C<$stream> go out of scope:

	$stream = undef;

=item dupeStream

	$second_stream = $audiere->dupeStream($stream);
	$second_stream = $stream->copy();

=back

=head2 METHODS ON STREAMS

Methods on streamds must be called on stream objects that are returned by
L<addStream>.

=over 2

=item error

	if ($stream->error())
	  {
	  print "Fatal error: ", $stream->error(),"\n";
	  }

Return the last error message, or undef for no error.

=item play

Start playing the stream.

=item stop

Stop playing the stream.

=item isSeekable

=item getLength

=item isPlaying

	while ($stream->isPlaying())
	  {
	  ...
	  }

Returns true if the stream still plays.

=item getPosition

=item getFormat

=item getSamples

=item getVolume

Returns the volume of the stream as a value between 0 and 1.

=item setVolume

Set the volume of the stream as a value between 0 and 1.

=item getRepeat

Returns true if the stream is repeating (aka looping).

=item setRepeat

	$stream->setRepeat(1);		# loop
	$stream->setRepeat(0);		# don't loop

If true, the stream will repeat (aka loop).

=item setPan

	$stream->setPan ( -1.0 );	# -1.0 = left, 0 = center, 1.0 = right

Set the panning of the sound from -1.0 to +1.0.

=item getPan

Returns the current panning of the sound from -1.0 to +1.0. See L<setPan>.

=item setPitch

=item getPitch

=item setPitchShift

=item getPosition

=back

=head1 AUTHORS

(c) 2004 Tels <http://bloodgate.com/>

=head1 SEE ALSO

L<http://audiere.sf.net/>

=cut

