# Generated automatically from Makefile.in by configure.
# OutGuess 0.1 Makefile (c) 1999 Niels Provos

srcdir		= .

install_prefix	=
prefix		= /usr/local
exec_prefix	= ${prefix}
bindir		= ${exec_prefix}/bin
mandir		= ${prefix}/man/man1

CC		= gcc -DWIN32
CFLAGS		= -O2 -Imissing $(JPEGINCS)
LDFLAGS		= -s -flto
LIBS		= -static $(JPEGLIBS) -lm

INSTALL		= /bin/install -c
INSTALL_PROG	= ${INSTALL}
INSTALL_DATA	= ${INSTALL} -m 644

JPEGDIR		= ./jpeg-6b-steg
JPEGINCS	= -I$(JPEGDIR)
JPEGLIBS	= -L$(JPEGDIR) -ljpeg
JPEGDEP		= $(JPEGDIR)/libjpeg.a

# Use fourier functions
# CFLAGS	+= -DFOURIER -I/usr/local/include
# LIBS		+= -L/usr/local/lib -lrfftw -lfftw

MISSING		=  md5.o err.o
OBJ		= outguess.o golay.o arc.o pnm.o jpg.o iterator.o

all: outguess extract histogram

$(MISSING):
	$(CC) $(CFLAGS) $(INCS) -c  missing/md5.c missing/err.c

outguess: $(JPEGDEP) $(OBJ) $(MISSING)
	$(CC) $(CFLAGS) $(INCS) -o $@ $(OBJ) $(MISSING) $(LDFLAGS) $(LIBS) -lws2_32

histogram: histogram.o $(MISSING)
	$(CC) $(CFLAGS) $(INCS) -o $@ histogram.o $(MISSING) -s -lws2_32

extract: outguess
	ln -sf outguess $@

$(JPEGDEP):
	cd $(JPEGDIR); $(MAKE) libjpeg.a

install: all
	$(INSTALL_PROG) -m 755 outguess $(install_prefix)$(bindir)
	$(INSTALL_DATA) outguess.1 $(install_prefix)$(mandir)

clean:
	rm -f outguess extract histogram histogram.o *~ $(OBJ) $(MISSING)

distclean: clean
	cd $(JPEGDIR); $(MAKE) $@
	rm -f Makefile config.h config.status config.cache config.log
