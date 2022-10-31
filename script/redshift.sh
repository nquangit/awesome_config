#!/bin/bash

hour=$(date +%R | cut -d ":" -f 1 )

if [ $hour -gt 18 ];then
   xsct 3800
   exit 0
else
   xsct 6000
   exit 0
fi
exit 0
