#!/usr/bin/perl
#
# ris2bib : convert a RIS database to a BiBTeX database
# Copyright 1992, Dana Jacobsen (dana@acm.org)
#
#version = "0.1.0"; #  7 Aug 92  jacobsd  Wrote original version
#version = "0.2.0"; # 13 Aug 92  jacobsd  Expanded from RIS documentation
#version = "0.2.1"; # 29 Aug 92  jacobsd  added -trim and -norep options
#$version = "0.2.2"; # 29 Aug 92  jacobsd  Changed names
#$version = "0.2.3"; # 19 May 03  Edward Vigmond - changed a bunch
$version = "0.2.4"; # 14 May 04  divakar - changed a bunch

#
# Edward Vigmond changes - make databases genrated by Science Direct work
#			T1 is equivalent to TI tag
#			EMACS-like key generation
#			names are left as they are
#			long entries are not truncated, they are put on several	lines
#
# todo: 
#
# All bug-fixes, suggestions, flames, and compliments gladly accepted.
#
#

# divakar changes - mainly added a line of code to handle UR field
# 		    from ScienceDirect RIS format
#			UR is converted into URL field for bibtex - lines 103, 313
#			names seperated by ';' instead of 'and' - line 96
#

$maxflength = 950;   # Bibtex doesnt want lines longer than this.
$maxllength = 14;    # maximum length of the text in a label (plus decade)
$toterrors = 0;
$trimdown = 0;       # don't include Abstract or Reprint fields
$noreprint = 0;      # don't include Reprint field

$capprotect = 1;   # -nocap-protect = 0. -cap-protect = 2.

while (@ARGV) {
  $_ = shift @ARGV;
  /^--$/  && do  { push(@files, @ARGV); undef @ARGV; next; };
  /^-noc/ && do  { $capprotect = 0;  next; };
  /^-cap/ && do  { $capprotect = 2;  next; };
  /^-trim/ && do { $trimdown = 1;    next; };
  /^-nore/ && do { $noreprint = 1;   next; };
  push (@files, $_);
}

print "%\n";
print "% converted from RIS format by ris-to-bibtex $version\n";
print "%\n\n";

foreach $infile (@files) {
 open (IN, $infile) || ((warn "Can't open $infile: $!\n"), next);
 $linenum = 0;
 $linenum    = 0;
 $lastfield  = 0;
 $errors     = 0;

 while (<IN>) {
  chop;
  s/\s*\r?$//;   # Refman at least, puts ^M's on lines as well as a bunch
                # of spaces.  This strips the ^M's and spaces on the right.
  $linenum++;

  /^\s*$/ && do { if ($lastfield) {
                    &doentry();
                    undef(%entry);
                    undef($lastfield);
                  }
                  next;
                };

  /^[^A-Z]/ && do { if ($lastfield) {
                    s/^\s+//;                   # strip of spaces on the left.
                    if ( ($lastfield eq AB) ) {
                      $entry{$lastfield} .= "\n" . $_;
                    } else {
                      $entry{$lastfield} .= " " . $_;
                    }
                  } else {
                    print STDERR "line $linenum:";
                    print STDERR "Line without field identifier: \n$_\n";
                    $errors++;
                  }
                  next;
                };

  $field = substr($_, 0, 2);

  $lastfield = $field;
  $rest = substr($_, 6);

  if ( ($field eq AU) || ($field eq ED) ) {
    $entry{$field} .= " and " . $rest;
  } elsif ($field eq KW) {
    $entry{$field} .= " ; " . $rest;
  } else {
    $entry{$field} .= " " . $rest;
  }

  $allindents = "TY ER AU IS PY SP EP KW AB RP T1 TI JO VL CT BT ED CY PB CP ET UR";
  if (index($allindents, $field) == -1) {
    &anerror("Unknown field identifier: $_");
  }
 }

 if (%entry) {
  &doentry();
 }

 foreach $type (sort keys(%number)) {
  printf STDERR "%5d %s\n", $number{$type}, $type;
  $totalentries += $number{$type};
 }

 print STDERR "$totalentries entries, ";

 if (!$errors) { $errors = "no"; }
 print STDERR "$errors error";
 $errors == 1 ? print STDERR "\n" : print STDERR "s\n";
 $toterrors += $errors;
}

exit $toterrors;




##########################################
#
sub doentry {

# do some processing on each field

  foreach $field (keys(%entry)) {
    $entry{$field} =~ s/^\s+//;
    $entry{$field} = &doibmtotex($entry{$field});
    if (($field eq AU) || ($field eq ED)){
      $entry{$field} =~ s/^and //;
      1 while $entry{$field} =~ s/  / /g;
    }
    # titles:  cap-protect = 0, leave them alone.
    #          cap-protect = 1, protect multi-cap sequences, and singles. (def)
    #          cap-protect = 2, protect all capitals.
    if ($field eq TI || $field eq T1) {
      if ($capprotect == 1) {
        1 while $entry{TI} =~ 
                 s/([^{\\\w]|^)([A-Z]+)([^{}\\\w]|$)/$1{$2}$3/g;
        $entry{TI} =~ s/^{([A-Z])}/$1/;
      } elsif ($capprotect == 2) {
        $entry{TI} =~ s/([A-Z]+)/{$1}/g;
      }
      s/(^|[^\\])~/$1\\ /g;          # convert ties (~) to literal space (\ )
    }
    if (length($entry{$field}) > $maxflength) {
      #$entry{$field} = substr($entry{$field}, 0, $maxflength-3);
      #$entry{$field} .= "...";
      #&anerror("field %$field longer than $maxflength characters.");
	  $entry{$field} =~ s/(.{1,60}\S+)/\t$1\n/g;
	  $entry{$field} .= "\t";
    }
	if( $field eq T1 ) {
		$entry{TI} = $entry{T1};
		delete $entry{T1};
	}
  }

  $entry{KW} =~ s/^; //;

  if ($entry{SP}) {
    if ($entry{EP}) {
      $entry{Pag} = $entry{SP} . '-' . $entry{EP};
    } else {
      $entry{Pag} = $entry{SP};
    }
  }

  if ($entry{VL}) {
    $_ = $entry{VL};
    s/^\d+\s*//;
    if (/^jan/i || /^feb/i || /^mar/i || /^apr/i || /^may/i || /^jun/i ||
        /^jul/i || /^aug/i || /^sep/i || /^oct/i || /^nov/i || /^dec/i ) {
      $entry{Mo} = $entry{VL};
      delete $entry{VL};
    }

    if ($entry{VL}) {
      if ( !(($entry{Vol}, $entry{Num}) = $entry{VL} =~ /(\d*)\s*\((.*)\)/) ) {
        if ( !(($entry{Vol}, $entry{Num}) = $entry{VL} =~ /(\S*)\s*no[^v]\s*(.*)/i) ) {
          $entry{Vol} = $entry{VL};
        }
      }
    }
  }

  # set date fields

  if ($entry{PY}) {
    if ($entry{PY} =~ /^\d\d\d\d/) {
      $entry{Yr} = substr($entry{PY},0,4);
    } else {
     &anerror("PY field is not valid.");
    }
  }
  $entry{YrKey} = $entry{Yr} ? $entry{Yr} : "????";
  $entry{Decade} = substr($entry{YrKey}, 2, 2);


  if ($entry{AU}) {
    $entry{Key_AU} = &parsename($entry{AU});
    $entry{AU} = $fname;
  }

  if ($entry{ED}) {
    $entry{Key_ED} = &parsename($entry{ED});
    $entry{ED} = $fname;
  }

  if ($entry{PB}) {
    ($entry{Key_PB}) = split(/[\s~]/, $entry{PB});
  }

  # set or generate key
  &genkey();

  # determine the Entry Type

  if ($entry{TY} eq 'JOUR') {
    $type = 'article';
    $_ = $entry{JO};
    if (/^proc\w*\.\s/i || /proceeding/i || /conference/i || /workshop/i) {
      $type = 'inproceedings';
      if (!$entry{CT}) {
        $entry{CT} = $entry{TI};
        delete $entry{TI};
      }
      if (!$entry{BT}) {
        $entry{BT} = $entry{JO};
        delete $entry{JO};
      }
    }
  } elsif ($entry{TY} eq 'BOOK') {
    $type = 'book';
  } elsif ($entry{TY} eq 'ABST') {
    $type = 'article';
  } elsif ($entry{TY} eq 'CHAP') {
    if ($entry{CP}) {
      if ($entry{CP} != 0) {
        $entry{Chap} = $entry{CP};
      }
    }
    if ($entry{CT}) {
      $type = 'incollection';
    } else {
      $type = 'inbook';
      $entry{Chap} = $entry{CP};
    }
    $_ = $entry{BT};
    if (/^proc\w*\.\s/i || /proceeding/i || /conference/i || /workshop/i) {
      $type = 'inproceedings';
    }
  } elsif ($entry{TY} eq 'UNPB') {
    $type = 'unpublished';
  } elsif ($entry{TY} eq 'INPR') {
    $type = 'article';
  } else {                    # There shouldn't ever be anything else
    $type = 'misc';
  }

  $number{$type}++;
  
  # Change things around for each types
  $_ = $type;

  # Syntax checking

  /^article/       && (&syntax(AU, TI, JO, Yr));
  /^book/          && (&syntax(AE, BoT, PB, Yr));
  /^incollection/  && (&syntax(AU, CT, BT, PB, Yr));
  /^inbook/        && (&syntax(AE, CT, CP, BT, PB, Yr));
  /^inproceedings/ && (&syntax(AU, CT, BT, Yr));
  /^proceedings/   && (&syntax(BoT, Yr));
  /^unpublished/   && (&syntax(AU, BoT, RP));

  # set up the entry output string

  $ent = '@';
  $ent .= "$type\{$key,\n";

  if ($entry{Key})  { $ent .= "   key = \{$entry{Key}\},\n"; }
  if ($entry{AU})   { $ent .= "   author = \{$entry{AU}\},\n"; }
  if ($entry{ED})   { $ent .= "   editor = \{$entry{ED}\},\n"; }
  if ($entry{TI})   { $ent .= "   title = \{$entry{TI}\},\n"; }
  if ($entry{CT})   { $ent .= "   title = \{$entry{CT}\},\n"; }
  if ($entry{BT})   {
    if ($entry{TI} || $entry{CT} ) {
                     $ent .= "   booktitle = \{$entry{BT}\},\n";
    } else {
                     $ent .= "   title = \{$entry{BT}\},\n";
    } }
  if ($entry{JO})   { $ent .= "   journal = \{$entry{JO}\},\n"; }
  if ($entry{Vol})  { $ent .= "   volume = \{$entry{Vol}\},\n"; }
  if ($entry{Num})  { $ent .= "   number = \{$entry{Num}\},\n"; }
  if ($entry{ET})   { $ent .= "   edition = \{$entry{ET}\},\n"; }
  if ($entry{Chap}) { $ent .= "   chapter = \{$entry{Chap}\},\n"; }
  if ($entry{Pag})  { $ent .= "   pages = \{$entry{Pag}\},\n"; }
  if ($entry{PB})   { $ent .= "   publisher = \{$entry{PB}\},\n"; }
  if ($entry{CY})   { $ent .= "   address = \{$entry{CY}\},\n"; }
  if ($entry{Mo})   { $ent .= "   month = \{$entry{Mo}\},\n"; }
  if ($entry{Yr})   { $ent .= "   year = \{$entry{Yr}\},\n"; }
  if ($entry{UR})   { $ent .= "   url = \{$entry{UR}\},\n"; }

  if (!$trimdown) {
    if ($entry{AB})   { $ent .= "   abstract = \{$entry{AB}\},\n"; }
    if (!$noreprint) {
      if ($entry{RP})   { $ent .= "   note = \{Reprint: $entry{RP}\},\n"; }
    }
  }
  if ($entry{KW})   { $ent .= "   keywords = \{$entry{KW}\},\n"; }

  substr($ent, -2, 1) = '';
  $ent .= "\}\n\n";

  &printerrors();
  print $ent;
}


##########################################
# key is Author's last name followed by last 2 digits of year followed
# by ":_" followed by first 6 letters of title where spaces are replaced
# by "_". Similar to EMACS
# in case of conflict, ascending letters are added to the end
#
sub genkey {
  local($noadd) = @_;
  local($name);

  $name = $entry{Key_AU} || $entry{Key_ED}
          || $entry{Key_PB} || $noadd || "Anonymous";

  $key_title = substr($entry{TI},0,6);
  $key_title =~ s/\s/_/g;
  $key_title =~ tr/A-Z/a-z/;
  $key = $name . $entry{Decade} . ":_" . $key_title ;

  if ($allkeys{$key}) {
    $key .= 'a';
    while ($allkeys{$key}) {
      substr($key,-1,1)++;
    }
  }
  $key =~ s/,//g;

  if ($noadd) {
    return($key);
  }

  $allkeys{$key} = $key;
  if ($name eq "Anonymous") {
    $entry{Key} = $key;
  }
}

##########################################
# key is Author's last name followed by last 2 digits of year.
# in corporate author's case, key is first word and first 2 digits.
# order is L, A, Q, E, I, "Anonymous"
# in case of conflict, ascending letters are added to the end
#
sub genkeyold {
  local($noadd) = @_;
  local($name);

  $name = $entry{Key_AU} || $entry{Key_ED}
          || $entry{Key_PB} || $noadd || "Anonymous";

  $name = sprintf("%.${maxllength}s", $name);
  $key = $name . $entry{Decade};

  if ($allkeys{$key}) {
    $key .= 'a';
    while ($allkeys{$key}) {
      substr($key,-1,1)++;
    }
  }
  $key =~ s/,//g;
  if ($noadd) {
    return($key);
  }

  $allkeys{$key} = $key;
  if ($name eq "Anonymous") {
    $entry{Key} = $key;
  }
}

##########################################
# parsename parses names from RIS into BiBTeX format
#
#
sub parsename {
  local($allnames) = $_[0];
  local(@names, $keyn, $name, $firstn, $lastn, $jrn);
	
  undef $fname;

  @names = split(/ and /, $allnames);

  ($keyn, $firstn, $jrn) = split(/,/, $names[0]);

  while (@names) {
    $name = shift @names;
	$fname .= " and " . $name;
  }
  $fname =~ s/^ and\s+//;

  return $keyn;
}
  
##########################################
# parsename parses names from RIS into BiBTeX format
#
# old way of doing things screwed up names
sub parsename_orig {
  local($allnames) = @_;
  local(@names, $keyn, $name, $firstn, $lastn, $jrn);
 
  undef $fname;

  @names = split(/ and /, $allnames);

  while (@names) {
    $name = shift @names;
    $firstn = $lastn = $jrn = '';
    ($lastn, $firstn, $jrn) = split(/,/, $name);

    $firstn =~ s/[.]/. /g;
    $firstn =~ s/\$>\$$/. /g;
    if ( $firstn && ($firstn !~ / $/) ) {
      &anerror("Missing . on end of last initial in name.");
      $firstn .= ". ";
    }

    if ($lastn =~ /[A-Z]\w*\s/) {
      $lastn = "{" . $lastn . "}";
    }

    if ($name =~ /^et al\.?\s*$/) {
      $firstn = $lastn = $jrn = '';
      $lastn = "others";
    }

    if ($jrn) {
      $fname .= " and " . $lastn . ", " . $jrn . ", " . $firstn;
    } else {
      $fname .= " and " . $firstn . $lastn;
    }

    if (!$keyn) {
      $keyn = $lastn;
      $keyn =~ tr/A-Za-z0-9\/\-//cd;
    }
  }
  $fname =~ s/^ and\s+//;
  $fname =~ s/\s+$//;
  1 while $fname =~ s/  / /g;

  return $keyn;
}


##########################################
# syntax does syntax checking
#
sub syntax {
  foreach $field (@_) {
    if ($field eq AE) {
      if ( (!$entry{AU}) && (!$entry{ED}) ) {
        &anerror("Missing AU and ED (Author and Editor) fields.");
      }
    } elsif ($field eq BoT) {
      if ( (!$entry{BT}) && (!$entry{TI}) ) {
        &anerror("Missing TI (Title) field.");
      }
    } else {
      if (!$entry{$field}) {
        &anerror("Missing $field field.");
      }
    }
  }
}



##########################################
# stores error information until it gets printed
#
# This allows us to fully process the entry so we can print out
# valid key information without having to go through ugly gyrations.
#
sub anerror {
  local($err) = @_;

  push(@errorstring, $err);
  $errors++;
}



##########################################
# prints out stored error information
#
sub printerrors {
  local($klen, $errst);

  if (@errorstring) {
    $klen = $maxllength;  # a little short, but most labels aren't this long
    foreach $_ (@errorstring) {
      $errst .= sprintf("%-${klen}s (%5d): %s\n", $key, $errline, $_);
    }
    print STDERR $errst;
    undef @errorstring;
  }
  $errline = $linenum+1;
}

##########################################
# converts IBM PC characters to TeX characters
#
# everything commented out in this routine caused me grief with Linux Red
# Hat 7.3. Didn't seem to cause problems
#
sub doibmtotex {
  local($_) = @_;
 
  # protect TeX characters
  s/\\/_I/g;
  s/#/\\#/g;
  #s/\$/\\$/g;
  s/%/\\%/g;
  s/&/\\&/g;
  s/{/\\{/g;
  s/}/\\}/g;
  #s/\|/$|$/g;
  #/</\$<$/g;
  #s/>/\$>$/g;
  s/\^/\\^{}/g;
  s/~/\\~{}/g;
  s/_I/\$\\backslash\$/g;
  s/_/\_/g;

  # subscripted characters (ie CO2)
  s/[\303][\006][\303]([^\304]*)[\304][\006][\304]/\${}_{$1}\$/g;
  # italics (Note: The ^H's are real backspaces!)
  s/[\303][][\303]([^\304]*)[\304][][\304]/{\\it $1}/g;
  # an o umlaut
  s/[\300][?][\001][\300]/{\\"o}/g;

  return $_;
}
