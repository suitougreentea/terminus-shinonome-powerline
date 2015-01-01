#!/usr/bin/perl

use open ":utf8";
use File::Copy;
use File::Path;

jis2unicode("shnmk12.bdf", "shnmk12.ubdf");
jis2unicode("shnmk12b.bdf", "shnmk12b.ubdf");
jis2unicode("shnmk14.bdf", "shnmk14.ubdf");
jis2unicode("shnmk14b.bdf", "shnmk14b.ubdf");
jis2unicode("shnmk16.bdf", "shnmk16.ubdf");
jis2unicode("shnmk16b.bdf", "shnmk16b.ubdf");

mkbold("ter-powerline-x12b.bdf", "ter-powerline-x12b.bbdf");

combine("ter-powerline-x12n.bdf", "shnmk12.ubdf", "tershn12.bdf");
combine("ter-powerline-x12b.bbdf", "shnmk12b.ubdf", "tershn12b.bdf");
combine("ter-powerline-x14n.bdf", "shnmk14.ubdf", "tershn14.bdf");
combine("ter-powerline-x14b.bdf", "shnmk14b.ubdf", "tershn14b.bdf");
combine("ter-powerline-x16n.bdf", "shnmk16.ubdf", "tershn16.bdf");
combine("ter-powerline-x16b.bdf", "shnmk16b.ubdf", "tershn16b.bdf");

bdftopcf("tershn12.bdf", "tershn12.pcf");
bdftopcf("tershn12b.bdf", "tershn12b.pcf");
bdftopcf("tershn14.bdf", "tershn14.pcf");
bdftopcf("tershn14b.bdf", "tershn14b.pcf");
bdftopcf("tershn16.bdf", "tershn16.pcf");
bdftopcf("tershn16b.bdf", "tershn16b.pcf");

sub jis2unicode {
  print "[jis2unicode] @_[0] -> @_[1]\n";
  system "perl jis2unicode.pl -b < @_[0] > @_[1]";
}

sub mkbold {
  print "[mkbold] @_[0] -> @_[1]\n";
  system "perl mkbold.pl -r @_[0] > @_[1]";
}

sub combine {
  print "[combine] @_[0] + @_[1] -> @_[2]\n";
  my ($parent, $child, $output) = @_;
  
  my $header = "";
  my $chars = 0;
  my $chardata = "";

  my $inheader = 0;

  open(my $fh, "<", $parent);
  while(my $line = readline $fh) {
    chomp $line;
    if($line =~ /^(START|END)FONT.*/) {
      next;
    }
    if($line =~ /^FONT .*/) {
      $inheader = 1;
    }
    if($line =~ /^CHARS .*/) {
      @elem = split(/ /, $line);
      $chars += @elem[1] + 0;
      next;
    }
    if($inheader) {
      $header =  $header . $line . "\n";
    } else {
      $chardata = $chardata . $line . "\n";
    }
    if($line =~ /^ENDPROPERTIES/) {
      $inheader = 0;
    }
  }
  close $fh;

  my $inchar = 0;

  open(my $fh, "<", $child);
  while(my $line = readline $fh) {
    chomp $line;
    if($line =~ /^(START|END)FONT.*/) {
      next;
    }
    if($inchar) {
      $chardata = $chardata . $line . "\n";
    }
    if($line =~ /^CHARS .*/) {
      @elem = split(/ /, $line);
      $chars += @elem[1] + 0;
      $inchar = 1;
      next;
    }
  }
  close $fh;

  $header =~ s/FONT (.*)-TerminessPowerline-(.*)/FONT $1-TerminusShinonomePowerline-$2/;
  $header =~ s/FAMILY_NAME "Terminess Powerline"/FAMILY_NAME "Terminus-Shinonome Powerline"/;

  open(FH, "> $output");
  print FH "STARTFONT 2.1\n$header\nCHARS $chars\n$chardata\nENDFONT\n";
  close(FH);
}

sub bdftopcf {
  print "[bdftopcf] @_[0] -> @_[1]\n";
  system "bdftopcf @_[0] > @_[1]";
}
