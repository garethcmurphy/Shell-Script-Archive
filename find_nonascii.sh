cat interviewquestions.tex  | perl -ane '{ if(m/[[:^ascii:]]/) { print  } }' > newFile
