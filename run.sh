#!/bin/sh

if [ -z "${LEPTON}" ]
then
    export LEPTON=/home/dmn/lepton/bin.master
fi

export LD_LIBRARY_PATH=$LEPTON/lib
export GUILE_AUTO_COMPILE=0


./lepton-refdes-renum.scm "$@"

