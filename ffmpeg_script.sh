
for f in *ppm ; do convert -quality 100 $f `basename $f ppm`jpg; done 

mencoder "mf://*.jpg" -mf fps=10 -o test.avi -ovc lavc -lavcopts vcodec=msmpeg4v2:vbitrate=800 

