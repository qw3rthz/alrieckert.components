#
# Don't edit, this file is generated by FPCMake Version 1.1 [2003/11/15]
#
default: all
MAKEFILETARGETS=linux go32v2 win32 os2 freebsd beos netbsd amiga atari sunos qnx netware openbsd wdosx palmos macos darwin emx watcom
override PATH:=$(subst \,/,$(PATH))
ifeq ($(findstring ;,$(PATH)),)
inUnix=1
SEARCHPATH:=$(filter-out .,$(subst :, ,$(PATH)))
else
SEARCHPATH:=$(subst ;, ,$(PATH))
endif
SEARCHPATH+=$(patsubst %/,%,$(dir $(MAKE)))
PWD:=$(strip $(wildcard $(addsuffix /pwd.exe,$(SEARCHPATH))))
ifeq ($(PWD),)
PWD:=$(strip $(wildcard $(addsuffix /pwd,$(SEARCHPATH))))
ifeq ($(PWD),)
$(error You need the GNU utils package to use this Makefile)
else
PWD:=$(firstword $(PWD))
SRCEXEEXT=
endif
else
PWD:=$(firstword $(PWD))
SRCEXEEXT=.exe
endif
ifndef inUnix
ifeq ($(OS),Windows_NT)
inWinNT=1
else
ifdef OS2_SHELL
inOS2=1
endif
endif
else
ifneq ($(findstring cygdrive,$(PATH)),)
inCygWin=1
endif
endif
ifeq ($(OS_TARGET),freebsd)
BSDhier=1
endif
ifeq ($(OS_TARGET),netbsd)
BSDhier=1
endif
ifeq ($(OS_TARGET),openbsd)
BSDhier=1
endif
ifdef inUnix
BATCHEXT=.sh
else
ifdef inOS2
BATCHEXT=.cmd
else
BATCHEXT=.bat
endif
endif
ifdef inUnix
PATHSEP=/
else
PATHSEP:=$(subst /,\,/)
ifdef inCygWin
PATHSEP=/
endif
endif
ifdef PWD
BASEDIR:=$(subst \,/,$(shell $(PWD)))
ifdef inCygWin
ifneq ($(findstring /cygdrive/,$(BASEDIR)),)
BASENODIR:=$(patsubst /cygdrive%,%,$(BASEDIR))
BASEDRIVE:=$(firstword $(subst /, ,$(BASENODIR)))
BASEDIR:=$(subst /cygdrive/$(BASEDRIVE)/,$(BASEDRIVE):/,$(BASEDIR))
endif
endif
else
BASEDIR=.
endif
ifdef inOS2
ifndef ECHO
ECHO:=$(strip $(wildcard $(addsuffix /gecho$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(ECHO),)
ECHO:=$(strip $(wildcard $(addsuffix /echo$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(ECHO),)
ECHO=echo
else
ECHO:=$(firstword $(ECHO))
endif
else
ECHO:=$(firstword $(ECHO))
endif
endif
export ECHO
endif
ifndef FPC
ifdef PP
FPC=$(PP)
endif
endif
ifndef FPC
FPCPROG:=$(strip $(wildcard $(addsuffix /fpc$(SRCEXEEXT),$(SEARCHPATH))))
ifneq ($(FPCPROG),)
FPCPROG:=$(firstword $(FPCPROG))
FPC:=$(shell $(FPCPROG) -PB)
ifneq ($(findstring Error,$(FPC)),)
override FPC=ppc386
endif
else
override FPC=ppc386
endif
endif
override FPC:=$(subst $(SRCEXEEXT),,$(FPC))
override FPC:=$(subst \,/,$(FPC))$(SRCEXEEXT)
ifndef FPC_VERSION
FPC_COMPILERINFO:=$(shell $(FPC) -iVSPTPSOTO)
FPC_VERSION:=$(word 1,$(FPC_COMPILERINFO))
endif
export FPC FPC_VERSION FPC_COMPILERINFO
unexport CHECKDEPEND ALLDEPENDENCIES
ifndef CPU_TARGET
ifdef CPU_TARGET_DEFAULT
CPU_TARGET=$(CPU_TARGET_DEFAULT)
endif
endif
ifndef OS_TARGET
ifdef OS_TARGET_DEFAULT
OS_TARGET=$(OS_TARGET_DEFAULT)
endif
endif
ifneq ($(words $(FPC_COMPILERINFO)),5)
FPC_COMPILERINFO+=$(shell $(FPC) -iSP)
FPC_COMPILERINFO+=$(shell $(FPC) -iTP)
FPC_COMPILERINFO+=$(shell $(FPC) -iSO)
FPC_COMPILERINFO+=$(shell $(FPC) -iTO)
endif
ifndef CPU_SOURCE
CPU_SOURCE:=$(word 2,$(FPC_COMPILERINFO))
endif
ifndef CPU_TARGET
CPU_TARGET:=$(word 3,$(FPC_COMPILERINFO))
endif
ifndef OS_SOURCE
OS_SOURCE:=$(word 4,$(FPC_COMPILERINFO))
endif
ifndef OS_TARGET
OS_TARGET:=$(word 5,$(FPC_COMPILERINFO))
endif
FULL_TARGET=$(CPU_TARGET)-$(OS_TARGET)
FULL_SOURCE=$(CPU_SOURCE)-$(OS_SOURCE)
ifneq ($(FULL_TARGET),$(FULL_SOURCE))
CROSSCOMPILE=1
endif
ifeq ($(findstring makefile,$(MAKECMDGOALS)),)
ifeq ($(findstring $(OS_TARGET),$(MAKEFILETARGETS)),)
$(error The Makefile doesn't support target $(OS_TARGET), please run fpcmake first)
endif
endif
export OS_TARGET OS_SOURCE CPU_TARGET CPU_SOURCE FULL_TARGET FULL_SOURCE CROSSCOMPILE
ifdef FPCDIR
override FPCDIR:=$(subst \,/,$(FPCDIR))
ifeq ($(wildcard $(addprefix $(FPCDIR)/,rtl units)),)
override FPCDIR=wrong
endif
else
override FPCDIR=wrong
endif
ifdef DEFAULT_FPCDIR
ifeq ($(FPCDIR),wrong)
override FPCDIR:=$(subst \,/,$(DEFAULT_FPCDIR))
ifeq ($(wildcard $(addprefix $(FPCDIR)/,rtl units)),)
override FPCDIR=wrong
endif
endif
endif
ifeq ($(FPCDIR),wrong)
ifdef inUnix
override FPCDIR=/usr/local/lib/fpc/$(FPC_VERSION)
ifeq ($(wildcard $(FPCDIR)/units),)
override FPCDIR=/usr/lib/fpc/$(FPC_VERSION)
endif
else
override FPCDIR:=$(subst /$(FPC),,$(firstword $(strip $(wildcard $(addsuffix /$(FPC),$(SEARCHPATH))))))
override FPCDIR:=$(FPCDIR)/..
ifeq ($(wildcard $(addprefix $(FPCDIR)/,rtl units)),)
override FPCDIR:=$(FPCDIR)/..
ifeq ($(wildcard $(addprefix $(FPCDIR)/,rtl units)),)
override FPCDIR=c:/pp
endif
endif
endif
endif
ifndef CROSSDIR
CROSSDIR:=$(FPCDIR)/cross/$(FULL_TARGET)
endif
ifndef CROSSTARGETDIR
CROSSTARGETDIR=$(CROSSDIR)/$(FULL_TARGET)
endif
ifdef CROSSCOMPILE
UNITSDIR:=$(wildcard $(CROSSTARGETDIR)/units)
ifeq ($(UNITSDIR),)
UNITSDIR:=$(wildcard $(FPCDIR)/units/$(OS_TARGET))
endif
else
UNITSDIR:=$(wildcard $(FPCDIR)/units/$(OS_TARGET))
endif
PACKAGESDIR:=$(wildcard $(FPCDIR) $(FPCDIR)/packages/base $(FPCDIR)/packages/extra)
override TARGET_DIRS+=synedit codetools
override CLEAN_FILES+=$(wildcard ./units/*$(OEXT)) $(wildcard ./units/*$(PPUEXT)) $(wildcard ./units/*$(RSTEXT)) $(wildcard ./units/$(CPU_TARGET)/$(OS_TARGET)/*$(OEXT)) $(wildcard ./units/$(CPU_TARGET)/$(OS_TARGET)/*$(PPUEXT)) $(wildcard ./units/$(CPU_TARGET)/$(OS_TARGET)/*$(RSTEXT)) $(wildcard ./custom/*$(OEXT)) $(wildcard ./custom/*$(PPUEXT)) $(wildcard ./custom/*$(RSTEXT))
ifdef REQUIRE_UNITSDIR
override UNITSDIR+=$(REQUIRE_UNITSDIR)
endif
ifdef REQUIRE_PACKAGESDIR
override PACKAGESDIR+=$(REQUIRE_PACKAGESDIR)
endif
ifdef ZIPINSTALL
ifeq ($(OS_TARGET),linux)
UNIXINSTALLDIR=1
endif
ifeq ($(OS_TARGET),freebsd)
UNIXINSTALLDIR=1
endif
ifeq ($(OS_TARGET),netbsd)
UNIXINSTALLDIR=1
endif
ifeq ($(OS_TARGET),openbsd)
UNIXINSTALLDIR=1
endif
ifeq ($(OS_TARGET),sunos)
UNIXINSTALLDIR=1
endif
ifeq ($(OS_TARGET),qnx)
UNIXINSTALLDIR=1
endif
else
ifeq ($(OS_SOURCE),linux)
UNIXINSTALLDIR=1
endif
ifeq ($(OS_SOURCE),freebsd)
UNIXINSTALLDIR=1
endif
ifeq ($(OS_SOURCE),netbsd)
UNIXINSTALLDIR=1
endif
ifeq ($(OS_SOURCE),openbsd)
UNIXINSTALLDIR=1
endif
ifeq ($(OS_TARGET),sunos)
UNIXINSTALLDIR=1
endif
ifeq ($(OS_TARGET),qnx)
UNIXINSTALLDIR=1
endif
endif
ifndef INSTALL_PREFIX
ifdef PREFIX
INSTALL_PREFIX=$(PREFIX)
endif
endif
ifndef INSTALL_PREFIX
ifdef UNIXINSTALLDIR
INSTALL_PREFIX=/usr/local
else
ifdef INSTALL_FPCPACKAGE
INSTALL_BASEDIR:=/pp
else
INSTALL_BASEDIR:=/$(PACKAGE_NAME)
endif
endif
endif
export INSTALL_PREFIX
ifdef INSTALL_FPCSUBDIR
export INSTALL_FPCSUBDIR
endif
ifndef DIST_DESTDIR
DIST_DESTDIR:=$(BASEDIR)
endif
export DIST_DESTDIR
ifndef INSTALL_BASEDIR
ifdef UNIXINSTALLDIR
ifdef INSTALL_FPCPACKAGE
INSTALL_BASEDIR:=$(INSTALL_PREFIX)/lib/fpc/$(FPC_VERSION)
else
INSTALL_BASEDIR:=$(INSTALL_PREFIX)/lib/$(PACKAGE_NAME)
endif
else
INSTALL_BASEDIR:=$(INSTALL_PREFIX)
endif
endif
ifndef INSTALL_BINDIR
ifdef UNIXINSTALLDIR
INSTALL_BINDIR:=$(INSTALL_PREFIX)/bin
else
INSTALL_BINDIR:=$(INSTALL_BASEDIR)/bin
ifdef INSTALL_FPCPACKAGE
INSTALL_BINDIR:=$(INSTALL_BINDIR)/$(OS_TARGET)
endif
endif
endif
ifndef INSTALL_UNITDIR
ifdef CROSSCOMPILE
INSTALL_UNITDIR:=$(INSTALL_BASEDIR)/cross/$(FULL_TARGET)/units
else
INSTALL_UNITDIR:=$(INSTALL_BASEDIR)/units/$(OS_TARGET)
endif
ifdef INSTALL_FPCPACKAGE
ifdef PACKAGE_NAME
INSTALL_UNITDIR:=$(INSTALL_UNITDIR)/$(PACKAGE_NAME)
endif
endif
endif
ifndef INSTALL_LIBDIR
ifdef UNIXINSTALLDIR
INSTALL_LIBDIR:=$(INSTALL_PREFIX)/lib
else
INSTALL_LIBDIR:=$(INSTALL_UNITDIR)
endif
endif
ifndef INSTALL_SOURCEDIR
ifdef UNIXINSTALLDIR
ifdef BSDhier
SRCPREFIXDIR=share/src
else
SRCPREFIXDIR=src
endif
ifdef INSTALL_FPCPACKAGE
ifdef INSTALL_FPCSUBDIR
INSTALL_SOURCEDIR:=$(INSTALL_PREFIX)/$(SRCPREFIXDIR)/fpc-$(FPC_VERSION)/$(INSTALL_FPCSUBDIR)/$(PACKAGE_NAME)
else
INSTALL_SOURCEDIR:=$(INSTALL_PREFIX)/$(SRCPREFIXDIR)/fpc-$(FPC_VERSION)/$(PACKAGE_NAME)
endif
else
INSTALL_SOURCEDIR:=$(INSTALL_PREFIX)/$(SRCPREFIXDIR)/$(PACKAGE_NAME)-$(PACKAGE_VERSION)
endif
else
ifdef INSTALL_FPCPACKAGE
ifdef INSTALL_FPCSUBDIR
INSTALL_SOURCEDIR:=$(INSTALL_BASEDIR)/source/$(INSTALL_FPCSUBDIR)/$(PACKAGE_NAME)
else
INSTALL_SOURCEDIR:=$(INSTALL_BASEDIR)/source/$(PACKAGE_NAME)
endif
else
INSTALL_SOURCEDIR:=$(INSTALL_BASEDIR)/source
endif
endif
endif
ifndef INSTALL_DOCDIR
ifdef UNIXINSTALLDIR
ifdef BSDhier
DOCPREFIXDIR=share/doc
else
DOCPREFIXDIR=doc
endif
ifdef INSTALL_FPCPACKAGE
INSTALL_DOCDIR:=$(INSTALL_PREFIX)/$(DOCPREFIXDIR)/fpc-$(FPC_VERSION)/$(PACKAGE_NAME)
else
INSTALL_DOCDIR:=$(INSTALL_PREFIX)/$(DOCPREFIXDIR)/$(PACKAGE_NAME)-$(PACKAGE_VERSION)
endif
else
ifdef INSTALL_FPCPACKAGE
INSTALL_DOCDIR:=$(INSTALL_BASEDIR)/doc/$(PACKAGE_NAME)
else
INSTALL_DOCDIR:=$(INSTALL_BASEDIR)/doc
endif
endif
endif
ifndef INSTALL_EXAMPLEDIR
ifdef UNIXINSTALLDIR
ifdef INSTALL_FPCPACKAGE
ifdef BSDhier
INSTALL_EXAMPLEDIR:=$(INSTALL_PREFIX)/share/examples/fpc-$(FPC_VERSION)/$(PACKAGE_NAME)
else
INSTALL_EXAMPLEDIR:=$(INSTALL_PREFIX)/doc/fpc-$(FPC_VERSION)/examples/$(PACKAGE_NAME)
endif
else
ifdef BSDhier
INSTALL_EXAMPLEDIR:=$(INSTALL_PREFIX)/share/examples/$(PACKAGE_NAME)-$(PACKAGE_VERSION)
else
INSTALL_EXAMPLEDIR:=$(INSTALL_PREFIX)/doc/$(PACKAGE_NAME)-$(PACKAGE_VERSION)
endif
endif
else
ifdef INSTALL_FPCPACKAGE
INSTALL_EXAMPLEDIR:=$(INSTALL_BASEDIR)/examples/$(PACKAGE_NAME)
else
INSTALL_EXAMPLEDIR:=$(INSTALL_BASEDIR)/examples
endif
endif
endif
ifndef INSTALL_DATADIR
INSTALL_DATADIR=$(INSTALL_BASEDIR)
endif
ifdef CROSSCOMPILE
ifndef CROSSBINDIR
CROSSBINDIR:=$(wildcard $(CROSSTARGETDIR)/bin/$(FULL_SOURCE))
ifeq ($(CROSSBINDIR),)
CROSSBINDIR:=$(wildcard $(INSTALL_BASEDIR)/cross/$(FULL_TARGET)/bin/$(FULL_SOURCE))
endif
endif
else
CROSSBINDIR=
endif
LOADEREXT=.as
EXEEXT=.exe
PPLEXT=.ppl
PPUEXT=.ppu
OEXT=.o
ASMEXT=.s
SMARTEXT=.sl
STATICLIBEXT=.a
SHAREDLIBEXT=.so
STATICLIBPREFIX=libp
RSTEXT=.rst
FPCMADE=fpcmade
ifeq ($(findstring 1.0.,$(FPC_VERSION)),)
ifeq ($(OS_TARGET),go32v1)
STATICLIBPREFIX=
FPCMADE=fpcmade.v1
PACKAGESUFFIX=v1
endif
ifeq ($(OS_TARGET),go32v2)
STATICLIBPREFIX=
FPCMADE=fpcmade.dos
ZIPSUFFIX=go32
endif
ifeq ($(OS_TARGET),watcom)
STATICLIBPREFIX=
FPCMADE=fpcmade.dos
ZIPSUFFIX=watcom
endif
ifeq ($(OS_TARGET),linux)
EXEEXT=
HASSHAREDLIB=1
FPCMADE=fpcmade.lnx
ZIPSUFFIX=linux
endif
ifeq ($(OS_TARGET),freebsd)
EXEEXT=
HASSHAREDLIB=1
FPCMADE=fpcmade.freebsd
ZIPSUFFIX=freebsd
endif
ifeq ($(OS_TARGET),netbsd)
EXEEXT=
HASSHAREDLIB=1
FPCMADE=fpcmade.netbsd
ZIPSUFFIX=netbsd
endif
ifeq ($(OS_TARGET),openbsd)
EXEEXT=
HASSHAREDLIB=1
FPCMADE=fpcmade.openbsd
ZIPSUFFIX=openbsd
endif
ifeq ($(OS_TARGET),win32)
SHAREDLIBEXT=.dll
FPCMADE=fpcmade.w32
ZIPSUFFIX=w32
endif
ifeq ($(OS_TARGET),os2)
AOUTEXT=.out
STATICLIBPREFIX=
SHAREDLIBEXT=.dll
FPCMADE=fpcmade.os2
ZIPSUFFIX=os2
ECHO=echo
endif
ifeq ($(OS_TARGET),emx)
AOUTEXT=.out
STATICLIBPREFIX=
SHAREDLIBEXT=.dll
FPCMADE=fpcmade.emx
ZIPSUFFIX=emx
ECHO=echo
endif
ifeq ($(OS_TARGET),amiga)
EXEEXT=
SHAREDLIBEXT=.library
FPCMADE=fpcmade.amg
endif
ifeq ($(OS_TARGET),atari)
EXEEXT=.ttp
FPCMADE=fpcmade.ata
endif
ifeq ($(OS_TARGET),beos)
EXEEXT=
FPCMADE=fpcmade.be
ZIPSUFFIX=be
endif
ifeq ($(OS_TARGET),sunos)
EXEEXT=
FPCMADE=fpcmade.sun
ZIPSUFFIX=sun
endif
ifeq ($(OS_TARGET),qnx)
EXEEXT=
FPCMADE=fpcmade.qnx
ZIPSUFFIX=qnx
endif
ifeq ($(OS_TARGET),netware)
EXEEXT=.nlm
STATICLIBPREFIX=
FPCMADE=fpcmade.nw
ZIPSUFFIX=nw
endif
ifeq ($(OS_TARGET),macos)
EXEEXT=
FPCMADE=fpcmade.mcc
endif
ifeq ($(OS_TARGET),darwin)
EXEEXT=
HASSHAREDLIB=1
FPCMADE=fpcmade.darwin
ZIPSUFFIX=darwin
endif
else
ifeq ($(OS_TARGET),go32v1)
PPUEXT=.pp1
OEXT=.o1
ASMEXT=.s1
SMARTEXT=.sl1
STATICLIBEXT=.a1
SHAREDLIBEXT=.so1
STATICLIBPREFIX=
FPCMADE=fpcmade.v1
PACKAGESUFFIX=v1
endif
ifeq ($(OS_TARGET),go32v2)
STATICLIBPREFIX=
FPCMADE=fpcmade.dos
ZIPSUFFIX=go32
endif
ifeq ($(OS_TARGET),watcom)
STATICLIBPREFIX=
FPCMADE=fpcmade.dos
ZIPSUFFIX=watcom
endif
ifeq ($(OS_TARGET),linux)
EXEEXT=
HASSHAREDLIB=1
FPCMADE=fpcmade.lnx
ZIPSUFFIX=linux
endif
ifeq ($(OS_TARGET),freebsd)
EXEEXT=
HASSHAREDLIB=1
FPCMADE=fpcmade.freebsd
ZIPSUFFIX=freebsd
endif
ifeq ($(OS_TARGET),netbsd)
EXEEXT=
HASSHAREDLIB=1
FPCMADE=fpcmade.netbsd
ZIPSUFFIX=netbsd
endif
ifeq ($(OS_TARGET),openbsd)
EXEEXT=
HASSHAREDLIB=1
FPCMADE=fpcmade.openbsd
ZIPSUFFIX=openbsd
endif
ifeq ($(OS_TARGET),win32)
PPUEXT=.ppw
OEXT=.ow
ASMEXT=.sw
SMARTEXT=.slw
STATICLIBEXT=.aw
SHAREDLIBEXT=.dll
FPCMADE=fpcmade.w32
ZIPSUFFIX=w32
endif
ifeq ($(OS_TARGET),os2)
PPUEXT=.ppo
ASMEXT=.so2
OEXT=.oo2
AOUTEXT=.out
SMARTEXT=.sl2
STATICLIBPREFIX=
STATICLIBEXT=.ao2
SHAREDLIBEXT=.dll
FPCMADE=fpcmade.os2
ZIPSUFFIX=emx
ECHO=echo
endif
ifeq ($(OS_TARGET),amiga)
EXEEXT=
PPUEXT=.ppu
ASMEXT=.asm
OEXT=.o
SMARTEXT=.sl
STATICLIBEXT=.a
SHAREDLIBEXT=.library
FPCMADE=fpcmade.amg
endif
ifeq ($(OS_TARGET),atari)
PPUEXT=.ppu
ASMEXT=.s
OEXT=.o
SMARTEXT=.sl
STATICLIBEXT=.a
EXEEXT=.ttp
FPCMADE=fpcmade.ata
endif
ifeq ($(OS_TARGET),beos)
PPUEXT=.ppu
ASMEXT=.s
OEXT=.o
SMARTEXT=.sl
STATICLIBEXT=.a
EXEEXT=
FPCMADE=fpcmade.be
ZIPSUFFIX=be
endif
ifeq ($(OS_TARGET),sunos)
PPUEXT=.ppu
ASMEXT=.s
OEXT=.o
SMARTEXT=.sl
STATICLIBEXT=.a
EXEEXT=
FPCMADE=fpcmade.sun
ZIPSUFFIX=sun
endif
ifeq ($(OS_TARGET),qnx)
PPUEXT=.ppu
ASMEXT=.s
OEXT=.o
SMARTEXT=.sl
STATICLIBEXT=.a
EXEEXT=
FPCMADE=fpcmade.qnx
ZIPSUFFIX=qnx
endif
ifeq ($(OS_TARGET),netware)
STATICLIBPREFIX=
PPUEXT=.ppu
OEXT=.o
ASMEXT=.s
SMARTEXT=.sl
STATICLIBEXT=.a
SHAREDLIBEXT=.nlm
FPCMADE=fpcmade.nw
ZIPSUFFIX=nw
EXEEXT=.nlm
endif
ifeq ($(OS_TARGET),macos)
PPUEXT=.ppu
ASMEXT=.s
OEXT=.o
SMARTEXT=.sl
STATICLIBEXT=.a
EXEEXT=
FPCMADE=fpcmade.mcc
endif
endif
ifndef ECHO
ECHO:=$(strip $(wildcard $(addsuffix /gecho$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(ECHO),)
ECHO:=$(strip $(wildcard $(addsuffix /echo$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(ECHO),)
ECHO=
else
ECHO:=$(firstword $(ECHO))
endif
else
ECHO:=$(firstword $(ECHO))
endif
endif
export ECHO
ifndef DATE
DATE:=$(strip $(wildcard $(addsuffix /gdate$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(DATE),)
DATE:=$(strip $(wildcard $(addsuffix /date$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(DATE),)
DATE=
else
DATE:=$(firstword $(DATE))
endif
else
DATE:=$(firstword $(DATE))
endif
endif
export DATE
ifndef GINSTALL
GINSTALL:=$(strip $(wildcard $(addsuffix /ginstall$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(GINSTALL),)
GINSTALL:=$(strip $(wildcard $(addsuffix /install$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(GINSTALL),)
GINSTALL=
else
GINSTALL:=$(firstword $(GINSTALL))
endif
else
GINSTALL:=$(firstword $(GINSTALL))
endif
endif
export GINSTALL
ifndef CPPROG
CPPROG:=$(strip $(wildcard $(addsuffix /cp$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(CPPROG),)
CPPROG=
else
CPPROG:=$(firstword $(CPPROG))
endif
endif
export CPPROG
ifndef RMPROG
RMPROG:=$(strip $(wildcard $(addsuffix /rm$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(RMPROG),)
RMPROG=
else
RMPROG:=$(firstword $(RMPROG))
endif
endif
export RMPROG
ifndef MVPROG
MVPROG:=$(strip $(wildcard $(addsuffix /mv$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(MVPROG),)
MVPROG=
else
MVPROG:=$(firstword $(MVPROG))
endif
endif
export MVPROG
ifndef ECHOREDIR
ECHOREDIR:=$(subst /,$(PATHSEP),$(ECHO))
endif
ifndef COPY
COPY:=$(CPPROG) -fp
endif
ifndef COPYTREE
COPYTREE:=$(CPPROG) -rfp
endif
ifndef MOVE
MOVE:=$(MVPROG) -f
endif
ifndef DEL
DEL:=$(RMPROG) -f
endif
ifndef DELTREE
DELTREE:=$(RMPROG) -rf
endif
ifndef INSTALL
ifdef inUnix
INSTALL:=$(GINSTALL) -c -m 644
else
INSTALL:=$(COPY)
endif
endif
ifndef INSTALLEXE
ifdef inUnix
INSTALLEXE:=$(GINSTALL) -c -m 755
else
INSTALLEXE:=$(COPY)
endif
endif
ifndef MKDIR
MKDIR:=$(GINSTALL) -m 755 -d
endif
export ECHOREDIR COPY COPYTREE MOVE DEL DELTREE INSTALL INSTALLEXE MKDIR
ifndef PPUMOVE
PPUMOVE:=$(strip $(wildcard $(addsuffix /ppumove$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(PPUMOVE),)
PPUMOVE=
else
PPUMOVE:=$(firstword $(PPUMOVE))
endif
endif
export PPUMOVE
ifndef FPCMAKE
FPCMAKE:=$(strip $(wildcard $(addsuffix /fpcmake$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(FPCMAKE),)
FPCMAKE=
else
FPCMAKE:=$(firstword $(FPCMAKE))
endif
endif
export FPCMAKE
ifndef ZIPPROG
ZIPPROG:=$(strip $(wildcard $(addsuffix /zip$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(ZIPPROG),)
ZIPPROG=
else
ZIPPROG:=$(firstword $(ZIPPROG))
endif
endif
export ZIPPROG
ifndef TARPROG
TARPROG:=$(strip $(wildcard $(addsuffix /tar$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(TARPROG),)
TARPROG=
else
TARPROG:=$(firstword $(TARPROG))
endif
endif
export TARPROG
ASNAME=$(BINUTILSPREFIX)as
LDNAME=$(BINUTILSPREFIX)ld
ARNAME=$(BINUTILSPREFIX)ar
RCNAME=$(BINUTILSPREFIX)rc
ifeq ($(findstring 1.0.,$(FPC_VERSION)),)
ifeq ($(OS_TARGET),win32)
ASNAME=asw
LDNAME=ldw
ARNAME=arw
endif
endif
ifndef ASPROG
ifdef CROSSBINDIR
ASPROG=$(CROSSBINDIR)/$(ASNAME)$(SRCEXEEXT)
else
ASPROG=$(ASNAME)
endif
endif
ifndef LDPROG
ifdef CROSSBINDIR
LDPROG=$(CROSSBINDIR)/$(LDNAME)$(SRCEXEEXT)
else
LDPROG=$(LDNAME)
endif
endif
ifndef RCPROG
ifdef CROSSBINDIR
RCPROG=$(CROSSBINDIR)/$(RCNAME)$(SRCEXEEXT)
else
RCPROG=$(RCNAME)
endif
endif
ifndef ARPROG
ifdef CROSSBINDIR
ARPROG=$(CROSSBINDIR)/$(ARNAME)$(SRCEXEEXT)
else
ARPROG=$(ARNAME)
endif
endif
AS=$(ASPROG)
LD=$(LDPROG)
RC=$(RCPROG)
AR=$(ARPROG)
PPAS=ppas$(BATCHEXT)
ifdef inUnix
LDCONFIG=ldconfig
else
LDCONFIG=
endif
ifdef DATE
DATESTR:=$(shell $(DATE) +%Y%m%d)
else
DATESTR=
endif
ifndef UPXPROG
ifeq ($(OS_TARGET),go32v2)
UPXPROG:=1
endif
ifeq ($(OS_TARGET),win32)
UPXPROG:=1
endif
ifdef UPXPROG
UPXPROG:=$(strip $(wildcard $(addsuffix /upx$(SRCEXEEXT),$(SEARCHPATH))))
ifeq ($(UPXPROG),)
UPXPROG=
else
UPXPROG:=$(firstword $(UPXPROG))
endif
else
UPXPROG=
endif
endif
export UPXPROG
ZIPOPT=-9
ZIPEXT=.zip
ifeq ($(USETAR),bz2)
TAROPT=vI
TAREXT=.tar.bz2
else
TAROPT=vz
TAREXT=.tar.gz
endif
override REQUIRE_PACKAGES=rtl 
ifeq ($(OS_TARGET),linux)
ifeq ($(CPU_TARGET),i386)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),linux)
ifeq ($(CPU_TARGET),m68k)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),linux)
ifeq ($(CPU_TARGET),powerpc)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),linux)
ifeq ($(CPU_TARGET),sparc)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),linux)
ifeq ($(CPU_TARGET),x86_64)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),go32v2)
ifeq ($(CPU_TARGET),i386)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),win32)
ifeq ($(CPU_TARGET),i386)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),os2)
ifeq ($(CPU_TARGET),i386)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),freebsd)
ifeq ($(CPU_TARGET),i386)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),freebsd)
ifeq ($(CPU_TARGET),m68k)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),beos)
ifeq ($(CPU_TARGET),i386)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),netbsd)
ifeq ($(CPU_TARGET),i386)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),netbsd)
ifeq ($(CPU_TARGET),m68k)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),amiga)
ifeq ($(CPU_TARGET),m68k)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),atari)
ifeq ($(CPU_TARGET),m68k)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),sunos)
ifeq ($(CPU_TARGET),i386)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),sunos)
ifeq ($(CPU_TARGET),sparc)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),qnx)
ifeq ($(CPU_TARGET),i386)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),netware)
ifeq ($(CPU_TARGET),i386)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),openbsd)
ifeq ($(CPU_TARGET),i386)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),openbsd)
ifeq ($(CPU_TARGET),m68k)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),wdosx)
ifeq ($(CPU_TARGET),i386)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),palmos)
ifeq ($(CPU_TARGET),m68k)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),macos)
ifeq ($(CPU_TARGET),powerpc)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),darwin)
ifeq ($(CPU_TARGET),powerpc)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),emx)
ifeq ($(CPU_TARGET),i386)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifeq ($(OS_TARGET),watcom)
ifeq ($(CPU_TARGET),i386)
REQUIRE_PACKAGES_RTL=1
endif
endif
ifdef REQUIRE_PACKAGES_RTL
PACKAGEDIR_RTL:=$(firstword $(subst /Makefile.fpc,,$(strip $(wildcard $(addsuffix /rtl/$(OS_TARGET)/Makefile.fpc,$(PACKAGESDIR))))))
ifneq ($(PACKAGEDIR_RTL),)
ifneq ($(wildcard $(PACKAGEDIR_RTL)/$(OS_TARGET)),)
UNITDIR_RTL=$(PACKAGEDIR_RTL)/$(OS_TARGET)
else
UNITDIR_RTL=$(PACKAGEDIR_RTL)
endif
ifdef CHECKDEPEND
$(PACKAGEDIR_RTL)/$(FPCMADE):
	$(MAKE) -C $(PACKAGEDIR_RTL) $(FPCMADE)
override ALLDEPENDENCIES+=$(PACKAGEDIR_RTL)/$(FPCMADE)
endif
else
PACKAGEDIR_RTL=
UNITDIR_RTL:=$(subst /Package.fpc,,$(strip $(wildcard $(addsuffix /rtl/Package.fpc,$(UNITSDIR)))))
ifneq ($(UNITDIR_RTL),)
UNITDIR_RTL:=$(firstword $(UNITDIR_RTL))
else
UNITDIR_RTL=
endif
endif
ifdef UNITDIR_RTL
override COMPILER_UNITDIR+=$(UNITDIR_RTL)
endif
endif
ifndef NOCPUDEF
override FPCOPTDEF=$(CPU_TARGET)
endif
ifneq ($(OS_TARGET),$(OS_SOURCE))
override FPCOPT+=-T$(OS_TARGET)
endif
ifeq ($(OS_SOURCE),openbsd)
override FPCOPT+=-FD$(NEW_BINUTILS_PATH)
endif
ifndef CROSSBOOTSTRAP
ifneq ($(BINUTILSPREFIX),)
override FPCOPT+=-XP$(BINUTILSPREFIX)
endif
endif
ifdef UNITDIR
override FPCOPT+=$(addprefix -Fu,$(UNITDIR))
endif
ifdef LIBDIR
override FPCOPT+=$(addprefix -Fl,$(LIBDIR))
endif
ifdef OBJDIR
override FPCOPT+=$(addprefix -Fo,$(OBJDIR))
endif
ifdef INCDIR
override FPCOPT+=$(addprefix -Fi,$(INCDIR))
endif
ifdef LINKSMART
override FPCOPT+=-XX
endif
ifdef CREATESMART
override FPCOPT+=-CX
endif
ifdef DEBUG
override FPCOPT+=-gl
override FPCOPTDEF+=DEBUG
endif
ifdef RELEASE
ifeq ($(CPU_TARGET),i386)
FPCCPUOPT:=-OG2p3
else
FPCCPUOPT:=
endif
override FPCOPT+=-Xs $(FPCCPUOPT) -n
override FPCOPTDEF+=RELEASE
endif
ifdef STRIP
override FPCOPT+=-Xs
endif
ifdef OPTIMIZE
ifeq ($(CPU_TARGET),i386)
override FPCOPT+=-OG2p3
endif
endif
ifdef VERBOSE
override FPCOPT+=-vwni
endif
ifdef COMPILER_OPTIONS
override FPCOPT+=$(COMPILER_OPTIONS)
endif
ifdef COMPILER_UNITDIR
override FPCOPT+=$(addprefix -Fu,$(COMPILER_UNITDIR))
endif
ifdef COMPILER_LIBRARYDIR
override FPCOPT+=$(addprefix -Fl,$(COMPILER_LIBRARYDIR))
endif
ifdef COMPILER_OBJECTDIR
override FPCOPT+=$(addprefix -Fo,$(COMPILER_OBJECTDIR))
endif
ifdef COMPILER_INCLUDEDIR
override FPCOPT+=$(addprefix -Fi,$(COMPILER_INCLUDEDIR))
endif
ifdef CROSSBINDIR
override FPCOPT+=-FD$(CROSSBINDIR)
endif
ifdef COMPILER_TARGETDIR
override FPCOPT+=-FE$(COMPILER_TARGETDIR)
ifeq ($(COMPILER_TARGETDIR),.)
override TARGETDIRPREFIX=
else
override TARGETDIRPREFIX=$(COMPILER_TARGETDIR)/
endif
endif
ifdef COMPILER_UNITTARGETDIR
override FPCOPT+=-FU$(COMPILER_UNITTARGETDIR)
ifeq ($(COMPILER_UNITTARGETDIR),.)
override UNITTARGETDIRPREFIX=
else
override UNITTARGETDIRPREFIX=$(COMPILER_UNITTARGETDIR)/
endif
else
ifdef COMPILER_TARGETDIR
override COMPILER_UNITTARGETDIR=$(COMPILER_TARGETDIR)
override UNITTARGETDIRPREFIX=$(TARGETDIRPREFIX)
endif
endif
ifeq ($(OS_TARGET),linux)
ifeq ($(FPC_VERSION),1.0.6)
override FPCOPTDEF+=HASUNIX
endif
endif
ifdef OPT
override FPCOPT+=$(OPT)
endif
ifdef FPCOPTDEF
override FPCOPT+=$(addprefix -d,$(FPCOPTDEF))
endif
ifdef CFGFILE
override FPCOPT+=@$(CFGFILE)
endif
ifdef USEENV
override FPCEXTCMD:=$(FPCOPT)
override FPCOPT:=!FPCEXTCMD
export FPCEXTCMD
endif
override COMPILER:=$(FPC) $(FPCOPT)
ifeq (,$(findstring -s ,$(COMPILER)))
EXECPPAS=
else
ifeq ($(FULL_SOURCE),$(FULL_TARGET))
EXECPPAS:=@$(PPAS)
endif
endif
ifdef TARGET_RSTS
override RSTFILES=$(addsuffix $(RSTEXT),$(TARGET_RSTS))
override CLEANRSTFILES+=$(RSTFILES)
endif
.PHONY: fpc_clean fpc_cleanall fpc_distclean
ifdef EXEFILES
override CLEANEXEFILES:=$(addprefix $(TARGETDIRPREFIX),$(CLEANEXEFILES))
endif
ifdef CLEAN_UNITS
override CLEANPPUFILES+=$(addsuffix $(PPUEXT),$(CLEAN_UNITS))
endif
ifdef CLEANPPUFILES
override CLEANPPULINKFILES:=$(subst $(PPUEXT),$(OEXT),$(CLEANPPUFILES)) $(addprefix $(STATICLIBPREFIX),$(subst $(PPUEXT),$(STATICLIBEXT),$(CLEANPPUFILES)))
override CLEANPPUFILES:=$(addprefix $(UNITTARGETDIRPREFIX),$(CLEANPPUFILES))
override CLEANPPULINKFILES:=$(wildcard $(addprefix $(UNITTARGETDIRPREFIX),$(CLEANPPULINKFILES)))
endif
fpc_clean: $(CLEANTARGET)
ifdef CLEANEXEFILES
	-$(DEL) $(CLEANEXEFILES)
endif
ifdef CLEANPPUFILES
	-$(DEL) $(CLEANPPUFILES)
endif
ifneq ($(CLEANPPULINKFILES),)
	-$(DEL) $(CLEANPPULINKFILES)
endif
ifdef CLEANRSTFILES
	-$(DEL) $(addprefix $(UNITTARGETDIRPREFIX),$(CLEANRSTFILES))
endif
ifdef CLEAN_FILES
	-$(DEL) $(CLEAN_FILES)
endif
ifdef LIB_NAME
	-$(DEL) $(LIB_NAME) $(LIB_FULLNAME)
endif
	-$(DEL) $(FPCMADE) Package.fpc $(PPAS) script.res link.res $(FPCEXTFILE) $(REDIRFILE)
fpc_distclean: clean
ifdef COMPILER_UNITTARGETDIR
TARGETDIRCLEAN=fpc_clean
endif
fpc_cleanall: $(CLEANTARGET) $(TARGETDIRCLEAN)
ifdef CLEANEXEFILES
	-$(DEL) $(CLEANEXEFILES)
endif
	-$(DEL) *$(OEXT) *$(PPUEXT) *$(RSTEXT) *$(ASMEXT) *$(STATICLIBEXT) *$(SHAREDLIBEXT) *$(PPLEXT)
	-$(DELTREE) *$(SMARTEXT)
	-$(DEL) $(FPCMADE) Package.fpc $(PPAS) script.res link.res $(FPCEXTFILE) $(REDIRFILE)
ifdef AOUTEXT
	-$(DEL) *$(AOUTEXT)
endif
.PHONY: fpc_baseinfo
override INFORULES+=fpc_baseinfo
fpc_baseinfo:
	@$(ECHO)
	@$(ECHO)  == Package info ==
	@$(ECHO)  Package Name..... $(PACKAGE_NAME)
	@$(ECHO)  Package Version.. $(PACKAGE_VERSION)
	@$(ECHO)
	@$(ECHO)  == Configuration info ==
	@$(ECHO)
	@$(ECHO)  FPC.......... $(FPC)
	@$(ECHO)  FPC Version.. $(FPC_VERSION)
	@$(ECHO)  Source CPU... $(CPU_SOURCE)
	@$(ECHO)  Target CPU... $(CPU_TARGET)
	@$(ECHO)  Source OS.... $(OS_SOURCE)
	@$(ECHO)  Target OS.... $(OS_TARGET)
	@$(ECHO)  Full Source.. $(FULL_SOURCE)
	@$(ECHO)  Full Target.. $(FULL_TARGET)
	@$(ECHO)
	@$(ECHO)  == Directory info ==
	@$(ECHO)
	@$(ECHO)  Required pkgs... $(REQUIRE_PACKAGES)
	@$(ECHO)
	@$(ECHO)  Basedir......... $(BASEDIR)
	@$(ECHO)  FPCDir.......... $(FPCDIR)
	@$(ECHO)  CrossBinDir..... $(CROSSBINDIR)
	@$(ECHO)  UnitsDir........ $(UNITSDIR)
	@$(ECHO)  PackagesDir..... $(PACKAGESDIR)
	@$(ECHO)
	@$(ECHO)  GCC library..... $(GCCLIBDIR)
	@$(ECHO)  Other library... $(OTHERLIBDIR)
	@$(ECHO)
	@$(ECHO)  == Tools info ==
	@$(ECHO)
	@$(ECHO)  As........ $(AS)
	@$(ECHO)  Ld........ $(LD)
	@$(ECHO)  Ar........ $(AR)
	@$(ECHO)  Rc........ $(RC)
	@$(ECHO)
	@$(ECHO)  Mv........ $(MVPROG)
	@$(ECHO)  Cp........ $(CPPROG)
	@$(ECHO)  Rm........ $(RMPROG)
	@$(ECHO)  GInstall.. $(GINSTALL)
	@$(ECHO)  Echo...... $(ECHO)
	@$(ECHO)  Shell..... $(SHELL)
	@$(ECHO)  Date...... $(DATE)
	@$(ECHO)  FPCMake... $(FPCMAKE)
	@$(ECHO)  PPUMove... $(PPUMOVE)
	@$(ECHO)  Upx....... $(UPXPROG)
	@$(ECHO)  Zip....... $(ZIPPROG)
	@$(ECHO)
	@$(ECHO)  == Object info ==
	@$(ECHO)
	@$(ECHO)  Target Loaders........ $(TARGET_LOADERS)
	@$(ECHO)  Target Units.......... $(TARGET_UNITS)
	@$(ECHO)  Target Implicit Units. $(TARGET_IMPLICITUNITS)
	@$(ECHO)  Target Programs....... $(TARGET_PROGRAMS)
	@$(ECHO)  Target Dirs........... $(TARGET_DIRS)
	@$(ECHO)  Target Examples....... $(TARGET_EXAMPLES)
	@$(ECHO)  Target ExampleDirs.... $(TARGET_EXAMPLEDIRS)
	@$(ECHO)
	@$(ECHO)  Clean Units......... $(CLEAN_UNITS)
	@$(ECHO)  Clean Files......... $(CLEAN_FILES)
	@$(ECHO)
	@$(ECHO)  Install Units....... $(INSTALL_UNITS)
	@$(ECHO)  Install Files....... $(INSTALL_FILES)
	@$(ECHO)
	@$(ECHO)  == Install info ==
	@$(ECHO)
	@$(ECHO)  DateStr.............. $(DATESTR)
	@$(ECHO)  ZipPrefix............ $(ZIPPREFIX)
	@$(ECHO)  ZipSuffix............ $(ZIPSUFFIX)
	@$(ECHO)  Install FPC Package.. $(INSTALL_FPCPACKAGE)
	@$(ECHO)
	@$(ECHO)  Install base dir..... $(INSTALL_BASEDIR)
	@$(ECHO)  Install binary dir... $(INSTALL_BINDIR)
	@$(ECHO)  Install library dir.. $(INSTALL_LIBDIR)
	@$(ECHO)  Install units dir.... $(INSTALL_UNITDIR)
	@$(ECHO)  Install source dir... $(INSTALL_SOURCEDIR)
	@$(ECHO)  Install doc dir...... $(INSTALL_DOCDIR)
	@$(ECHO)  Install example dir.. $(INSTALL_EXAMPLEDIR)
	@$(ECHO)  Install data dir..... $(INSTALL_DATADIR)
	@$(ECHO)
	@$(ECHO)  Dist destination dir. $(DIST_DESTDIR)
	@$(ECHO)  Dist zip name........ $(DIST_ZIPNAME)
	@$(ECHO)
.PHONY: fpc_info
fpc_info: $(INFORULES)
.PHONY: fpc_makefile fpc_makefiles fpc_makefile_sub1 fpc_makefile_sub2 \
	fpc_makefile_dirs
fpc_makefile:
	$(FPCMAKE) -w -T$(OS_TARGET) Makefile.fpc
fpc_makefile_sub1:
ifdef TARGET_DIRS
	$(FPCMAKE) -w -T$(OS_TARGET) $(addsuffix /Makefile.fpc,$(TARGET_DIRS))
endif
ifdef TARGET_EXAMPLEDIRS
	$(FPCMAKE) -w -T$(OS_TARGET) $(addsuffix /Makefile.fpc,$(TARGET_EXAMPLEDIRS))
endif
fpc_makefile_sub2: $(addsuffix _makefile_dirs,$(TARGET_DIRS) $(TARGET_EXAMPLEDIRS))
fpc_makefile_dirs: fpc_makefile_sub1 fpc_makefile_sub2
fpc_makefiles: fpc_makefile fpc_makefile_dirs
TARGET_DIRS_SYNEDIT=1
TARGET_DIRS_CODETOOLS=1
ifdef TARGET_DIRS_SYNEDIT
synedit_all:
	$(MAKE) -C synedit all
synedit_debug:
	$(MAKE) -C synedit debug
synedit_smart:
	$(MAKE) -C synedit smart
synedit_release:
	$(MAKE) -C synedit release
synedit_examples:
	$(MAKE) -C synedit examples
synedit_shared:
	$(MAKE) -C synedit shared
synedit_install:
	$(MAKE) -C synedit install
synedit_sourceinstall:
	$(MAKE) -C synedit sourceinstall
synedit_exampleinstall:
	$(MAKE) -C synedit exampleinstall
synedit_distinstall:
	$(MAKE) -C synedit distinstall
synedit_zipinstall:
	$(MAKE) -C synedit zipinstall
synedit_zipsourceinstall:
	$(MAKE) -C synedit zipsourceinstall
synedit_zipexampleinstall:
	$(MAKE) -C synedit zipexampleinstall
synedit_zipdistinstall:
	$(MAKE) -C synedit zipdistinstall
synedit_clean:
	$(MAKE) -C synedit clean
synedit_distclean:
	$(MAKE) -C synedit distclean
synedit_cleanall:
	$(MAKE) -C synedit cleanall
synedit_info:
	$(MAKE) -C synedit info
synedit_makefiles:
	$(MAKE) -C synedit makefiles
synedit:
	$(MAKE) -C synedit all
.PHONY: synedit_all synedit_debug synedit_smart synedit_release synedit_examples synedit_shared synedit_install synedit_sourceinstall synedit_exampleinstall synedit_distinstall synedit_zipinstall synedit_zipsourceinstall synedit_zipexampleinstall synedit_zipdistinstall synedit_clean synedit_distclean synedit_cleanall synedit_info synedit_makefiles synedit
endif
ifdef TARGET_DIRS_CODETOOLS
codetools_all:
	$(MAKE) -C codetools all
codetools_debug:
	$(MAKE) -C codetools debug
codetools_smart:
	$(MAKE) -C codetools smart
codetools_release:
	$(MAKE) -C codetools release
codetools_examples:
	$(MAKE) -C codetools examples
codetools_shared:
	$(MAKE) -C codetools shared
codetools_install:
	$(MAKE) -C codetools install
codetools_sourceinstall:
	$(MAKE) -C codetools sourceinstall
codetools_exampleinstall:
	$(MAKE) -C codetools exampleinstall
codetools_distinstall:
	$(MAKE) -C codetools distinstall
codetools_zipinstall:
	$(MAKE) -C codetools zipinstall
codetools_zipsourceinstall:
	$(MAKE) -C codetools zipsourceinstall
codetools_zipexampleinstall:
	$(MAKE) -C codetools zipexampleinstall
codetools_zipdistinstall:
	$(MAKE) -C codetools zipdistinstall
codetools_clean:
	$(MAKE) -C codetools clean
codetools_distclean:
	$(MAKE) -C codetools distclean
codetools_cleanall:
	$(MAKE) -C codetools cleanall
codetools_info:
	$(MAKE) -C codetools info
codetools_makefiles:
	$(MAKE) -C codetools makefiles
codetools:
	$(MAKE) -C codetools all
.PHONY: codetools_all codetools_debug codetools_smart codetools_release codetools_examples codetools_shared codetools_install codetools_sourceinstall codetools_exampleinstall codetools_distinstall codetools_zipinstall codetools_zipsourceinstall codetools_zipexampleinstall codetools_zipdistinstall codetools_clean codetools_distclean codetools_cleanall codetools_info codetools_makefiles codetools
endif
all: $(addsuffix _all,$(TARGET_DIRS))
debug: $(addsuffix _debug,$(TARGET_DIRS))
smart: $(addsuffix _smart,$(TARGET_DIRS))
release: $(addsuffix _release,$(TARGET_DIRS))
examples: $(addsuffix _examples,$(TARGET_DIRS))
shared: $(addsuffix _shared,$(TARGET_DIRS))
install: $(addsuffix _install,$(TARGET_DIRS))
sourceinstall: $(addsuffix _sourceinstall,$(TARGET_DIRS))
exampleinstall: $(addsuffix _exampleinstall,$(TARGET_DIRS))
distinstall: $(addsuffix _distinstall,$(TARGET_DIRS))
zipinstall: $(addsuffix _zipinstall,$(TARGET_DIRS))
zipsourceinstall: $(addsuffix _zipsourceinstall,$(TARGET_DIRS))
zipexampleinstall: $(addsuffix _zipexampleinstall,$(TARGET_DIRS))
zipdistinstall: $(addsuffix _zipdistinstall,$(TARGET_DIRS))
clean: fpc_clean $(addsuffix _clean,$(TARGET_DIRS))
distclean: fpc_distclean $(addsuffix _distclean,$(TARGET_DIRS))
info: fpc_info
makefiles: fpc_makefiles $(addsuffix _makefiles,$(TARGET_DIRS))
.PHONY: all debug smart release examples shared install sourceinstall exampleinstall distinstall zipinstall zipsourceinstall zipexampleinstall zipdistinstall clean distclean info makefiles
ifneq ($(wildcard fpcmake.loc),)
include fpcmake.loc
endif
cleanall: clean
