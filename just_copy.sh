#!/bin/bash

#this script requires wget

STARTDIR=$(pwd)
cd "$( dirname "${BASH_SOURCE[0]}" )"
WDIR=$(pwd)

LAMMPSDIR=./lammpsSep21
MODFILESDIR=./LAMMPS_ModifiedFiles/23Set2024_acorso

echo "Copying modified LAMMPS function files and compiling..."

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

echo "Downloaded the September 2021 stable release of LAMMPS, modified it accordingly and compiled it in ${LAMMPSDIR}"
echo ""
echo "Done!"
echo ""

