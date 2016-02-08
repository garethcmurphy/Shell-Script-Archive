#!/bin/tcsh
find . -type d -exec du -sk {} \; | sort -nr | head -50
