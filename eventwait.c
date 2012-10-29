/* eventwait.c */

#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/inotify.h>
#include <poll.h>

int eventwait(const char *syncfile, unsigned long *serial, unsigned long timeout) {
  int ifd, wd, fd, rc;
  unsigned long current;
  struct pollfd pfd;
  struct inotify_event ev;
  ssize_t got;

  printf("eventwait(\"%s\", %lu, %lu)\n", syncfile, serial, timeout);

  ifd = inotify_init();
  if (ifd < 0) goto fail0;
  wd = inotify_add_watch(ifd, syncfile, IN_MODIFY);
  if (wd < 0) goto fail1;

  while (1) {
    fd = open(syncfile, O_RDONLY);
    if (fd < 0) goto fail1;
    got = read(fd, &current, sizeof(current));
    close(fd);
    if (got < sizeof(current)) goto fail1;

    if (current != *serial) {
      *serial = current;
      close(ifd);
      return 0;
    }

    pfd.fd = ifd;
    pfd.events = POLLIN;

    rc = poll(&pfd, 1, (int) timeout);
    if (rc < -1) goto fail1;
    if (rc == 0) {
      /* timeout */
      close(ifd);
      return 1;
    }

    got = read(ifd, &ev, sizeof(ev));
    if (got < sizeof(ev)) goto fail1;

    /* round again */
  }

fail1:
  close(ifd);
fail0:
  return -1;
}

/* vim:ts=2:sw=2:sts=2:et:ft=c
 */
