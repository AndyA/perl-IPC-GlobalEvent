/* GlobalEvent.xs */

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include <stdio.h>

#include "eventwait.h"

/* *INDENT-OFF* */

MODULE = IPC::GlobalEvent PACKAGE = IPC::GlobalEvent
PROTOTYPES: ENABLE

void
eventsignal(syncfile, serial)
const char *syncfile;
unsigned long serial;
PPCODE:
{
  int rc = eventsignal(syncfile, serial);
  if (rc < 0) croak("Error in eventsignal: %s", strerror(errno));
}

IV
eventwait(syncfile, serial, timeout)
const char *syncfile;
unsigned long serial;
unsigned long timeout;
PPCODE:
{
  int rc = eventwait(syncfile, &serial, timeout);
  if (rc < 0) croak("Error in eventwait: %s", strerror(errno));
  XSRETURN_IV(serial);
}
