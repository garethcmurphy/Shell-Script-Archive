#!/bin/tcsh
convert orszag_mag_pressure.ppm orszag_mag_pressure.tiff
convert orszag_pressure.ppm orszag_pressure.tiff
montage -geometry 874x874 orszag_mag_pressure.tiff orszag_pressure.tiff o.tiff
montage -geometry 874x874 -tile 2x2 orszag_mag_pressure.tiff orszag_pressure.tiff orszag_mag_pressure.tiff orszag_pressure.tiff o.tiff

