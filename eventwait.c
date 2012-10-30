/* eventwait.c */

#include <errno.h>
#include <fcntl.h>
#include <poll.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <sys/inotify.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>

static char *joins(const char *a, const char *b) {
  size_t la = strlen(a);
  size_t lb = strlen(b);
  char *buf = malloc(la + lb + 1);
  if (!buf) {
    errno = ENOMEM;
    return NULL;
  }
  memcpy(buf, a, la);
  memcpy(buf + la, b, lb + 1);
  return buf;
}

int eventsignal(const char *syncfile, unsigned long serial) {
  char *tmp = joins(syncfile, ".tmp");
  ssize_t got;
  int fd, rc = -1;

  if (!tmp) goto fail0;
  if (fd = creat(tmp, 0777), fd < 0) goto fail1;
  got = write(fd, &serial, sizeof(serial));
  if (close(fd) < 0) goto fail1;
  if (got < sizeof(serial)) goto fail1;
  rc = rename(tmp, syncfile);

fail1:
  free(tmp);
fail0:
  return rc;
}

int eventwait(const char *syncfile, unsigned long *serial, unsigned long timeout) {
  int ifd, wd, fd, rc;
  unsigned long current;
  struct pollfd pfd;
  char inobuf[1024];
  ssize_t got;

  /*  printf("eventwait(\"%s\", %p, %lu)\n", syncfile, serial, timeout);*/

  while (1) {
    if (ifd = inotify_init(), ifd < 0) goto fail0;
    if (wd = inotify_add_watch(ifd, syncfile, IN_MODIFY | IN_DELETE_SELF), wd < 0) goto fail1;

    if (fd = open(syncfile, O_RDONLY), fd < 0) goto fail1;
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

    if (rc = poll(&pfd, 1, (int) timeout), rc < -1) goto fail1;
    if (rc == 0) {
      /* timeout */
      close(ifd);
      return 1;
    }

    /* drain events. We don't really care what they are */
    while (1) {
      got = read(ifd, inobuf, sizeof(inobuf));
      if (got < 0) goto fail1;
      if (got < sizeof(inobuf)) break;
    }

    close(ifd);

    /* round again */
  }

fail1:
  close(ifd);
fail0:
  return -1;
}

/* vim:ts=2:sw=2:sts=2:et:ft=c
 */
