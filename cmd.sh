physicalCpuCount=$([[ $(uname) = 'Darwin' ]] && 
                       sysctl -n hw.physicalcpu_max ||
                       lscpu -p | egrep -v '^#' | sort -u -t, -k 2,4 | wc -l)
nproc=${physicalCpuCount}

exec=./pluto
#exec=./athena
input="-i ../tst/cylindrical/athinput.hkdisk-3D"
input=""
make="pushd ../ && make -j 5 all && popd "
make=make


if [ -f ./athena ];
then
   echo "athena"
exec=./athena
input="-i ../tst/cylindrical/athinput.hkdisk-3D"
make="pushd ../ && make -j 5 all && popd "
make=""
fi

if [ -f ./pluto ];
then
exec=./pluto
input=""
make=make
fi





echo make -j ${nproc} \&\& mpiexec -n ${nproc} ${exec}
$make -j ${nproc} && mpiexec -n ${nproc}  ${exec} ${input}
