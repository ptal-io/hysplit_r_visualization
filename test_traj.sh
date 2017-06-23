#!/bin/sh

#-------------------------------------------------------------
# set default directory structure if not passed through

  MDL="/home/ubuntu/hysplit-805/trunk"
  OUT="${MDL}/working"
  MET="${MDL}"
  cd $OUT

  if [ ! -f ASCDATA.CFG ]; then
     echo "-90.0  -180.0"     >ASCDATA.CFG
     echo "1.0     1.0"      >>ASCDATA.CFG
     echo "180     360"      >>ASCDATA.CFG
     echo "2"                >>ASCDATA.CFG
     echo "0.2"              >>ASCDATA.CFG
     echo "'$MDL/bdyfiles/'" >>ASCDATA.CFG
  fi
  echo "### $0 ###"

#--------------------------------------------------------------
# set model simulation variables    

  syr=05
  smo=03
  sda=06
  shr=12
     
  olat=33.0
  olon=-116.0
  lvl1=1000.0
  lvl2=2000.0
  lvl3=3000.0
        
  run=-12
  ztop=10000.0
  data="gdas1.mar05.w1"

#----------------------------------------------------------
# set up control file for dispersion/concentration simulation

  echo "$syr $smo $sda $shr    " >CONTROL
  echo "1                      ">>CONTROL
  echo "$olat $olon $lvl1      ">>CONTROL
 # echo "$olat $olon $lvl2      ">>CONTROL
 # echo "$olat $olon $lvl3      ">>CONTROL
  echo "$run                   ">>CONTROL
  echo "0                      ">>CONTROL
  echo "$ztop                  ">>CONTROL
  echo "1                      ">>CONTROL
  echo "$MET/                  ">>CONTROL
  echo "$data                  ">>CONTROL
  echo "$OUT/                  ">>CONTROL
  echo "tdump                  ">>CONTROL

#----------------------------------------------------------
# run the simulation

  rm -f tdump
  rm -f SETUP.CFG

  ${MDL}/exec/hyts_std    

  echo "'TITLE&','### $0 ###&'"  >LABELS.CFG
  ${MDL}/exec/trajplot -itdump -z80 -j${MDL}/graphics/arlmap
  gs trajplot.ps
