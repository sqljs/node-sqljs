# @(#)$Id: sql-bnf.mk,v 1.13 2005/03/11 23:19:19 jleffler Exp $
#
# Makefile for SQL-92, SQL-99 and SQL-2003 BNF and HTML files

.NO_PENDING_GET:

FILE1.bnf    = sql-92.bnf
FILE2.bnf    = sql-99.bnf
FILE3.bnf    = sql-2003-1.bnf
FILE4.bnf    = sql-2003-2.bnf
FILES.bnf    = ${FILE1.bnf} ${FILE2.bnf} ${FILE3.bnf} ${FILE4.bnf}
FILES.html   = ${FILES.bnf:bnf=bnf.html}
FILE1.aux    = index.html
FILE2.aux    = outer-joins.html
FILE3.aux    = sql-2003-core-features.html
FILE4.aux    = sql-2003-noncore-features.html
FILES.aux    = ${FILE1.aux} ${FILE2.aux} ${FILE3.aux} ${FILE4.aux}
FILE1.pl     = bnf2html.pl
FILE2.pl     = bnf2yacc.pl
FILES.pl     = ${FILE1.pl} ${FILE2.pl}
FILES.mk     = sql-bnf.mk
FILES.all    = ${FILES.bnf} ${FILES.html} ${FILES.mk} ${FILES.pl} ${FILES.aux}

FILES.tgz    = sql-bnf.tgz
RCSFILES.tgz = sql-bnf-rcs.tgz

APACHE_HOME  = /usr/apache/webserver
APACHE_HTML  = htdocs/SQL
APACHE_DIR   = ${APACHE_HOME}/${APACHE_HTML}

TAR          = tar
TARFLAGS     = -cvzf
COPY         = cp
COPYFLAGS    = -fp
PERL         = perl
RM_F         = rm -f
CHMOD        = chmod
WEBPERMS     = 444

all:	${FILES.tgz} ${RCSFILES.tgz}

${FILES.tgz}:  ${FILES.all}
	${TAR} ${TARFLAGS} ${FILES.tgz} ${FILES.all}

${RCSFILES.tgz}: RCS
	${TAR} ${TARFLAGS} ${RCSFILES.tgz} RCS

${FILES.html}: $${@:.html=} ${FILE1.pl}
	${RM} $@
	${PERL} ${FILE1.pl} ${@:.html=} > $@

install: all
	${COPY} ${COPYFLAGS} ${FILES.tgz} ${FILES.all} ${APACHE_DIR}
	cd ${APACHE_DIR}; ${CHMOD} ${WEBPERMS} ${FILES.tgz} ${FILES.all}
