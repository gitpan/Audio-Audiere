
# Soundstreams for Audiere

package Audio::Audiere::Stream;

# (C) by Tels <http://bloodgate.com/>

use strict;

require Exporter;

use vars qw/@ISA $VERSION/;
@ISA = qw/Exporter/;

$VERSION = '0.01';

##############################################################################

sub new
  {
  # create a new instance of Audio::Audiere - there can be only one
  my $class = shift;

  my $self = bless { }, $class;

  $self->{_stream} = _open(@_);
  $self;
  }

sub DESTROY
  {
#  my $self = shift;
#
#  _free($self->{_stream});
#  $self->_fredrop_device();
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

See Audio::Audiere for usage.

=head1 EXPORTS

Exports nothing.

=head1 DESCRIPTION

This package provides you with individual sound streams. It should not be
used on it's own, but via Audio::Audiere.

=head1 AUTHORS

(c) 2004 Tels <http://bloodgate.com/>

=head1 SEE ALSO

L>Audio::Audiere>, L<http://audiere.sf.net/>.

=cut

