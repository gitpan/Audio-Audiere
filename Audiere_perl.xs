/* these two need to be on top for win32 */
#include <stdlib.h>
#include <audiere.h>

/* normal perl includes */

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

/* ************************************************************************ */
using namespace audiere;

AudioDevice* device;

typedef OutputStream* _AudioStream;

/* ************************************************************************ */

/*
(C) by Tels <http://bloodgate.com/perl/> 
*/

MODULE = Audio::Audiere::Audiere_perl	PACKAGE = Audio::Audiere

PROTOTYPES: DISABLE
#############################################################################
        
int
_init_device(SV* classname, char* devicename, char* parameters)
    CODE:
	device = OpenDevice(devicename, parameters);
	RETVAL = 1;
	if (NULL == device)
	  {
 	  // failure
	  RETVAL = 0;
	  }
    OUTPUT:
        RETVAL

void
_drop_device(SV* classname)
    CODE:
        device = NULL;

const char*
getVersion(SV* classname)
  PREINIT:
  CODE:
    RETVAL = audiere::GetVersion();
  OUTPUT:	
    RETVAL

const char*
getName(SV* classname)
  PREINIT:
  CODE:
    RETVAL = device->getName();
  OUTPUT:	
    RETVAL

##############################################################################
# Stream code

MODULE = Audio::Audiere::Audiere_perl	PACKAGE = Audio::Audiere::Stream

_AudioStream
_open(char* filename, bool buffer)
  PREINIT:
    OutputStream* stream;
  CODE:
     stream = OpenSound(device, filename, buffer);
     if (!stream) 
       {
       // failure
       RETVAL = NULL;
       }
     else
       {
       RETVAL = stream;
       }
  OUTPUT:
    RETVAL

_AudioStream
_tone(double frequenzy)
  PREINIT:
    OutputStream* stream;
  CODE:
     stream = OpenSound(device, CreateTone(frequenzy), false);
     if (!stream) 
       {
       // failure
       RETVAL = NULL;
       }
     else
       {
       RETVAL = stream;
       }
  OUTPUT:
    RETVAL

_AudioStream
_square_wave(double frequenzy)
  PREINIT:
    OutputStream* stream;
  CODE:
     stream = OpenSound(device, CreateSquareWave(frequenzy), false);
     if (!stream) 
       {
       // failure
       RETVAL = NULL;
       }
     else
       {
       RETVAL = stream;
       }
  OUTPUT:
    RETVAL

_AudioStream
_white_noise()
  PREINIT:
    OutputStream* stream;
  CODE:
     stream = OpenSound(device, CreateWhiteNoise(), false);
     if (!stream) 
       {
       // failure
       RETVAL = NULL;
       }
     else
       {
       RETVAL = stream;
       }
  OUTPUT:
    RETVAL

_AudioStream
_pink_noise()
  PREINIT:
    OutputStream* stream;
  CODE:
     stream = OpenSound(device, CreatePinkNoise(), false);
     if (!stream) 
       {
       // failure
       RETVAL = NULL;
       }
     else
       {
       RETVAL = stream;
       }
  OUTPUT:
    RETVAL


void
_free_stream(_AudioStream stream)
  CODE:
    stream->unref(); /* = NULL; */

void
_play(_AudioStream stream)
  CODE:
    stream->play();

void
_stop(_AudioStream stream)
  CODE:
    stream->stop();

int
_getLength(_AudioStream stream)
  CODE:
    RETVAL = stream->getLength();
  OUTPUT:
    RETVAL

float
_getPan(_AudioStream stream)
  CODE:
    RETVAL = stream->getPan();
  OUTPUT:
    RETVAL

float
_setPan(_AudioStream stream, float pan)
  CODE:
    stream->setPan(pan);
    RETVAL = stream->getPan();
  OUTPUT:
    RETVAL


float
_getVolume(_AudioStream stream)
  CODE:
    RETVAL = stream->getVolume();
  OUTPUT:
    RETVAL

float
_setVolume(_AudioStream stream, float vol)
  CODE:
    stream->setVolume(vol);
    RETVAL = stream->getVolume();
  OUTPUT:
    RETVAL


unsigned int
_getPosition(_AudioStream stream)
  CODE:
    RETVAL = stream->getPosition();
  OUTPUT:
    RETVAL

unsigned int
_setPosition(_AudioStream stream, int pos)
  CODE:
    stream->setPosition(pos);
    RETVAL = stream->getPosition();
  OUTPUT:
    RETVAL


float
_getRepeat(_AudioStream stream)
  CODE:
    RETVAL = stream->getRepeat();
  OUTPUT:
    RETVAL

bool
_setRepeat(_AudioStream stream, bool rep)
  CODE:
    stream->setRepeat(rep);
    RETVAL = stream->getRepeat();
  OUTPUT:
    RETVAL


float
_getPitch(_AudioStream stream)
  CODE:
    RETVAL = stream->getPitchShift();
  OUTPUT:
    RETVAL

float
_setPitch(_AudioStream stream, double pitch)
  CODE:
    stream->setPitchShift(pitch);
    RETVAL = stream->getPitchShift();
  OUTPUT:
    RETVAL

##############################################################################

bool
_isPlaying(_AudioStream stream)
  CODE:
    RETVAL = stream->isPlaying();
  OUTPUT:
    RETVAL

bool
_isSeekable(_AudioStream stream)
  CODE:
    RETVAL = stream->isSeekable();
  OUTPUT:
    RETVAL


# EOF
##############################################################################

