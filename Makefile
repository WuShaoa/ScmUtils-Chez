# Copyright © 2016 Federico Beffa
#
# This program is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by
# the Free Software Foundation; either version 3 of the License, or (at
# your option) any later version.
#
# This program is distributed in the hope that it will be useful, but
# WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

PACKAGE = chez-scmutils
VERSION = 0.1

CHEZ = scheme
INSTALL = install -D

PREFIX = ./local
EXEC_PREFIX = ${PREFIX}
BINDIR = ${EXEC_PREFIX}/bin
LIBDIR = ${EXEC_PREFIX}/lib
INCLUDEDIR = ${PREFIX}/include
DATAROOTDIR = ${PREFIX}/share
DATADIR = ${DATAROOTDIR}
MANDIR = ${DATAROOTDIR}/man
INFODIR = ${DATAROOTDIR}/info
DOCDIR = ${DATAROOTDIR}/doc/${PACKAGE}-${VERSION}

chezversion ::= $(shell echo '(call-with-values scheme-version-number (lambda (a b c) (format \#t "~d.~d" a b)))' | ${CHEZ} -q)
schemedir = ${LIBDIR}/csv${chezversion}-site

.PHONY: build install install-src check-schemedir clean

build:
	$(CHEZ) --compile-imported-libraries --program compile-all.ss 

install:
	find . -type f -regex ".*.so" -exec sh -c 'mkdir -p ${schemedir}/$$(dirname $$1) ; ${INSTALL} -t ${schemedir}/$$(dirname $$1) $$1' _ {} \;
	${INSTALL} -t ${DOCDIR} README doc/refman.txt
	cp run.ss ${schemedir}

install-src:
	find . -type f -regex ".*.s\(ls\|cm\)" -exec sh -c 'mkdir -p ${schemedir}/$$(dirname $$1) ; ${INSTALL} -t ${schemedir}/$$(dirname $$1) $$1' _ {} \;
	${INSTALL} -t ${schemedir} Makefile compile-all.ss run.ss

check-schemedir:
	echo ${schemedir}

clean:
	find . -name "*.so" -exec rm {} \;
	find . -name "*~" -exec rm {} \;
