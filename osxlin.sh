
hname=`hostname`
if [ "$(hname)" == "dune.nbi.int.dk" ]; then
    # Do something under Mac OS X platform        
    nproc=12
elif [ "$(hname)" == "murphy-imac.int.nbi.dk" ]; then
    # Do something under Linux platform
    nproc=`sysctl -n hw.physicalcpu`
elif [ "$(hname)" == "astro06.hpc.ku.dk" ]; then
    # Do something under Windows NT platform
    nproc=32
fi


 echo make -j ${nproc}  \&\&  mpiexec -n ${nproc} ./pluto
 make -j ${nproc}  &&  mpiexec -n ${nproc} ./pluto
