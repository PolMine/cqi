#!/usr/bin/perl -w
###################################################################
###                                                             ###
###      File: /projekte/CWB/CQi/spec/MakeInterfaces.perl       ###
###   Version:                                                  ###
###    Author: Stefan Evert                                     ###
###   Purpose: Convert CQi specification to header files for various languages
###   Created: Wed Sep 15 15:35:01 1999                         ###
###  Modified: Fri Sep 24 16:46:20 1999 (evert)                 ###
###                                                             ###
###################################################################
#
# History:
#
use FileHandle;


$spec = "cqi.spec";
$maj_version = 0;
$min_version = 1;
$version = "v$maj_version.$min_version";
$copy = "(C) Stefan Evert, IMS Stuttgart, Sep 1999";

# conversion rules
@Language = (
       [
        "C/cqi.h",           # name of generated header file
        $C_prologue,           # file prologue (defined in BEGIN block at end of script)
        $C_epilogue,           # file epilogue
        "/*%-70s */\n",          # comment line (printf format)
        "#define CQI_%s 0x%02X\n", # unsigned byte constant (prefix "CQI_" stripped from CONST name)
        "#define CQI_%s 0x%04X\n", # unsigned word constant
        "#define CQI_%s %d\n",     # decimal constant value
        undef,    # if defined, CODE ref to subroutine which generates CQi command name lookup hash
       ],
       [
        "perl/CQI.pm",
        $Perl_prologue,
        $Perl_epilogue,
        "#%s\n",
        "\$%s = 0x%02X;\n",
        "\$%s = 0x%04X;\n",
        "\$%s = %d;\n",
        \&make_perl_lookup_hash,
       ],
       [
        "python/CQI.py",
        $Python_prologue,
        $Python_epilogue,
        "#%s\n",
        "%s = 0x%02X\n",
        "%s = 0x%04X\n",
        "%s = %d\n",
        \&make_python_lookup_hash,
       ],
       [
        "java/CqiSpec.java",
        $Java_prologue,
        $Java_epilogue,
        "//%s\n",
        "public static final int %s = 0x%02X;\n",
        "public static final int %s = 0x%04X;\n",
        "public static final int %s = %d;\n",
        undef,
       ],
      );



print "CQi spec to header converter.\n";
print "[$spec]  CQi $version\n";

sub print_comment($) {
  my $comment = shift;
  printf $fh $comment_format, $comment;
}

sub print_hex2 ($$) {
  my $const = shift;
  my $val = shift;
  printf $fh $hex2_format, $const, $val;
}

sub print_hex4 ($$) {
  my $const = shift;
  my $val = shift;
  printf $fh $hex4_format, $const, $val;
}

sub print_decimal ($$) {
  my $const = shift;
  my $val = shift;
  printf $fh $decimal_format, $const, $val;
}
         
sub print_padding ($) {
  my $lines = shift;
  for ( ; $lines > 0; $lines--) {
    print $fh "\n";
  }
}

sub hexval ($) {
  my $hex = shift;
  my $val = 0;
  eval "\$val = 0x$hex;"; # YUCK
  return $val;
}

sub cut_prefix ($) {
  my $name = shift;
  $name =~ s/^CQI_//;
  return $name;
}


foreach $language (@Language) {
  ($outfile, $prologue, $epilogue, 
   $comment_format, $hex2_format, $hex4_format, $decimal_format, 
   $make_lookup_hash) = @$language;
  print " --> $outfile\n";
  $fh = new FileHandle "> $outfile"
    or die "Can't write '$outfile': $!";
  $spec_fh = new FileHandle "$spec"
    or die "Can't read '$spec': $!";
  
  $current_group = undef;   # check that the group part of commands agrees with the current group
  %command_known = ();      # ensure there are no duplicate command codes

  # CQi interface header
  print_comment "";
  print_comment "   CQi $version";
  print_comment "   (IMS/HIT Corpus Query Interface)",
  print_comment "   $copy";
  print_comment "";

  print_padding 4;

  print $fh $prologue;

  print_padding 1;
  print_comment " default port for CQi services";
  print_decimal "PORT", 4877;
  
  while (<$spec_fh>) {
    chomp;
    next if /^\#/;  # skip comments
    # BLANK LINES (copied from specification file)
    if (/^\s*$/) {
      print_padding 1;
    }
    # SECTION HEADING
    elsif (/^HEAD\s+(.*)$/) { # differentiate if we want to check command codes for uniqueness
      $text = $1;
      print_comment "  ***";
      print_comment "  ***   $text";
      print_comment "  ***";
    }
    # COMMAND GROUP
    elsif (/^([0-9A-F]{2})\s+([A-Z0-9_]+)\s*$/) {
      $group = hexval $1;
      $name = cut_prefix $2;
      print_hex2 $name, $group;
      $current_group = $group;
    }
    # COMMAND
    elsif (/^([0-9A-F]{2}):([0-9A-F]{2})\s+([A-Z0-9_]+)\s*$/) {
      $group = hexval $1;
      $code = hexval "$1$2";
      $fullname = $3;
      $name = cut_prefix $fullname;
      if (defined $command_known{$code}) {
  die 
    "ERROR Duplicate command code $1:$2 for $fullname.",
    "ERROR First definition was " . $command_known{$code}, 
    "\n";
      }
      elsif ($group != $current_group) {
  die
    "ERROR Wrong group code in command $name.",
    (sprintf "ERROR Command code is $1:$2, current group is %02X", $current_group),
    "\n";
      }
      else {
  $command_known{$code} = $fullname;
  print_hex4 $name, $code;
      }
    }
    # COMMENT
    elsif (/^%%(.*)$/) {
      $comment = $1;
      print_comment($comment);
    }
    # INPUT (just comments for now)
    elsif (/^<<\s*(.*)$/) {
      $input = $1;
      print_comment(" INPUT: $input");
    }
    # OUTPUT (just comments for now)
    elsif (/^>>\s*(.*)$/) {
      $output = $1;
      print_comment(" OUTPUT: $output");
    }
    else {
      print "SYNTAX ERROR:  $_\n";
    }

  }

  print_padding 1;    # append version information to CONST block
  print_comment(" CQi version is CQI_MAJOR_VERSION.CQI_MINOR_VERSION");
  print_hex2 "MAJOR_VERSION", $maj_version;
  print_hex2 "MINOR_VERSION", $min_version;

  if (defined $make_lookup_hash) {
    &$make_lookup_hash;
  }

  print_padding 4;

  print $fh $epilogue;

  $fh->close;
  $spec_fh->close;
}





BEGIN {
  $C_prologue = "";   # no special code required
  $C_epilogue = "";

  $Perl_prologue = "package CQI;\n";    # need to specify package name
  $Perl_epilogue = "return 1;\n";   # end of module

  $Python_prologue = ""; # no special code seems to be required in Python
  $Python_epilogue = "";

  $Java_prologue = "// package cqi;\n" 
    ."public class CqiSpec {\n";
  
  $Java_epilogue = "}\n";

  sub make_perl_lookup_hash {
    my $code;

    print_padding(4);
    print_comment(" CQi command name lookup hash.");
    print $fh "%CommandName = (\n";
    foreach $code (sort {$a <=> $b} keys %command_known) {
      print $fh "\t$code => '$command_known{$code}',\n";
    }
    print $fh ");\n"
  }

  sub make_python_lookup_hash {
    my $code;

    print_padding(4);
    print_comment(" CQi command name lookup hash.");
    print $fh "CommandName = {\n";
    foreach $code (sort {$a <=> $b} keys %command_known) {
      print $fh "  $code: '$command_known{$code}',\n";
    }
    print $fh "}\n"
  }
}
