#!/bin/bash
while read p; do

  #rm gdas1.*

  MDL="/home/ubuntu/hysplit-805/trunk"
  OUT="${MDL}/output"
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

  syr=12
  smo=01
  sda=21
  shr=12

  run=-168
  ztop=10000.0
  #data1="data/gdas1.jan12.w3"
  #data2="data/gdas1.jan12.w2"


  arrIN=(${p//,/ })
  month=${arrIN[0]} 
  day=${arrIN[1]}
  year=${arrIN[2]}
  hour=${arrIN[3]}

  ilng=${arrIN[4]}
  ilat=${arrIN[5]}

  data1=${arrIN[6]}
  data2=${arrIN[7]}
  data3=${arrIN[8]}

  a=(${data1//// })
  dataname1=${a[-1]}

  a=(${data2//// })
  dataname2=${a[-1]}

  numfiles=2

  a=(${data3//// })
  dataname3=${a[-1]}

  if [[ ! -e $(eval echo $dataname1) ]]; then
    echo "File1 not found!"
	wget $data1
  fi

  if [ -n "$dataname2" ]; then 
	  if [[ ! -e $(eval echo $dataname2) ]]; then
	    echo "File2 not found!"
		wget $data2
	  fi
  fi
  if [ -n "$dataname3" ]; then 
  	  echo "File3 is called $dataname3"
  	  numfiles=$(($numfiles + 1))
  	  if [[ ! -e $(eval echo $dataname3) ]]; then
	    echo "File3 not found!"
		wget $data3
		
	  fi
  fi

  echo "&SETUP              "  >SETUP.CFG
  echo "tratio=0.75,             " >>SETUP.CFG
  echo "mgmin=10,             " >>SETUP.CFG
  echo "khmax=9999,             " >>SETUP.CFG
  echo "kmixd=0,             " >>SETUP.CFG
  echo "kmsl=1,             " >>SETUP.CFG
  echo "nstr=1,             " >>SETUP.CFG
  echo "nstr=0,             " >>SETUP.CFG
  echo "mhrs=9999,             " >>SETUP.CFG
  echo "nver=0,             " >>SETUP.CFG
  echo "tout=60,             " >>SETUP.CFG
  echo "tm_tpot=1,          " >>SETUP.CFG
  echo "tm_tamb=1,          " >>SETUP.CFG
  echo "tm_rain=1,          " >>SETUP.CFG
  echo "tm_mixd=1,          " >>SETUP.CFG
  echo "tm_relh=1,          " >>SETUP.CFG
  echo "tm_sphu=1,          " >>SETUP.CFG
  echo "tm_mixr=1,          " >>SETUP.CFG
#  echo "tm_dswf=1,          " >>SETUP.CFG
#  echo "tm_terr=1,          " >>SETUP.CFG
  echo "dxf=1.0,          " >>SETUP.CFG
  echo "dyf=1.0,          " >>SETUP.CFG
  echo "dzf=0.01,          " >>SETUP.CFG
  echo "/                   " >>SETUP.CFG

	for lat in $(($ilat - 2)) $(($ilat - 1)) $(($ilat)) $(($ilat + 1)) $(($ilat + 2)); do
	 for lng in $(($ilng - 2)) $(($ilng - 1)) $(($ilng)) $(($ilng + 1)) $(($ilng + 2)); do
	  for i in 1000 2000 3000; do
	   echo "$year $month $day $hour " >CONTROL
	   echo "1                      ">>CONTROL
	   echo "$lat $lng $i          ">>CONTROL
	   echo "$run                   ">>CONTROL
	   echo "0                      ">>CONTROL
	   echo "$ztop                  ">>CONTROL
	   echo "$numfiles              ">>CONTROL
	   echo "$MET/                  ">>CONTROL
	   echo "$dataname1             ">>CONTROL
	   echo "$MET/                  ">>CONTROL
	   echo "$dataname2">>CONTROL
	   if [ -n "$dataname3" ]; then 
	   	  echo "$MET/">>CONTROL
	   	  echo "$dataname3">>CONTROL
	   fi
	   echo "$OUT/                  ">>CONTROL
	   echo "output_${year}_${month}_${day}_${lat}_${lng}_${i}.txt">>CONTROL

	#----------------------------------------------------------
	# run the simulation

	${MDL}/exec/hyts_std

	#   rm -f SETUP.CFG
	   #rm -r CONTROL
	#   rm -f ASCDATA.CFG
	#   rm -f TRAJ.CFG
	   echo "'TITLE&','### $0 ###&'"  >LABELS.CFG

	  done
	 done
	done



done <dates.csv