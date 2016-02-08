
nfiles=`ls id0/CylNewtZ8.????.vtk | wc -l`
echo ${nfiles}
count=`expr ${nfiles} - 1`

for i in `seq -f "%02g" 0 ${count}` 
do
./join_vtk -o CylNewtZ8.00${i}.vtk  id*/CylNewtZ8*00${i}.vtk
done


echo  `seq -f "%02g" 0 ${count}` 

echo "Joined $nfiles files"
