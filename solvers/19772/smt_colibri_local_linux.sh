#!/bin/sh
FILE=$1
CONF=$2
COLDIR=$(realpath $(dirname $0))

case "$FILE" in
    "")
        GOAL="solve('smt_colibri.in')"
        ;;
    --version)
        cat $COLDIR/svn_id
        exit 0
        ;;
    --help)
        echo "COLIBRI SMTLIB2_FILE [OPTIONS]

--version   print version
--help      print this help
"
        exit 0
        ;;
    *)
	GOAL="smt_solve('$FILE')"
esac

if [ "$FILE" != "" ]
then
	GOAL="smt_solve('$FILE')"
fi

# Repertoire ECLiPSe Prolog
ECLIPSEDIR=$COLDIR/ECLiPSe_5.10
FILTER_SMTLIB_FILE=$COLDIR/filter_smtlib_file
# Architecture
# ARCH=i386_linux
ARCH="x86_64_linux"
LD_LIBRARY_PATH=${ECLIPSEDIR}/lib/${ARCH}:$LD_LIBRARY_PATH
export FILTER_SMTLIB_FILE ECLIPSEDIR ARCH LD_LIBRARY_PATH 

if [ -z "$CONF" ]; then
    CONF="true"
fi

# Chargement/demarrage de test_colibri
exec ${ECLIPSEDIR}/lib/${ARCH}/eclipse.exe \
     -b ${COLDIR}/compile_flag -b ${COLDIR}/col_solve \
     -g 3000M -e "seed(0),${CONF}, ${GOAL}"
