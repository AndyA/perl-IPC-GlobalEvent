/* eventwait.h */

#ifndef __EVENTWAIT_H
#define __EVENTWAIT_H

int eventsignal(const char *syncfile, unsigned long serial);
int eventwait(const char *syncfile, unsigned long *serial, unsigned long timeout);

#endif

/* vim:ts=2:sw=2:sts=2:et:ft=c
 */
