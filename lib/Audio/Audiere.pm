
# Audiere (http://audiere.sf.net) in Perl (C) by Tels <http://bloodgate.com/>

package Audio::Audiere;

use strict;
require Exporter;

use vars qw/@ISA $VERSION @EXPORT_OK/;
@ISA = qw/Exporter/;

@EXPORT_OK = qw/
  AUDIO_STREAM AUDIO_BUFFER
    FF_AUTODETECT
    FF_WAV
    FF_OGG
    FF_FLAC
    FF_MP3
    FF_MOD
    FF_AIFF
    SF_U8
    SF_S16
  /;

$VERSION = '0.04';

# a package to have Audiere_perl.dll under Win32, to avoid clash with the
# Audiere.dll

package Audio::Audiere::Audiere_perl;

use vars qw/@ISA/;
require DynaLoader;
@ISA = qw/DynaLoader/;

bootstrap Audio::Audiere::Audiere_perl $Audio::Audiere::VERSION;

package Audio::Audiere;

use Audio::Audiere::Stream;

use constant AUDIO_STREAM => 0;
use constant AUDIO_BUFFER => 1;

# enum FileFormat

use constant FF_AUTODETECT => 0;
use constant FF_WAV => 1;
use constant FF_OGG => 2;
use constant FF_FLAC => 3;
use constant FF_MP3 => 4;
use constant FF_MOD => 5;
use constant FF_AIFF => 6;
  
# enum SampleFormat

use constant SF_U8 => 0;
use constant SF_S16 => 1;

##############################################################################

sub new
  {
  # create a new instance of Audio::Audiere
  my $class = shift;
  my $self = {}; bless $self, $class;

  $self->{error} = '';
  $self->{_device} = $self->_init_device( $_[0] || '', $_[1] || '');

  if (!$self->{_device})
    {
    return
      Audio::Audiere::Error->new("Could not init device '$_[0]'");
    }

  $self;
  }

sub DESTROY
  {
  my $self = shift;

  $self->_drop_device($self->{_device}) if $self->{_device};
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

  Audio::Audiere::Stream->new($self->{_device},@_);
  }

sub addStream3D
  {
  my $self = shift;

  Audio::Audiere::Stream::3D->new($self->{_device},@_);
  }

sub addTone
  {
  my $self = shift;
  Audio::Audiere::Stream->tone($self->{_device},@_);
  }

sub addSquareWave
  {
  my $self = shift;
  Audio::Audiere::Stream->square_wave($self->{_device},@_);
  }

sub addWhiteNoise
  {
  my $self = shift;
  Audio::Audiere::Stream->white_noise($self->{_device});
  }

sub addPinkNoise
  {
  my $self = shift;
  Audio::Audiere::Stream->pink_noise($self->{_device});
  }

sub dropStream
  {
  my $self = shift;
  # TODO: streams are not registered, so nothing to do now
  }

sub getName
  {
  my $self = shift;

  _get_name($self->{_device});
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

	# free sound device is not neccessary, will be done automatically

=head1 EXPORTS

Exports nothing on default. Can export C<AUDIO_BUFFER> and C<AUDIO_STREAM>,
as well as the following constants for file formats:

	FF_AUTODETECT
	FF_WAV
	FF_OGG
	FF_FLAC
	FF_MP3
	FF_MOD

Also, the following sample source format constants can be exported:

	SF_U8
	SF_S16

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
device: these are handled as separate streams, and once you have the device,
you can add (almost infinitely) many of them via L<addStream> (or
any of the other C<add...()> methods.

In theory you can open more than one device, however, in praxis usually only
one of them is connected to the sound output, so this does not make much sense.

=item getVersion
	
	print $audiere->getVersion();

Returns the version of Audiere you are using as string.

=item getName

	print $audiere->getName();

Returns the name of the audio device, like 'oss' or 'directsound'.

=item addStream

	$stream = $audiere->addStream( $file, $stream_flag )

Create a new sound stream object from C<$file>, and return it.

See L<METHODS ON STREAMS> on what methods you can use to manipulate the stream
object. Most popular will be C<play()>, of course :)

You should always check for errors before using the stream object:
	
	if ($stream->error())
	  {
	  print "Cannot load sound: ", $stream->error(),"\n";
	  }

=item addTone

	$audiere->addTone( $frequenzy );

Create a stream object that produces a tone at the given C<$frequenzy>.

See also L<addStream> and L<Audio::Audiere::Stream>.

=item addSquareWave

	$audiere->addSquareWave( $frequenzy );

Create a stream object that produces a swaure wave at the given C<$frequenzy>.

See also L<addStream> and L<Audio::Audiere::Stream>.

=item addWhiteNoise

	$audiere->addWhiteNoise( );

Create a stream object that produces white noise.

See also L<addStream> and L<Audio::Audiere::Stream>.

=item addPinkNoise

	$audiere->addPinkNoise( );

Create a stream object that produces pink noise, which is noise with an equal
power distribution among octaves (logarithmic), not frequencies.

See also L<addStream> and L<Audio::Audiere::Stream>.

=item dropStream

	$audiere->dropStream($stream);

This will stop the sound playing from this stream and release it's memory. You
can also do it like this or just have C<$stream> go out of scope:

	$stream = undef;

=item dupeStream

	$second_stream = $audiere->dupeStream($stream);
	$second_stream = $stream->copy();

Create a copy of a stream. The streams will share the memory for the sound
data, but have separate volumes, positions, pan etc.

=back

See L<Audio::Audiere::Stream> for a list of methods you can call on sound
streams.

=head1 AUTHORS

(c) 2004 Tels <http://bloodgate.com/>

=head1 SEE ALSO

L<http://audiere.sf.net/>

=cut

