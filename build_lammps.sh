#!/bin/bash

#this script requires wget

STARTDIR=$(pwd)
cd "$( dirname "${BASH_SOURCE[0]}" )"
WDIR=$(pwd)

LAMMPSDIR=./lammpsSep21
MODFILESDIR=./LAMMPS_ModifiedFiles/23Set2024

echo "Downloading LAMMPS (29th Sep 2021 stable release)..."

if [ ! -d $LAMMPSDIR ]; then
        if ! [ -x "$(command -v wget)" ]; then
                echo "You do not have wget installed on this computer, please download lammps 29Sep21 version manually and place it in a directory called 'lammps' at the same level as this file"
                echo "To do so:" 
                echo "  Copy this link into your browser: https://download.lammps.org/tars/lammps-29Sep2021.tar.gz"
                echo "  Extract this tar and copy the resulting file to the lammps directory"
                exit 0
        else
                wget -qO- https://download.lammps.org/tars/lammps-29Sep2021.tar.gz | tar xvz 
                mv lammps-* $LAMMPSDIR
        fi
else
        echo "You already have a version of LAMMPS installed here. If you are unsure about which version it is delete the ./lammps directory and rerun this program"
        echo "To delete the current LAMMPS version just run 'rm -r ${LAMMPSDIR}'"
        exit 0
fi

echo "Copying modified LAMMPS function files and compiling..."

if [ ! -f $LAMMPSDIR/src/lmp_serial ]; then
        cp -rf $MODFILESDIR/fix_bond_react.cpp $LAMMPSDIR/src/REACTION
        cp -rf $MODFILESDIR/fix_bond_react.h $LAMMPSDIR/src/REACTION
        cp -rf $MODFILESDIR/fix_gcmc.cpp $LAMMPSDIR/src/MC
        cp -rf $MODFILESDIR/fix_gcmc.h $LAMMPSDIR/src/MC
        cp -rf $MODFILESDIR/angle_harmonic_chiral2d.cpp $LAMMPSDIR/src
        cp -rf $MODFILESDIR/angle_harmonic_chiral2d.h $LAMMPSDIR/src
        cp -rf $MODFILESDIR/angle_harmonic_chiral2d.cpp $LAMMPSDIR/src/MOLECULE
        cp -rf $MODFILESDIR/angle_harmonic_chiral2d.h $LAMMPSDIR/src/MOLECULE
        cp -rf $MODFILESDIR/Makefile.list $LAMMPSDIR/src
        cp -rf $MODFILESDIR/packages_angle.h $LAMMPSDIR/src
        cp -rf $MODFILESDIR/style_angle.h $LAMMPSDIR/src
        cp -rf $MODFILESDIR/Depend.sh $LAMMPSDIR/src
	cd $LAMMPSDIR/src
	make clean-all
	make yes-EXTRA-PAIR yes-MC yes-MISC yes-MOLECULE yes-REACTION yes-RIGID
	make serial
	cd "$WDIR"
else
        echo "Existing LAMMPS executable found! If you are unsure about which version it is delete the ./lammps directory and rerun this program"
        echo "To delete the current LAMMPS version just run 'rm -r ${LAMMPSDIR}'"
        exit 0
fi

echo "Downloaded the September 2021 stable release of LAMMPS, modified it accordingly and compiled it in ${LAMMPSDIR}"
echo ""
echo "Done!"
echo ""

