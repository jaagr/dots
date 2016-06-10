#! /usr/bin/perl
#
#    $Id: chansort.pl,v 1.4 2004/11/02 22:52:33 peder Exp $
#
# Copyright (C) 2004 by Peder Stray <peder@gzip.ninja.no>
#

use strict;
use Irssi;
use Irssi::Irc;

# ======[ Script Header ]===============================================

use vars qw{$VERSION %IRSSI};
($VERSION) = '$Revision: 1.4 $' =~ / (\d+\.\d+) /;
%IRSSI = (
          name        => 'chansort',
          authors     => 'Peder Stray',
          contact     => 'peder@ninja.no',
          url         => 'http://ninja.no/irssi/chansort.pl',
          license     => 'GPL',
          description => 'Sort all channel and query windows',
         );

# ======[ Hooks ]=======================================================

# --------[ sig_sort_trigger ]------------------------------------------

sub sig_sort_trigger {
    return unless Irssi::settings_get_bool('chansort_autosort');
    cmd_chansort();
}

# ======[ Commands ]====================================================

# --------[ CHANSORT ]--------------------------------------------------

# Usage: /CHANSORT
sub cmd_chansort {
    my(@windows);
    my($minwin);

    for my $win (Irssi::windows()) {
	my $act = $win->{active};
	my $key;

	if ($act->{type} eq 'CHANNEL') {
	    $key = "C".$act->{server}{tag}.' '.substr($act->{visible_name}, 1);
	}
	elsif ($act->{type} eq 'QUERY') {
	    $key = "Q".$act->{server}{tag}.' '.$act->{visible_name};
	}
	else {
	    next;
	}
	if (!defined($minwin) || $minwin > $win->{refnum}) {
	    $minwin = $win->{refnum};
	}
	push @windows, [ lc $key, $win ];

    }

    for (sort {$a->[0] cmp $b->[0]} @windows) {
	my($key,$win) = @$_;
	my($act) = $win->{active};
    
#	printf("win[%d->%d]: t[%s] [%s] [%s] {%s}\n", 
#	       $win->{refnum},
#	       $minwin,
#	       $act->{type},
#	       $act->{visible_name},
#	       $act->{server}{tag},
#	       $key,
#	      );

	$win->command("window move $minwin");
	$minwin++;
    }
}

# ======[ Setup ]=======================================================

# --------[ Register commands ]-----------------------------------------

Irssi::command_bind('chansort', 'cmd_chansort');

# --------[ Register settings ]-----------------------------------------

Irssi::settings_add_bool('chansort', 'chansort_autosort', 0);

# --------[ Register signals ]------------------------------------------

Irssi::signal_add_last('window item name changed', 'sig_sort_trigger');
Irssi::signal_add_last('channel created', 'sig_sort_trigger');
Irssi::signal_add_last('query created', 'sig_sort_trigger');

# ======[ END ]=========================================================

# Local Variables:
# header-initial-hide: t
# mode: header-minor
# end:

