#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include <stdlib.h>
#include <audiere.h>

/* ************************************************************************ */
using namespace audiere;

AudioDevice* device;

typedef OutputStream* _AudioStream;

/* ************************************************************************ */

/*
(C) by Tels <http://bloodgate.com/perl/> 
*/

MODULE = Audio::Audiere		PACKAGE = Audio::Audiere

PROTOTYPES: DISABLE
#############################################################################
        
int
_init_device(SV* classname, SV* devicename)
    CODE:
	// TODO: if devicename ne '', pass it as argument
	device = OpenDevice();
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
    RETVAL = GetVersion();
  OUTPUT:	
    RETVAL

##############################################################################
# Stream code

MODULE = Audio::Audiere		PACKAGE = Audio::Audiere::Stream

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

void
_free(_AudioStream stream)
  CODE:
    stream = NULL;

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
_setPan(_AudioStream stream, double pan)
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
_setVolume(_AudioStream stream, double vol)
  CODE:
    stream->setVolume(vol);
    RETVAL = stream->getVolume();
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

# EOF
##############################################################################

