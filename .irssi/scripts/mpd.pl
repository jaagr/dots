# MPD Now-Playing Script for irssi
# Copyright (C) 2005 Erik Scharwaechter
# <diozaka@gmx.de>
#
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License version 2
# as published by the Free Software Foundation.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# The full version of the license can be found at
# http://www.gnu.org/copyleft/gpl.html.
#
#
#######################################################################
# I'd like to thank Bumby <bumby@evilninja.org> for his impc script,  #
# which helped me a lot with making this script.                      #
#######################################################################
# Type "/np help" for a help page!                                    #
#######################################################################
# TODO:                                                               #
#  - add more format directives                                       #
#######################################################################
# CHANGELOG:                                                          #
#  0.4: First official release                                        #
#  0.5: Info message if no song is playing                            #
#       Display alternative text if artist and title are not set      #
#       Some minor changes                                            #
#######################################################################

use strict;
use IO::Socket;
use Irssi;

use vars qw{$VERSION %IRSSI %MPD};

$VERSION = "0.5";
%IRSSI = (
          name        => 'mpd',
          authors     => 'Erik Scharwaechter',
          contact     => 'diozaka@gmx.de',
          license     => 'GPLv2',
          description => 'print the song you are listening to',
         );

sub my_status_print {
    my($msg,$witem) = @_;

    if ($witem) {
        $witem->print($msg);
    } else {
        Irssi::print($msg);
    }
}

sub np {
    my($data,$server,$witem) = @_;

    if ($data =~ /^help/) {
        help();
        return;
    }

    $MPD{'port'}    = Irssi::settings_get_str('mpd_port');
    $MPD{'host'}    = Irssi::settings_get_str('mpd_host');
    $MPD{'timeout'} = Irssi::settings_get_str('mpd_timeout');
    $MPD{'format'}  = Irssi::settings_get_str('mpd_format');
    $MPD{'alt_text'} = Irssi::settings_get_str('mpd_alt_text');

    my $socket = IO::Socket::INET->new(
                          Proto    => 'tcp',
                          PeerPort => $MPD{'port'},
                          PeerAddr => $MPD{'host'},
                          timeout  => $MPD{'timeout'}
                          );

    if (not $socket) {
        my_status_print('No MPD listening at '.$MPD{'host'}.':'.$MPD{'port'}.'.', $witem);
        return;
    }

    $MPD{'status'}   = "";
    $MPD{'artist'}   = "";
    $MPD{'title'}    = "";
    $MPD{'filename'} = "";

    my $ans = "";
    my $str = "";

    print $socket "status\n";
    while (not $ans =~ /^(OK$|ACK)/) {
        $ans = <$socket>;
        if ($ans =~ /state: (.+)$/) {
            $MPD{'status'} = $1;
        }
    }

    if ($MPD{'status'} eq "stop") {
        my_status_print("No song playing in MPD.", $witem);
        close $socket;
        return;
    }

    print $socket "currentsong\n";
    $ans = "";
    while (not $ans =~ /^(OK$|ACK)/) {
        $ans = <$socket>;
        if ($ans =~ /file: (.+)$/) {
            my $filename = $1;
            $filename =~ s/.*\///;
            $MPD{'filename'} = $filename;
        } elsif ($ans =~ /^Artist: (.+)$/) {
            $MPD{'artist'} = $1;
        } elsif ($ans =~ /Title: (.+)$/) {
            $MPD{'title'} = $1;
        } elsif ($ans =~ /Album: (.+)$/) {
            $MPD{'album'} = $1;
        }
    }

    close $socket;

    if ($MPD{'artist'} eq "" and $MPD{'title'} eq "") {
        $str = $MPD{'alt_text'};
    } else {
        $str = $MPD{'format'};
    }

    $str =~ s/\%ARTIST/$MPD{'artist'}/g;
    $str =~ s/\%TITLE/$MPD{'title'}/g;
    $str =~ s/\%FILENAME/$MPD{'filename'}/g;

    if ($witem && ($witem->{type} eq "CHANNEL" ||
                   $witem->{type} eq "QUERY")) {
        if($MPD{'format'} =~ /^\/me /) {
				$witem->command("MSG \00307[\00304♫\00307] \00305".$MPD{'artist'}."\003 - \00302".$MPD{'title'}." \00307[\00313".$MPD{'album'}."\00307]");
        } else {
				$witem->command("MSG ".$witem->{name}." \00307[\00304♫\00307] \00302".$MPD{'artist'}." \00303".$MPD{'title'}." \00307[\00306".$MPD{'album'}."\00307]");
        }
    } else {
        Irssi::print("You're not in a channel.");
    }
}


sub help {
   print '
 MPD Now-Playing Script
========================

by Erik Scharwaechter (diozaka@gmx.de)

VARIABLES
  mpd_host      The host that runs MPD (localhost)
  mpd_port      The port MPD is bound to (6600)
  mpd_timeout   Connection timeout in seconds (5)
  mpd_format    The text to display (np: %%ARTIST - %%TITLE)
  mpd_alt_text  The Text to display, if %%ARTIST and %%TITLE are empty (np: %%FILENAME)

USAGE
  /np           Print the song you are listening to
  /np help      Print this text
';
}


Irssi::settings_add_str('mpd', 'mpd_host', 'localhost');
Irssi::settings_add_str('mpd', 'mpd_port', '6600');
Irssi::settings_add_str('mpd', 'mpd_timeout', '5');
Irssi::settings_add_str('mpd', 'mpd_format', 'np: %ARTIST - %TITLE');
Irssi::settings_add_str('mpd', 'mpd_alt_text', 'np: %FILENAME');

Irssi::command_bind np        => \&np;
Irssi::command_bind 'np help' => \&help;
