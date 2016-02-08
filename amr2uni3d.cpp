#include <iostream>
#include <fstream>
#include <cmath>
using namespace std;
// These are the block sizes 
#define X_SIZE 10
#define Y_SIZE 10
#define Z_SIZE 10
int
main (void)
{
  ifstream        inarray;
  ifstream        instuff;
  ofstream        outdump;
  ofstream        outstuffd;
  int             ii, jj, kk, block_no;
  int             proc_no=0;
  int             last_proc_no=0;
  float           xx, yy, zz;
  int             lrefine, lrefine_max;
  int             xcounter = 0;
  int             ycounter = 0;
  int             zcounter = 0;
  int             last_block_done = 99999999;
  double          dent, tempt, i_fract;
  float           den[X_SIZE][Y_SIZE][Z_SIZE];
  float           temp[X_SIZE][Y_SIZE][Z_SIZE];
  float           i_frac[X_SIZE][Y_SIZE][Z_SIZE];
  float           coord[3];
  float           nxncoord=0;
  double          refine_diff;
  char            inarrayname[] = "aarray_0055.txt";
  char            instuffname[] = "astuff_0055.txt";
  char            outstuffdname[] = "stuffd_0001.txt";
  char            outdumpname[] = "dump_0001.txt";
// nxncoord is the relationship between the domain and the effective total
// number of cells so 
// 32 blocks of 10 = 32x 10 =320 
// with a domain of 24 
// 320 /24 = 13.333 = 40.0 /3.0 
					nxncoord=40.0/3.0;
  cout << " " << "Levels of Refinement" << " " << endl;
  cout << " " << pow (2.0, 6.0) << " " << endl;
  cout << " " << "Allocate space" << " " << endl;
  cout << " " << "Doing ..." << " " << endl;
  /* Open the input and output files */
  inarray.open (inarrayname);
  instuff.open (instuffname);
  outdump.open (outdumpname);
  outstuffd.open (outstuffdname);
  /* Oddly enough this reads in the last block a second time. Wasn't expecting that to happen */
  kk = 0;
  while (!instuff.eof ())
     {
       /* Read in the block information */
       instuff >> proc_no >>block_no >> lrefine >> lrefine_max >> coord[0] >> coord[1] >> coord[2];
       /* check we're not doing a block twice */
       if (block_no == last_block_done  && proc_no == last_proc_no)
	  {
	    break;
	  }
       else
	  {
	    last_block_done = block_no;
	    last_proc_no = proc_no;
	  }
       refine_diff = pow ((double) 2.0, (double) (lrefine_max - lrefine));
       outstuffd << proc_no << " " << block_no << " " << lrefine << " " << lrefine_max << " " 
			 << coord[0] << " " << coord[1] << " " << coord[2] << endl;
       cout  << proc_no << " " << block_no << " " << lrefine << " " << lrefine_max << " " 
			 << nxncoord*coord[0] << " " << nxncoord*coord[1] << " " << nxncoord*coord[2] << endl;
       for (ii = 0; ii < X_SIZE; ii++)
	  {
	    for (jj = 0; jj < Y_SIZE; jj++)
	       {
		 for (kk = 0; kk < Z_SIZE; kk++)
		    {
		      /* read into temporary variables */
		      dent = tempt = i_fract = 0;
		      xx = yy = zz = 0;
		      inarray >> xx >> yy >> zz >> proc_no >> block_no >> dent >> tempt >> i_fract;
				/* Fill arrays , say 10x30 */
		      den[ii][jj][kk] = dent;
		      temp[ii][jj][kk] = tempt;
		      i_frac[ii][jj][kk] = i_fract;
		    }
	       }
	  }
       /* Now the rebinning takes place */
       /* First determine the level of refinement */
       for (ii = 0; ii < X_SIZE; ii++)
	  {
	    for (jj = 0; jj < Y_SIZE; jj++)
	       {
		 for (kk = 0; kk < Z_SIZE; kk++)
		    {
		      /* I simply print the variable however many extra times it needs to be printed */
		      for (xcounter = 0; xcounter < refine_diff; xcounter++)
			 {
			   for (ycounter = 0; ycounter < refine_diff; ycounter++) 
				{
			   for (zcounter = 0; zcounter < refine_diff; zcounter++) 
				{
				xx = nxncoord * coord[0] + ii * refine_diff + xcounter;
				yy = nxncoord * coord[1] + jj * refine_diff + ycounter;
				zz = nxncoord * coord[2] + kk * refine_diff + zcounter;
				outdump << block_no << " "
				  << xx << " "
				  << yy << " "
				  << zz << " "
				  << den [ii] [jj] [kk] << " "
				  << temp [ii] [jj] [kk] << " " 
				  << i_frac[ii][jj][kk] 
				  << endl;
//                              outdump << block_no <<" "<< xx <<" "<< yy <<" "<< zz <<" "<< dent <<" "<< tempt <<" "<< i_fract << endl;
			      }
				}
			 }
		    }
	       }
	  }
     }
  /* Close those files again */
  inarray.close ();
  instuff.close ();
  outdump.close ();
  outstuffd.close ();
  cout << " " << "Find relationship between real coords and grid points" <<
    "...done " << endl;
  /* Do some sort of check here */
  return 0;
}
