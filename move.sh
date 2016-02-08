mencoder mf://*.jpeg -mf fps=10:type=jpeg -noskip -of lavf -lavfopts format=mov -ovc lavc -lavcopts vglobal=1:coder=0:vbitrate=18000 -vf scale=1280:-2 -o test.mov
mencoder mf://*.jpeg -mf fps=10 -o test.avi -ovc lavc -lavcopts vcodec=msmpeg4v2:vbitrate=800
