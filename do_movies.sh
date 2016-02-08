#!/bin/bash

JPSUFF=jpeg
JPSUFF=jpg
\rm tmp/*${JPSUFF}
alias ffmpeg=/Applications/ffmpegX.app/Contents/Resources/ffmpeg
ffmpeg_app=/opt/local/bin/ffmpeg 
ffmpeg_app=~/sbin/ffmpeg

 x=1; 
 for i in *${JPSUFF};
 do counter=$(printf %03d $x);

# convert "$i" -splice 0x1 "$i"tst.jpg
 ln  "$i" ./tmp/img"$counter".${JPSUFF}; x=$(($x+1));
 done

tag="kh"
${ffmpeg_app} -y -r 4   -i ./tmp/img%03d.${JPSUFF} ${tag}.mov
${ffmpeg_app} -y -r 4   -i ./tmp/img%03d.${JPSUFF} ${tag}_lowres.mov

