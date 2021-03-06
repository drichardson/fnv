#!/bin/make
#
# hash - makefile for FNV hash tools
#
# @(#) $Revision: 5.2 $
# @(#) $Id: Makefile,v 5.2 2012/03/21 01:42:15 chongo Exp $
# @(#) $Source: /usr/local/src/cmd/fnv/RCS/Makefile,v $
#
# See:
#	http://www.isthe.com/chongo/tech/comp/fnv/index.html
#
# for the most up to date copy of this code and the FNV hash home page.
#
# Please do not copyright this code.  This code is in the public domain.
#
# LANDON CURT NOLL DISCLAIMS ALL WARRANTIES WITH REGARD TO THIS SOFTWARE,
# INCLUDING ALL IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS. IN NO
# EVENT SHALL LANDON CURT NOLL BE LIABLE FOR ANY SPECIAL, INDIRECT OR
# CONSEQUENTIAL DAMAGES OR ANY DAMAGES WHATSOEVER RESULTING FROM LOSS OF
# USE, DATA OR PROFITS, WHETHER IN AN ACTION OF CONTRACT, NEGLIGENCE OR
# OTHER TORTIOUS ACTION, ARISING OUT OF OR IN CONNECTION WITH THE USE OR
# PERFORMANCE OF THIS SOFTWARE.
#
# By:
#	chongo <Landon Curt Noll> /\oo/\
#	http://www.isthe.com/chongo/
#
# Share and Enjoy!	:-)

# make tools
#
SHELL= /bin/sh
CFLAGS= -O3 -g3 -Werror
#CFLAGS= -O2 -g3
#CC= cc
AR= ar
TAR= tar
EGREP= egrep
GZIP_BIN= gzip
INSTALL= install

# If your system needs ranlib use:
#	RANLIB= ranlib
# otherwise use:
#	RANLIB= :
#
#RANLIB= ranlib
RANLIB= :

# where to install things
#
DESTBIN= /usr/local/bin
DESTLIB= /usr/local/lib
DESTINC= /usr/local/include

# what to build
#
SRC=	hash_32.c hash_32a.c hash_64.c hash_64a.c \
	fnv32.c fnv64.c \
	have_ulong64.c test_fnv.c
HSRC=	fnv.h
ALL=	${SRC} ${HSRC} \
	README Makefile
PROGS=	fnv032 fnv064 fnv132 fnv164 fnv1a32 fnv1a64
LIBS=	libfnv.a
LIBOBJ=	hash_32.o hash_64.o hash_32a.o hash_64a.o test_fnv.o
OTHEROBJ= fnv32.o fnv64.o
TARGETS= ${LIBOBJ} ${LIBS} ${PROGS}

# default rule
#
all: ${TARGETS}

# things to build
#
hash_32.o: hash_32.c fnv.h
	${CC} ${CFLAGS} hash_32.c -c

hash_64.o: hash_64.c fnv.h
	${CC} ${CFLAGS} hash_64.c -c

hash_32a.o: hash_32a.c fnv.h
	${CC} ${CFLAGS} hash_32a.c -c

hash_64a.o: hash_64a.c fnv.h
	${CC} ${CFLAGS} hash_64a.c -c

test_fnv.o: test_fnv.c fnv.h
	${CC} ${CFLAGS} test_fnv.c -c

fnv32.o: fnv32.c fnv.h
	${CC} ${CFLAGS} fnv32.c -c

fnv032: fnv32.o libfnv.a
	${CC} fnv32.o libfnv.a -o fnv032

fnv64.o: fnv64.c fnv.h
	${CC} ${CFLAGS} fnv64.c -c

fnv064: fnv64.o libfnv.a
	${CC} fnv64.o libfnv.a -o fnv064

libfnv.a: ${LIBOBJ}
	rm -f $@
	${AR} rv $@ ${LIBOBJ}
	${RANLIB} $@

fnv132: fnv032
	-rm -f $@
	-cp -f $? $@

fnv1a32: fnv032
	-rm -f $@
	-cp -f $? $@

fnv164: fnv064
	-rm -f $@
	-cp -f $? $@

fnv1a64: fnv064
	-rm -f $@
	-cp -f $? $@

# utilities
#
install: all
	-@if [ -d "${DESTBIN}" ]; then \
	    echo "	mkdir -p ${DESTBIN}"; \
	    mkdir -p ${DESTBIN}; \
	fi
	-@if [ -d "${DESTLIB}" ]; then \
	    echo "	mkdir -p ${DESTLIB}"; \
	    mkdir -p ${DESTLIB}; \
	fi
	-@if [ -d "${DESTINC}" ]; then \
	    echo "	mkdir -p ${DESTINC}"; \
	    mkdir -p ${DESTINC}; \
	fi
	${INSTALL} -m 0755 ${PROGS} ${DESTBIN}
	${INSTALL} -m 0644 ${LIBS} ${DESTLIB}
	${RANLIB} ${DESTLIB}/libfnv.a
	${INSTALL} -m 0644 ${HSRC} ${DESTINC}

clean:
	-rm -f have_ulong64 have_ulong64.o ll_tmp ll_tmp2
	-rm -f ${LIBOBJ}
	-rm -f ${OTHEROBJ}
	-rm -f ${TARGETS}
	-rm -f vector.c

check: ${PROGS}
	@echo -n "FNV-0 32 bit tests: "
	@./fnv032 -t 1 -v
	@echo -n "FNV-1 32 bit tests: "
	@./fnv132 -t 1 -v
	@echo -n "FNV-1a 32 bit tests: "
	@./fnv1a32 -t 1 -v
	@echo -n "FNV-0 64 bit tests: "
	@./fnv064 -t 1 -v
	@echo -n "FNV-1 64 bit tests: "
	@./fnv164 -t 1 -v
	@echo -n "FNV-1a 64 bit tests: "
	@./fnv1a64 -t 1 -v

###############################
# generate test vector source #
###############################

vector.c: ${PROGS}
	-rm -f $@
	echo '/* start of output generated by make $@ */' >> $@
	echo '' >> $@
	#@
	echo '/* FNV-0 32 bit test vectors */' >> $@
	./fnv032 -t 0 >> $@
	echo '' >> $@
	#@
	echo '/* FNV-1 32 bit test vectors */' >> $@
	./fnv132 -t 0 >> $@
	echo '' >> $@
	#@
	echo '/* FNV-1a 32 bit test vectors */' >> $@
	./fnv1a32 -t 0 >> $@
	echo '' >> $@
	#@
	echo '/* FNV-0 64 bit test vectors */' >> $@
	./fnv064 -t 0 >> $@
	echo '' >> $@
	#@
	echo '/* FNV-1 64 bit test vectors */' >> $@
	./fnv164 -t 0 >> $@
	echo '' >> $@
	#@
	echo '/* FNV-1a 64 bit test vectors */' >> $@
	./fnv1a64 -t 0 >> $@
	echo '' >> $@
	#@
	echo '/* end of output generated by make $@ */' >> $@
