
# Use Audiere (http://audiere.sf.net) in Perl

package Audio::Audiere;

# (C) by Tels <http://bloodgate.com/>

use strict;

require DynaLoader;
require Exporter;

use vars qw/@ISA $VERSION @EXPORT_OK/;
@ISA = qw/Exporter DynaLoader/;

@EXPORT_OK = qw/AUDIO_STREAM AUDIO_BUFFER/;

$VERSION = '0.01';

bootstrap Audio::Audiere $VERSION;

use Audio::Audiere::Stream;

use constant AUDIO_STREAM => 0;
use constant AUDIO_BUFFER => 1;

{
  # protected vars
  my $in_use = 0;

  sub _alloc_device
    {
    if ($in_use > 0)
      {
      require Carp;
      Carp::croak ("Audiere device already in use - cannot claim it again.");
      }
    $in_use ++;
    }
  sub _free_device
    {
    if ($in_use <= 0)
      {
      require Carp;
      Carp::croak ("Audiere device not in use - cannot free it again.");
      }
    $in_use --;
    }
  sub _device_in_use { $in_use; }
}

##############################################################################

sub new
  {
  # create a new instance of Audio::Audiere - there can be only one
  my $class = shift;
  my $self = {}; bless $self, $class;

  $self->{error} = '';
  _alloc_device();
  if (!$self->_init_device( $_[0] ))
    {
    $self->{error} = 'Cannot init Audiere device';
    _free_device();
    }

  $self;
  }

sub DESTROY
  {
  my $self = shift;

  _free_device();
  $self->_drop_device();
  }

##############################################################################

sub addStream
  {
  my $self = shift;

  Audio::Audiere::Stream->new(@_);
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

	if ($audiere->error() ne '')
	  {
	  die ("Cannot get audio device: ". print $audiere->error());
	  }

	# now we have the driver, add some sound streams

	# stream the sound from the disk
	my $stream = $audiere->addStream( 'media/sample.ogg', AUDIO_STREAM);
	
	# load sound into memory (if possible), this is also the default
	my $sound = $audiere->addStream( 'media/effect.wav', AUDIO_BUFFER);

	$stream->setVolume(0.5);	# 50%
	$stream->setRepeat(1);		# loooop
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
	
	my $audiere = Audio::Audiere->new( $device );

Creates a new object that holds the I<Audiere> driver to the optional
C<$device>.

There is only one of them and it will croak if you try to create a second one.
When C<$audiere> goes out of scope or is set to undef, the Audiere driver will
be automatically released.

In case you wonder how you can play multiple sounds at once: these are handled
as separate streams, and once you have the Audiere driver, you can add (almost
infinitely) many of them via L<addStream>.

=item getVersion

Returns the version of Audiere you are using as string.

=item addStream

	$stream = $audiere->addStream( $file, $stream_flag )

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

=item getPitchShift

=back

=head2 Internal Methods

You should not use these methods:

=over 2

=item _alloc_device()

Increments the ref count on the driver to ensure only one is active at a time.

=item _free_device()

Decrements the ref count on the driver to ensure only one is active at a time.

=item _device_in_use()

Return true if the Audiere device is already in use.

=back

=head1 AUTHORS

(c) 2004 Tels <http://bloodgate.com/>

=head1 SEE ALSO

L<http://audiere.sf.net/>

=cut

