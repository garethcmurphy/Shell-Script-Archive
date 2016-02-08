prefix=elec 
ffmpeg -r 10 -b 18000 -i ${prefix}%03d00.eps.jpeg ${prefix}.mov
prefix=ion
ffmpeg -r 10 -b 18000 -i ${prefix}%03d00.eps.jpeg ${prefix}.mov
