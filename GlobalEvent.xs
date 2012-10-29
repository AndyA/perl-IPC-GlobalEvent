/* GlobalEvent.xs */

#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"
#include <stdio.h>

#include "eventwait.h"

/* *INDENT-OFF* */

MODULE = IPC::GlobalEvent PACKAGE = IPC::GlobalEvent
PROTOTYPES: ENABLE

IV
eventwait(syncfile, serial, timeout)
const char *syncfile;
long serial;
long timeout;
PPCODE:
{
  int rc = eventwait(syncfile, &serial, timeout);
  if (rc < 0) croak("Error in eventwait");
  XSRETURN_IV(serial);
}
