
# Soundstreams for Audiere

package Audio::Audiere::Stream;

# (C) by Tels <http://bloodgate.com/>

use strict;

require Exporter;

use vars qw/@ISA $VERSION/;
@ISA = qw/Exporter/;

$VERSION = '0.01';

use Audio::Audiere::Error;

##############################################################################
# constructors

sub new
  {
  # create a new audio stream from file or memory
  my $class = shift;
  my ($dev, $file, $buffering) = @_;

  my $self = bless { }, $class;

  if (!-e $file)
    {
    return Audio::Audiere::Error->new(
      "Could not create stream from '$_[1]': No such file.");
    }
  
  if (!-f $file)
    {
    return Audio::Audiere::Error->new(
      "Could not create stream from '$_[1]': Not a file.");
    }

  $self->{_stream} = _open($dev, $file,$buffering);
  
  if (!$self->{_stream})
    {
    return Audio::Audiere::Error->new(
      "Unknown error. Could not create stream from '$_[1]'.");
    }
  $self;
  }

sub tone
  {
  # create a new audio stream of a tone with a certain frequenzy
  my $class = shift;
  my ($dev,$freq) = @_;

  my $self = bless { }, $class;

  $self->{_stream} = _tone($dev,$freq);
  
  if (!$self->{_stream})
    {
    return Audio::Audiere::Error->new(
      "Unknown error. Could not create stream with tone of frequenzy '$_[0]'.");
    }
  $self;
  }

sub square_wave
  {
  # create a new audio stream of a square_wave tone with a certain frequenzy
  my $class = shift;
  my ($dev,$freq) = @_;

  my $self = bless { }, $class;

  $self->{_stream} = _square_wave($dev,$freq);
  
  if (!$self->{_stream})
    {
    return Audio::Audiere::Error->new(
      "Unknown error. Could not create stream with square wave with frequenzy '$_[0]'.");
    }
  $self;
  }

sub white_noise
  {
  # create a new audio stream playing white noise
  my ($class,$dev) = @_;

  my $self = bless { }, $class;

  $self->{_stream} = _white_noise($dev);
  
  if (!$self->{_stream})
    {
    return Audio::Audiere::Error->new(
      "Unknown error. Could not create stream with white noise.");
    }
  $self;
  }

sub pink_noise
  {
  # create a new audio stream playing pink noise (which is noise with an
  # equal power distribution among octaves (logarithmic), not frequencies.
  my ($class,$dev) = @_;

  my $self = bless { }, $class;

  $self->{_stream} = _pink_noise($dev);
  
  if (!$self->{_stream})
    {
    return Audio::Audiere::Error->new(
      "Unknown error. Could not create stream with pink noise.");
    }
  $self;
  }

sub error
  {
  undef;
  }

sub DESTROY
  {
  my $self = shift;

#  print ref($self->{_stream});
#  use Devel::Peek; print Dump($self->{_stream});
#  _free_stream($self->{_stream}) if $self->{_stream};
  }

sub play
  {
  my $self = shift;
  _play($self->{_stream});
  }

sub stop
  {
  my $self = shift;
  _stop($self->{_stream});
  }

##############################################################################
# get methods

sub getPan
  {
  my $self = shift;
  _getPan($self->{_stream});
  }

sub getRepeat
  {
  my $self = shift;
  _getRepeat($self->{_stream});
  }

sub getVolume
  {
  my $self = shift;
  _getVolume($self->{_stream});
  }

sub getPosition
  {
  my $self = shift;
  _getPosition($self->{_stream});
  }

sub getPitchShift
  {
  my $self = shift;
  _getPitch($self->{_stream});
  }

sub getLength
  {
  my $self = shift;
  _getLength($self->{_stream});
  }

##############################################################################
# is... methods

sub isPlaying
  {
  my $self = shift;
  _isPlaying($self->{_stream});
  }

sub isSeekable
  {
  my $self = shift;
  _isSeekable($self->{_stream});
  }

##############################################################################
# set methods

sub setPan
  {
  my $self = shift;
  _setPan($self->{_stream},$_[0] || 0);
  }

sub setRepeat
  {
  my $self = shift;
  _setRepeat($self->{_stream},$_[0] ? 1 : 0);
  }

sub setVolume
  {
  my $self = shift;
  _setVolume($self->{_stream},$_[0] || 1);
  }

sub setPosition
  {
  my $self = shift;
  _setPosition($self->{_stream},$_[0] || 0);
  }

sub setPitchShift
  {
  my $self = shift;
  _setPitch($self->{_stream},$_[0] || 1);
  }

1; # eof

__END__

=pod

=head1 NAME

Audio::Audiere::Stream - a sound (stream) in Audio::Audiere

=head1 SYNOPSIS

See Audio::Audiere for usage and a list of methods you can use on streams.

=head1 EXPORTS

Exports nothing.

=head1 DESCRIPTION

This package provides you with individual sound streams. It should not be
used on it's own, but via Audio::Audiere.

=head1 METHODS

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

Returns true if the stream is still playing.

=item getPosition

Returns the current position in the stream.

=item setPosition

Set the current position in the stream.

=item getFormat

=item getSamples

=item getVolume

Returns the volume of the stream as a value between 0 and 1.

=item setVolume

Set the volume of the stream as a value between 0 and 1.

=item getRepeat

Returns true if the stream is repeating (aka looping).

=item setRepeat

        $stream->setRepeat(1);          # loop
        $stream->setRepeat(0);          # don't loop

If true, the stream will repeat (aka loop).

=item setPan

        $stream->setPan ( -1.0 );       # -1.0 = left, 0 = center, 1.0 = right

Set the panning of the sound from -1.0 to +1.0.

=item getPan

Returns the current panning of the sound from -1.0 to +1.0. See L<setPan>.

=back

=head1 AUTHORS

(c) 2004 Tels <http://bloodgate.com/>

=head1 SEE ALSO

L<Audio::Audiere>, L<http://audiere.sf.net/>.

=cut
