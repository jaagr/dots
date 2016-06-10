use strict;
use warnings;

our $VERSION = '1.1'; # 29104182e11c798
our %IRSSI = (
    authors     => 'Nei',
    contact     => 'Nei @ anti@conference.jabber.teamidiot.de',
    url         => "http://anti.teamidiot.de/",
    name        => 'adv_windowlist',
    description => 'Adds a permanent advanced window list on the right or in a status bar.',
    license     => 'GNU GPLv2 or later',
   );

# UPGRADE NOTE
# ============
# for users of 0.7 or earlier series, please note that appearance
# settings have moved to /format, i.e. inside your theme!
# the fifo (screen) has been replaced by an external viewer script

# Usage
# =====
# copy the script to ~/.irssi/scripts/
#
# In irssi:
#
#		/run adv_windowlist
#
# In your shell (for example a tmux split):
#
#		perl ~/.irssi/scripts/adv_windowlist.pl
#
# To use sbar mode instead:
#
#		/toggle awl_viewer
#
# Hint: to get rid of the old [Act:] display
#     /statusbar window remove act
#
# to get it back:
#     /statusbar window add -after lag -priority 10 act

# Options
# =======
# formats can be cleared with /format -delete
#
# /format awl_display_(no)key(_active|_visible) <string>
# * string : Format String for one window. The following $'s are expanded:
#     $C : Name
#     $N : Number of the Window
#     $Q : meta-Keymap
#     $H : Start hilighting
#     $S : Stop hilighting
#         /+++++++++++++++++++++++++++++++++,
#        | ****  I M P O R T A N T :  ****  |
#        |                                  |
#        | don't forget  to use  $S  if you |
#        | used $H before!                  |
#        |                                  |
#        '+++++++++++++++++++++++++++++++++/
#   key     : a key binding that goes to this window could be detected in /bind
#   nokey   : no such key binding was detected
#   active  : window would receive the input you are currently typing
#   visible : window is also visible on screen but not active (a split window)
#
# /format awl_name_display <string>
# * string : Format String for window names
#     $0 : name as formatted by the settings
#
# /format awl_display_header <string>
# * string : Format String for this header line. The following $'s are expanded:
#     $C : network tag
#
# /format awl_separator(2) <string>
# * string : Character to use between the channel entries
# variant 2 can be used for alternating separators (only in status bar
# without block display)
#
# /format awl_viewer_item_bg <string>
# * string : Format String specifying the viewer's item background colour
#
# /set awl_prefer_name <ON|OFF>
# * this setting decides whether awl will use the active_name (OFF) or the
#   window name as the name/caption in awl_display_*.
#   That way you can rename windows using /window name myownname.
#
# /set awl_hide_empty <num>
# * if visible windows without items should be hidden from the window list
# set it to 0 to show all windows
#           1 to hide visible windows without items (negative exempt
#           active window)
#
# /set awl_hide_data <num>
# * num : hide the window if its data_level is below num
# set it to 0 to basically disable this feature,
#           1 if you don't want windows without activity to be shown
#           2 to show only those windows with channel text or hilight
#           3 to show only windows with hilight (negative exempt active window)
#
# /set awl_hide_name_data <num>
# * num : hide the name of the window if its data_level is below num
#   (only works in status bar without block display)
# you will want to change your formats to add $H...$S around $Q or $N
# if you plan to use this
#
# /set awl_maxlines <num>
# * num : number of lines to use for the window list (0 to disable, negative
#   lock)
#
# /set awl_maxcolumns <num>
# * num : number of columns to use for the window list when using the
#   tmux integration (0 to disable)
#
# /set awl_block <num>
# * num : width of a column in viewer mode (negative values = block
#   display in status bar mode)
#         /+++++++++++++++++++++++++++++++++,
#        | ******  W A R N I N G !  ******  |
#        |                                  |
#        | If  your  block  display  looks  |
#        | DISTORTED,  you need to add the  |
#        | following  line to your  .theme  |
#        | file under                       |
#        |     abstracts = {             :  |
#        |                                  |
#        |       sb_act_none = "%K$*";      |
#        |                                  |
#        '+++++++++++++++++++++++++++++++++/
#
# /set awl_sbar_maxlength <ON|OFF>
# * if you enable the maxlength setting, the block width will be used as a
#   maximum length for the non-block status bar mode too.
#
# /set awl_height_adjust <num>
# * num : how many lines to leave empty in viewer mode
#
# /set awl_sort <-data_level|-last_line|refnum>
# * you can change the window sort order with this variable
#     -data_level : sort windows with hilight first
#     -last_line  : sort windows in order of activity
#     refnum      : sort windows by window number
#     active/server/tag : sort by server name
#   "-" reverses the sort order
#   typechecks are supported via ::, e.g. active::Query or active::Irc::Query
#   undefinedness can be checked with ~, e.g. ~active
#   string comparison can be done with =, e.g. name=(status)
#   to make sort case insensitive, use #i, e.g. name#i
#   any key in the window hash can be tested, e.g. active/chat_type=XMPP
#   multiple criteria can be separated with , or +, e.g. -data_level+-last_line
#
# /set awl_placement <top|bottom>
# /set awl_position <num>
# * these settings correspond to /statusbar because awl will create
#   status bars for you
# (see /help statusbar to learn more)
#
# /set awl_all_disable <ON|OFF>
# * if you set awl_all_disable to ON, awl will also remove the
#   last status bar it created if it is empty.
#   As you might guess, this only makes sense with awl_hide_data > 0 ;)
#
# /set awl_viewer <ON|OFF>
# * enable the external viewer script
#
# /set awl_viewer_launch <ON|OFF>
# * try to auto-launch the viewer under tmux or with a shell command
#   /awl restart is required all auto-launch related settings to take
#   effect
#
# /set awl_viewer_tmux_position <left|top|right|bottom|custom>
# * try to split in this direction when using tmux for the viewer
#   custom : use custom_command setting
#
# /set awl_viewer_xwin_command <shell command>
# * custom command to run in order to start the viewer when irssi is
#   running under X
#   %A  - gets replaced by the command to run the viewer
#   %qA - additionally quote the command
#
# /set awl_viewer_custom_command <shell command>
# * custom command to run in order to start the viewer
#
# /set awl_viewer_launch_env <string>
# * specific environment settings for use on viewer auto-launch,
#   without the AWL_ prefix
#
# /set awl_shared_sbar <left<right|OFF>
# * share a status bar for the first awl item, you will need to manually
#   /statusbar window add -after lag -priority 10 awl_shared
#     left   : space in cells occupied on the left of status bar
#     right  : space occupied on the right
# Note: you need to replace "left" AND "right" with the appropriate numbers!
#
# /set awl_path <path>
# * path to the file which the viewer script reads
#
# /set fancy_abbrev <no|head|strict|fancy>
# * how to shorten too long names
#     no     : shorten in the middle
#     head   : always cut off the ends
#     strict : shorten repeating substrings
#     fancy  : combination of no+strict
#
# /set awl_custom_xform <perl code>
# * specify a custom routine to transform window names
#   example: s/^#// remove the #-mark of IRC channels
#   the special flags $CHANNEL / $TAG / $QUERY / $NAME can be
#   tested in conditionals
#
# /set awl_last_line_shade <timeout>
# * set timeout to shade activity base colours, to enable
#   you also need to add +-last_line to awl_sort
#   (requires 256 colour support)
#
# /set awl_no_mode_hint <ON|OFF>
# * whether to show the hint of running the viewer script in the
#   status bar
#
# /set awl_mouse <ON|OFF>
# * enable the terminal mouse in irssi
# (use the awl-patched mouse.pl for gestures and commands if you need
# them and disable mouse_escape)
#
# /set awl_mouse_offset <num>
# * specifies where on the screen is the awl status bar
#   (0 = on top/bottom, 1 = one additional line in between,
#   e.g. prompt)
#   you MUST set this correctly otherwise the mouse coordinates will
#   be off
#
# /set mouse_scroll <num>
# * how many lines the mouse wheel scrolls
#
# /set mouse_escape <num>
# * seconds to disable the mouse, when not clicked on the windowlist
#

# Commands
# ========
# /awl redraw
# * redraws the windowlist. There may be occasions where the
#   windowlist can get destroyed so you can use this command to
#   force a redraw.
#
# /awl restart
# * restart the connection to the viewer script.

# Viewer script
# =============
# When run from the command line, adv_windowlist acts as the viewer
# script to be used together with the irssi script to display the
# window list in a sidebar/terminal of its own.
#
# One optional parameter is accepted, the awl_path
#
# The viewer can be configured by three environment variables:
#
# AWL_HI9=1
# * interpret %9 as high-intensity toggle instead of bold. This had
#   been the default prior to version 0.9b8
#
# AWL_AUTOFOCUS=0
# * disable auto-focus behaviour when activating a window
#
# AWL_NOTITLE=1
# * disable the title bar

# Nei =^.^= ( anti@conference.jabber.teamidiot.de )

no warnings 'redefine';
use constant IN_IRSSI => __PACKAGE__ ne 'main' || $ENV{IRSSI_MOCK};
use constant SCRIPT_FILE => __FILE__;
no if !IN_IRSSI, strict => (qw(subs refs));
use if IN_IRSSI, Irssi => ();
use if IN_IRSSI, 'Irssi::TextUI' => ();
use v5.10;
use Encode;
use Storable ();
use IO::Socket::UNIX;
use List::Util qw(min max reduce);
use Hash::Util qw(lock_keys);
use Text::ParseWords qw(shellwords);

BEGIN {
    if ($] < 5.012) {
	*CORE::GLOBAL::length = *CORE::GLOBAL::length = sub (_) {
	    defined $_[0] ? CORE::length($_[0]) : undef
	};
	*Irssi::active_win = {}; # hide incorrect warning
    }
}

unless (IN_IRSSI) {
    local *_ = \@ARGV;
    &AwlViewer::main;
    exit;
}


use constant GLOB_QUEUE_TIMER => 100;

our $BLOCK_ALL;  # localized blocker
my @actString;   # status bar texts
my @win_items;
my $currentLines = 0;
my %awins;
my $globTime;    # timer to limit remake calls

my %CHANGED;
my $VIEWER_MODE;
my $MOUSE_ON;
my %mouse_coords;
my %statusbars;
my %S; # settings
my $settings_str = '';
my $window_sort_func;
my $custom_xform;
my ($sb_base_width, $sb_base_width_pre, $sb_base_width_post);
my $print_text_activity;
my $shade_line_timer;
my ($screenHeight, $screenWidth);
my %viewer;

my (%keymap, %nummap, %wnmap, %specialmap, %wnmap_exp, %custom_key_map);
my %banned_channels;
my %abbrev_cache;

use constant setc => 'awl';

sub set ($) {
    setc . '_' . $_[0]
}

sub add_statusbar {
    for (@_) {
	# add subs
	my $l = set $_;
	{
	    my $close = $_;
	    no strict 'refs';
	    *{$l} = sub { awl($close, @_) };
	}
	Irssi::command("statusbar $l reset");
	Irssi::command("statusbar $l enable");
	if (lc $S{placement} eq 'top') {
	    Irssi::command("statusbar $l placement top");
	}
	if (my $x = $S{position}) {
	    Irssi::command("statusbar $l position $x");
	}
	Irssi::command("statusbar $l add -priority 100 -alignment left barstart");
	Irssi::command("statusbar $l add $l");
	Irssi::command("statusbar $l add -priority 100 -alignment right barend");
	Irssi::command("statusbar $l disable");
	Irssi::statusbar_item_register($l, '$0', $l);
	$statusbars{$_} = 1;
	Irssi::command("statusbar $l enable");
    }
}

sub remove_statusbar {
    for (@_) {
	my $l = set $_;
	Irssi::command("statusbar $l disable");
	Irssi::command("statusbar $l reset");
	Irssi::statusbar_item_unregister($l);
	{
	    no strict 'refs';
	    undef &{$l};
	}
	delete $statusbars{$_};
    }
}

my $awl_shared_empty = sub {
    return if $BLOCK_ALL;
    my ($item, $get_size_only) = @_;
    $item->default_handler($get_size_only, '', '', 0);
};

sub syncLines {
    my $maxLines = $S{maxlines};
    my $newLines = ($maxLines > 0 and @actString > $maxLines) ?
	$maxLines :
    ($maxLines < 0) ?
	-$maxLines :
	    @actString;
    $currentLines = 1 if !$currentLines && $S{shared_sbar};
    if ($S{shared_sbar} && !$statusbars{shared}) {
	my $l = set 'shared';
	{
	    no strict 'refs';
	    *{$l} = sub {
		return if $BLOCK_ALL;
		my ($item, $get_size_only) = @_;

		my $text = $actString[0];
		my $pat = defined $text ? '{sb '.ucfirst(setc()).': $*}' : '{sb }';
		$text //= '';
		$item->default_handler($get_size_only, $pat, $text, 0);
	    };
	}
	$statusbars{shared} = 1;
	remove_statusbar (0) if $statusbars{0};
    }
    elsif ($statusbars{shared} && !$S{shared_sbar}) {
	add_statusbar (0) if $currentLines && $newLines;
	delete $statusbars{shared};
	my $l = set 'shared';
	{
	    no strict 'refs';
	    *{$l} = $awl_shared_empty;
	}
    }
    if ($currentLines == $newLines) { return; }
    elsif ($newLines > $currentLines) {
	add_statusbar ($currentLines .. ($newLines - 1));
    }
    else {
	remove_statusbar (reverse ($newLines .. ($currentLines - 1)));
    }
    $currentLines = $newLines;
}

sub awl {
    return if $BLOCK_ALL;
    my ($line, $item, $get_size_only) = @_;

    my $text = $actString[$line];
    my $pat = defined $text ? '{sb $*}' : '{sb }';
    $text //= '';
    $item->default_handler($get_size_only, $pat, $text, 0);
}

# remove old statusbars
{ my %killBar;
  sub get_old_status {
      my ($textDest, $cont, $cont_stripped) = @_;
      if ($textDest->{level} == 524288 and $textDest->{target} eq '' and !defined $textDest->{server}) {
	  my $name = quotemeta(set '');
	  if ($cont_stripped =~ m/^$name(\d+)\s/) { $killBar{$1} = 1; }
	  Irssi::signal_stop;
      }
  }
  sub killOldStatus {
      %killBar = ();
      Irssi::signal_add_first('print text' => 'get_old_status');
      Irssi::command('statusbar');
      Irssi::signal_remove('print text' => 'get_old_status');
      remove_statusbar(keys %killBar);
  }
}

sub get_keymap {
    my ($textDest, undef, $cont_stripped) = @_;
    if ($textDest->{level} == 524288 and $textDest->{target} eq '' and !defined $textDest->{server}) {
	my $one_meta_or_ctrl_key = qr/((?:meta-)*?)(?:(meta-|\^)(\S)|(\w+))/;
	$cont_stripped = as_uni($cont_stripped);
	if ($cont_stripped =~ m/((?:$one_meta_or_ctrl_key-)*$one_meta_or_ctrl_key)\s+(.*)$/) {
	    my ($combo, $command) = ($1, $10);
	    my $map = '';
	    while ($combo =~ s/(?:-|^)$one_meta_or_ctrl_key$//) {
		my ($level, $ctl, $key, $nkey) = ($1, $2, $3, $4);
		my $numlevel = ($level =~ y/-//);
		$ctl = '' if !$ctl || $ctl ne '^';
		$map = ('-' x ($numlevel%2)) . ('+' x ($numlevel/2)) .
		    $ctl . (defined $key ? $key : "\01$nkey\01") . $map;
	    }
	    for ($command) {
		last unless length $map;
		if (/^change_window (\d+)/i) {
		    $nummap{$1} = $map;
		}
		elsif (/^command window goto (\S+)/i) {
		    my $window = $1;
		    if ($window !~ /\D/) {
			$nummap{$window} = $map;
		    }
		    elsif (lc $window eq 'active') {
			$specialmap{_active} = $map;
		    }
		    else {
			$wnmap{$window} = $map;
		    }
		}
		elsif (/^(?:active_window|command (ack))/i) {
		    $specialmap{_active} = $map;
		    $viewer{use_ack} = !!$1;
		}
		elsif (/^command window last/i) {
		    $specialmap{_last} = $map;
		}
		elsif (/^(?:upper_window|command window up)/i) {
		    $specialmap{_up} = $map;
		}
		elsif (/^(?:lower_window|command window down)/i) {
		    $specialmap{_down} = $map;
		}
		elsif (/^key\s+(\w+)/i) {
		    $custom_key_map{$1} = $map;
		}
	    }
	}
	Irssi::signal_stop;
    }
}

sub update_keymap {
    %nummap = %wnmap = %specialmap = %custom_key_map = ();
    Irssi::signal_remove('command bind' => 'watch_keymap');
    Irssi::signal_add_first('print text' => 'get_keymap');
    Irssi::command('bind');
    Irssi::signal_remove('print text' => 'get_keymap');
    for (keys %custom_key_map) {
	if (exists $custom_key_map{$_} &&
		$custom_key_map{$_} =~ s/\01(\w+)\01/exists $custom_key_map{$1} ? $custom_key_map{$1} : "\02"/ge) {
	    if ($custom_key_map{$_} =~ /\02/) {
		delete $custom_key_map{$_};
	    }
	    else {
		redo;
	    }
	}
    }
    for my $keymap (\(%specialmap, %wnmap, %nummap)) {
	for (keys %$keymap) {
	    if ($keymap->{$_} =~ s/\01(\w+)\01/exists $custom_key_map{$1} ? $custom_key_map{$1} : "\02"/ge) {
		if ($keymap->{$_} =~ /\02/) {
		    delete $keymap->{$_};
		}
	    }
	}
    }
    Irssi::signal_add('command bind' => 'watch_keymap');
    delete $viewer{client_keymap};
    &wl_changed;
}

# watch keymap changes
sub watch_keymap {
    Irssi::timeout_add_once(1000, 'update_keymap', undef);
}

{ my %strip_table = (
    # fe-common::core::formats.c:format_expand_styles
    #      delete                format_backs  format_fores bold_fores   other stuff
    (map { $_ => '' } (split //, '04261537' .  'kbgcrmyw' . 'KBGCRMYW' . 'U9_8I:|FnN>#[' . 'pP')),
    #      escape
    (map { $_ => $_ } (split //, '{}%')),
   );
  sub ir_strip_codes { # strip %codes
      my $o = shift;
      $o =~ s/(%(%|Z.{6}|z.{6}|X..|x..|.))/exists $strip_table{$2} ? $strip_table{$2} :
	  $2 =~ m{x(?:0[a-f]|[1-6][0-9a-z]|7[a-x])|z[0-9a-f]{6}}i ? '' : $1/gex;
      $o
  }
}
## ir_parse_special -- wrapper around parse_special
## $i - input format
## $args - array ref of arguments to format
## $win - different target window (default current window)
## $flags - different kind of escape flags (default 4|8)
## returns formatted str
sub ir_parse_special {
    my $o;
    my $i = shift;
    my $args = shift // [];
    y/ /\177/ for @$args; # hack to escape spaces
    my $win = shift || Irssi::active_win;
    my $flags = shift // 0x4|0x8;
    my @cmd_args = ($i, (join ' ', @$args), $flags);
    my $server = Irssi::active_server();
    if (ref $win and ref $win->{active}) {
	$o = $win->{active}->parse_special(@cmd_args);
    }
    elsif (ref $win and ref $win->{active_server}) {
	$o = $win->{active_server}->parse_special(@cmd_args);
    }
    elsif (ref $server) {
	$o =  $server->parse_special(@cmd_args);
    }
    else {
	$o = &Irssi::parse_special(@cmd_args);
    }
    $o =~ y/\177/ /;
    $o
}

sub sb_format_expand { # Irssi::current_theme->format_expand wrapper
    Irssi::current_theme->format_expand(
	$_[0],
	(
	    Irssi::EXPAND_FLAG_IGNORE_REPLACES
		    |
	    ($_[1] ? 0 : Irssi::EXPAND_FLAG_IGNORE_EMPTY)
	)
    )
}

{ my $term_type = Irssi::version > 20040819 ? 'term_charset' : 'term_type';
  local $@;
  eval { require Text::CharWidth; };
  unless ($@) {
      *screen_length = sub { Text::CharWidth::mbswidth($_[0]) };
  }
  else {
      my $err = $@; chomp $err; $err =~ s/\sat .* line \d+\.$//;
      #Irssi::print("%_$IRSSI{name}: warning:%_ Text::CharWidth module failed to load. Length calculation may be off! Error was:");
      print "%_$IRSSI{name}:%_ $err";
      *screen_length = sub {
	  my $temp = shift;
	  if (lc Irssi::settings_get_str($term_type) eq 'utf-8') {
	      Encode::_utf8_on($temp);
	  }
	  length($temp)
      };
  }
  sub as_uni {
      no warnings 'utf8';
      Encode::decode(Irssi::settings_get_str($term_type), $_[0], 0)
  }
  sub as_tc {
      Encode::encode(Irssi::settings_get_str($term_type), $_[0], 0)
  }
}

sub sb_length {
    screen_length(ir_strip_codes($_[0]))
}

sub run_custom_xform {
    local $@;
    eval {
	$custom_xform->()
    };
    if ($@) {
	$@ =~ /^(.*)/;
	print '%_'.(set 'custom_xform').'%_ died (disabling): '.$1;
	$custom_xform = undef;
    }
}

sub remove_uniform {
    my $o = shift;
    $o =~ s/^xmpp:(.*?[%@]).+\.[^.]+$/$1/ or
	$o =~ s#^psyc://.+\.[^.]+/([@~].*)$#$1#;
    if ($custom_xform) {
	run_custom_xform() for $o;
    }
    $o
}

sub remove_uniform_vars {
    my $win = shift;
    my $name = __PACKAGE__ . '::custom_xform::' . $win->{active}{type}
	if ref $win->{active} && $win->{active}{type};
    no strict 'refs';
    local ${$name} = 1 if $name;
    remove_uniform(+shift);
}

sub lc1459 {
    my $x = shift;
    $x =~ y/][\\^/}{|~/;
    lc $x
}

sub window_list {
    sort $window_sort_func Irssi::windows;
}

sub _calculate_abbrev {
    my ($wins, $abbrevList) = @_;
    if ($S{fancy_abbrev} !~ /^(no|off|head)/i) {
	my @nameList = map { ref $_ ? remove_uniform_vars($_, as_uni($_->get_active_name) // '') : '' } @$wins;
	for (my $i = 0; $i < @nameList - 1; ++$i) {
	    my ($x, $y) = ($nameList[$i], $nameList[$i + 1]);
	    s/^[+#!=]// for $x, $y;
	    my $res = exists $abbrev_cache{$x}{$y} ? $abbrev_cache{$x}{$y}
		: $abbrev_cache{$x}{$y} = string_LCSS($x, $y);
	    if (defined $res) {
		for ($nameList[$i], $nameList[$i + 1]) {
		    $abbrevList->{$_} //= int((index $_, $res) + (length $res) / 2);
		}
	    }
	}
    }
}

my %act_last_line_shades = (
    r => [qw[ 50 40 30 20 ]],
    g => [qw[ 1O 1I 1C 16 ]],
    y => [qw[ 5O 4I 3C 26 ]],
    b => [qw[ 15 14 13 12 ]],
    m => [qw[ 54 43 32 21 ]],
    c => [qw[ 1S 1L 1E 17 ]],
    w => [qw[ 7W 7T 7Q 3E ]],
    K => [qw[ 7M 7K 27 7H ]],
    R => [qw[ 60 50 40 30 ]],
    G => [qw[ 1U 1O 1I 1C ]],
    Y => [qw[ 6U 5O 4I 3C ]],
    B => [qw[ 2B 2A 29 28 ]],
    M => [qw[ 65 54 43 32 ]],
    C => [qw[ 1Z 1S 1L 1E ]],
    W => [qw[ 6Z 5S 7R 7O ]],
   );

sub _format_display {
    my (undef, $format, $cformat, $hilight, $name, $number, $key, $win) = @_;
    if ($print_text_activity && $S{line_shade}) {
	my @hilight_code = split /\177/, sb_format_expand("{$hilight \177}"), 2;
	my $max_time = max(1, log($S{line_shade}) - log(1000));
	my $time_delta = min(3, min($max_time, log(max(1, time - $win->{last_line}))) / $max_time * 3);
	if ($hilight_code[0] =~ /%(.)/ && exists $act_last_line_shades{$1}) {
	    $hilight = 'sb_act_hilight_color %X'.$act_last_line_shades{$1}[$time_delta];
	}
    }
    $cformat = '$0' unless length $cformat;
    my %map = ('$C' => $cformat, '$N' => '$1', '$Q' => '$2');
    $format =~ s<(\$.)><$map{$1}//$1>ge;
    $format =~ s<\$H((?:\$.|[^\$])*?)\$S><{$hilight $1%n}>g;
    my @ret = ir_parse_special(sb_format_expand($format), [$name, $number, $key], $win);
    @ret
}

sub _calculate_items {
    my ($wins, $abbrevList) = @_;

    my $display_header = Irssi::current_theme->get_format(__PACKAGE__, set 'display_header');
    my $name_format = Irssi::current_theme->get_format(__PACKAGE__, set 'name_display');
    my %displays;

    my $active = Irssi::active_win;
    @win_items = ();
    %keymap = (%nummap, %wnmap_exp);

    my ($numPad, $keyPad) = (0, 0);
    if ($VIEWER_MODE or $S{block} < 0) {
	$numPad = length((sort { length $b <=> length $a } keys %keymap)[0]) // 0;
	$keyPad = length((sort { length $b <=> length $a } values %keymap)[0]) // 0;
    }
    my $last_net;
    for my $win (@$wins) {
	my $global_hack_alert_tag_header;

	next unless ref $win;

	my $backup_win = Storable::dclone($win);
	delete $backup_win->{active} unless ref $backup_win->{active};

	$global_hack_alert_tag_header =
	    $display_header && ($last_net // '') ne ($backup_win->{active}{server}{tag} // '');

	if ($win->{data_level} < abs $S{hide_data}
		&& ($win->{refnum} != $active->{refnum} || 0 <= $S{hide_data})) {
	    next; }
	elsif (exists $awins{$win->{refnum}} && $S{hide_empty} && !$win->items
		&& ($win->{refnum} != $active->{refnum} || 0 <= $S{hide_empty})) {
	    next; }

	my $colour = $win->{hilight_color} // '';
	my $hilight = do {
	    if    ($win->{data_level} == 0) { 'sb_act_none'; }
	    elsif ($win->{data_level} == 1) { 'sb_act_text'; }
	    elsif ($win->{data_level} == 2) { 'sb_act_msg'; }
	    elsif ($colour           ne '') { "sb_act_hilight_color $colour"; }
	    elsif ($win->{data_level} == 3) { 'sb_act_hilight'; }
	    else                            { 'sb_act_special'; }
	};
	my $number = $win->{refnum};

	my ($name, $display, $cdisplay);
	if ($global_hack_alert_tag_header) {
	    $display = $display_header;
	    $name = as_uni($backup_win->{active}{server}{tag}) // '';
	    if ($custom_xform) {
		no strict 'refs';
		local ${ __PACKAGE__ . '::custom_xform::TAG' } = 1;
		run_custom_xform() for $name;
	    }
	}
	else {
	    my @display = ('display_nokey');
	    if (defined $keymap{$number} and $keymap{$number} ne '') {
		unshift @display, map { (my $cpy = $_) =~ s/_no/_/; $cpy } @display;
	    }
	    if (exists $awins{$number}) {
		unshift @display, map { my $cpy = $_; $cpy .= '_visible'; $cpy } @display;
	    }
	    if ($active->{refnum} == $number) {
		unshift @display, map { my $cpy = $_; $cpy .= '_active'; $cpy }
		    grep { !/_visible$/ } @display;
	    }
	    $display = (grep { length $_ }
			       map { $displays{$_} //= Irssi::current_theme->get_format(__PACKAGE__, set $_) }
				   @display)[0];
	    $cdisplay = $name_format;
	    $name = as_uni($win->get_active_name) // '';
	    $name = '*' if $S{banned_on} and exists $banned_channels{lc1459($name)};
	    $name = remove_uniform_vars($win, $name) if $name ne '*';
	    if ($name ne '*' and $win->{name} ne '' and $S{prefer_name}) {
		$name = as_uni($win->{name});
		if ($custom_xform) {
		    no strict 'refs';
		    local ${ __PACKAGE__ . '::custom_xform::NAME' } = 1;
		    run_custom_xform() for $name;
		}
	    }

	    if (!$VIEWER_MODE && $S{block} >= 0 && $S{hide_name}
		&& $win->{data_level} < abs $S{hide_name}
		&& ($win->{refnum} != $active->{refnum} || 0 <= $S{hide_name})) {
		$name = '';
		$cdisplay = '';
	    }
	}

	$display = "$display%n";
	my $num_ent = (' 'x max(0,$numPad - length $number)) . $number;
	my $key_ent = exists $keymap{$number} ? ((' 'x max(0,$keyPad - length $keymap{$number})) . $keymap{$number}) : ' 'x$keyPad;
	if ($VIEWER_MODE or $S{sbar_maxlen} or $S{block} < 0) {
	    my $baseLength = sb_length(_format_display(
		'', $display, $cdisplay, $hilight,
		'x', # placeholder
		$num_ent,
		$key_ent,
		$win)) - 1;
	    my $diff = (abs $S{block}) - (screen_length(as_tc($name)) + $baseLength);
	    if ($diff < 0) { # too long
		my $screen_length = screen_length(as_tc($name));
		if ((abs $diff) >= $screen_length) { $name = '' } # forget it
		elsif ((abs $diff) + screen_length(as_tc(substr($name, 0, 1))) >= $screen_length) { $name = substr($name, 0, 1); }
		else {
		    my $ulen = length $name;
		    my $middle2 = exists $abbrevList->{$name} ?
			($S{fancy_strict}) ?
			    2* $abbrevList->{$name} :
			   (2*($abbrevList->{$name} + $ulen) / 3) :
			       ($S{fancy_head}) ?
				2*$ulen :
				    $ulen;
		    my $first = 1;
		    while (length $name > 1) {
			my $cp = $middle2 >= 0 ? $middle2/2 : -1; # clearing position
			my $rm = 2;
			# if character at end is wider than 1 cell -> replace it with ~
			if (screen_length(as_tc(substr $name, $cp, 1)) > 1) {
			    if ($first || $cp < 0) {
				$rm = 1;
				$first = undef;
			    }
			}
			elsif ($cp < 0) { # elsif at end -> replace last 2 characters
			    --$cp;
			}
			(substr $name, $cp, $rm) = '~';
			if ($cp > -1 && $rm > 1) {
			    --$middle2;
			}
			my $sl = screen_length(as_tc($name));
			if ($sl + $baseLength < abs $S{block}) {
			    (substr $name, ($middle2+1)/2, 1) = "\x{301c}";
			    last;
			}
			elsif ($sl + $baseLength == abs $S{block}) {
			    last;
			}
		    }
		}
	    }
	    elsif ($VIEWER_MODE or $S{block} < 0) {
		$name .= (' ' x $diff);
	    }
	}

	push @win_items, _format_display(
	    '', $display, $cdisplay, $hilight,
	    as_tc($name),
	    $num_ent,
	    as_tc($key_ent),
	    $win);

	if ($global_hack_alert_tag_header) {
	    $last_net = $backup_win->{active}{server}{tag};
	    redo;
	}

	$mouse_coords{refnum}{$#win_items} = $number;
    }
}

sub _spread_items {
    my $width = [Irssi::windows]->[0]{width} - $sb_base_width - 1;
    my @separator = Irssi::current_theme->get_format(__PACKAGE__, set 'separator');
    if ($S{block} >= 0) {
	my $sep2 = Irssi::current_theme->get_format(__PACKAGE__, set 'separator2');
	push @separator, $sep2 if length $sep2 && $sep2 ne $separator[0];
    }
    $separator[0] .= '%n';
    my @sepLen = map { sb_length($_) } @separator;

    @actString = ();
    my $curLine;
    my $curLen = 0;
    if ($S{shared_sbar}) {
	$curLen += $S{shared_sbar}[0] + 2 + length setc();
	$width -= $S{shared_sbar}[2];
    }
    my $mouse_header_check = 0;
    for my $it (@win_items) {
	my $itemLen = sb_length($it);
	if ($curLen) {
	    if ($curLen + $itemLen + $sepLen[$mouse_header_check % @sepLen] > $width) {
		$width += $S{shared_sbar}[2]
		    if !@actString && $S{shared_sbar};
		push @actString, $curLine;
		$curLine = undef;
		$curLen = 0;
	    }
	    elsif (defined $curLine) {
		$curLine .= $separator[$mouse_header_check % @separator];
		$curLen += $sepLen[$mouse_header_check % @sepLen];
	    }
	}
	$curLine .= $it;
	if (exists $mouse_coords{refnum}{$mouse_header_check}) {
	    $mouse_coords{scalar @actString}{ $_ } = $mouse_coords{refnum}{$mouse_header_check}
		for $curLen .. $curLen + $itemLen - 1;
	}
	$curLen += $itemLen;
    }
    continue {
	++$mouse_header_check;
    }
    $curLen -= $S{shared_sbar}[0]
	if !@actString && $S{shared_sbar};
    push @actString, $curLine if $curLen;
}

sub remake {
    my %abbrevList;
    my @wins = window_list();
    if ($VIEWER_MODE or $S{sbar_maxlen} or $S{block} < 0) {
	_calculate_abbrev(\@wins, \%abbrevList);
    }

    %mouse_coords = ( refnum => +{} );
    _calculate_items(\@wins, \%abbrevList);

    unless ($VIEWER_MODE) {
	_spread_items();

	push @actString, undef unless @actString || $S{all_disable};
    }
}

sub update_wl {
    return if $BLOCK_ALL;
    remake();

    Irssi::statusbar_items_redraw(set $_) for keys %statusbars;

    unless ($VIEWER_MODE) {
	Irssi::timeout_add_once(100, 'syncLines', undef);
    }
    else {
	syncViewer();
    }
}

sub screenFullRedraw {
    my ($window) = @_;
    if (!ref $window or $window->{refnum} == Irssi::active_win->{refnum}) {
	$viewer{fullRedraw} = 1 if $viewer{client};
	$settings_str = '';
	&setup_changed;
    }
}

sub restartViewerServer {
    if ($VIEWER_MODE) {
	stop_viewer();
	start_viewer();
    }
}

sub _simple_quote {
    my @r = map {
	my $x = $_;
	$x =~ s/'/'"'"'/g;
	$x = "'$x'";
    } @_;
    wantarray ? @r : shift @r
}

sub _viewer_command_replace_format {
    my ($ecmd, @args) = @_;
    my $file = _simple_quote(SCRIPT_FILE());
    my $path = _simple_quote($viewer{path});
    my @env;
    for my $env (shellwords($S{viewer_launch_env})) {
	if ($env =~ /^(\w+)(?:=(.*))$/) {
	    push @env, "AWL_$1=$2"
	}
    }
    my $cmd = join ' ',
	(@env ? ('env', _simple_quote(@env)) : ()),
	'perl', $file, '-1', _simple_quote(@args), $path;
    $ecmd =~ s{%(%|\w+)}{
	my $sub = $1;
	if ($sub eq '%') {
	    '%'
	}
	elsif ($sub =~ /^(q*)A(.*)/) {
	    my $ret = $cmd;
	    for (1..length $1) {
		$ret = _simple_quote($ret);
	    }
	    "$ret$2"
	}
	else {
	    "%$sub"
	}
    }gex;
    $ecmd
}

sub start_viewer {
    unlink $viewer{path} if -S $viewer{path} || -p _;

    $viewer{server} = IO::Socket::UNIX->new(
	Type => SOCK_STREAM,
	Local => $viewer{path},
	Listen => 1
       );
    unless ($viewer{server}) {
	$viewer{msg} = "Viewer: $!";
	$viewer{retry} = Irssi::timeout_add_once(5000, 'retry_viewer', 1);
	return;
    }
    $viewer{server}->blocking(0);
    set_viewer_mode_hint();
    $viewer{server_tag} = Irssi::input_add($viewer{server}->fileno, INPUT_READ, 'vi_connected', undef);

    if ($S{viewer_launch}) {
	if (length $ENV{TMUX_PANE} && length $ENV{TMUX} && lc $S{viewer_tmux_position} ne 'custom') {
	    my $cmd = _viewer_command_replace_format('%qA', '-p', lc $S{viewer_tmux_position});
	    Irssi::command("exec - tmux neww -d $cmd 2>&1 &");
	}
	elsif (length $ENV{WINDOWID} && length $ENV{DISPLAY} && length $S{viewer_xwin_command} && $S{viewer_xwin_command} =~ /\S/) {
	    my $cmd = _viewer_command_replace_format($S{viewer_xwin_command});
	    Irssi::command("exec - $cmd 2>&1 &");
	}
	elsif (length $S{viewer_custom_command} && $S{viewer_custom_command} =~ /\S/) {
	    my $cmd = _viewer_command_replace_format($S{viewer_custom_command});
	    Irssi::command("exec - $cmd 2>&1 &");
	}
    }
}

sub set_viewer_mode_hint {
    return unless $viewer{server};
    if ($S{no_mode_hint}) {
	$viewer{msg} = undef;
    }
    else {
	my ($name) = __PACKAGE__ =~ /::([^:]+)$/;
	$viewer{msg} = "Run $name from the shell or switch to sbar mode";
    }
}

sub retry_viewer {
    start_viewer();
}

sub vi_close_client {
    Irssi::input_remove(delete $viewer{client_tag}) if exists $viewer{client_tag};
    $viewer{client}->close if $viewer{client};
    delete $viewer{client};
    delete $viewer{client_keymap};
    delete $viewer{client_settings};
    delete $viewer{client_env};
    delete $viewer{fullRedraw};
}

sub vi_connected {
    vi_close_client();
    $viewer{client} = $viewer{server}->accept or return;
    $viewer{client}->blocking(0);
    $viewer{client_tag} = Irssi::input_add($viewer{client}->fileno, INPUT_READ, 'vi_clientinput', undef);
    syncViewer();
}

use constant VIEWER_BLOCK_SIZE => 1024;
sub vi_clientinput {
    if ($viewer{client}->read(my $buf, VIEWER_BLOCK_SIZE)) {
	$viewer{rcvbuf} .= $buf;
	if ($viewer{rcvbuf} =~ s/^(?:(active|\d+)|(last|up|down))\n//igm) {
	    if (defined $2) {
		Irssi::command("window $2");
	    }
	    elsif (lc $1 eq 'active' && $viewer{use_ack}) {
		Irssi::command("ack");
	    }
	    else {
		Irssi::command("window goto $1");
	    }
	}
    }
    else {
	vi_close_client();
	Irssi::timeout_add_once(100, 'syncViewer', undef);
    }
}

sub stop_viewer {
    Irssi::timeout_remove(delete $viewer{retry}) if exists $viewer{retry};
    vi_close_client();
    Irssi::input_remove(delete $viewer{server_tag}) if exists $viewer{server_tag};
    return unless $viewer{server};
    $viewer{server}->close;
    delete $viewer{server};
}
sub _encode_var {
    my $str;
    while (@_) {
	my ($name, $var) = splice @_, 0, 2;
	my $type = ref $var ? $var =~ /HASH/ ? 'map' : $var =~ /ARRAY/ ? 'list' : '' : '';
	$str .= "\n\U$name$type\_begin\n";
	if ($type eq 'map') {
	    no warnings 'numeric';
	    $str .= " $_\n ${$var}{$_}\n" for sort { $a <=> $b || $a cmp $b } keys %$var;
	}
	elsif ($type eq 'list') {
	    $str .= " $_\n" for @$var;
	}
	else {
	    $str .= " $var\n";
	}
	$str .= "\U$name$type\_end\n";
    }
    $str
}
sub syncViewer {
    if ($viewer{client}) {
	@actString = ();
	if ($currentLines) {
	    killOldStatus();
	    $currentLines = 0;
	}
	my $str;
	unless ($viewer{client_keymap}) {
	    $str .= _encode_var('key', +{ %nummap, %specialmap });
	    $viewer{client_keymap} = 1;
	}
	unless ($viewer{client_settings}) {
	    $str .= _encode_var(
		block => $S{block},
		ha => $S{height_adjust},
		mc => $S{maxcolumns},
		ml => $S{maxlines},
	       );
	    $viewer{client_settings} = 1;
	}
	unless ($viewer{client_env}) {
	    $str .= _encode_var(irssienv => +{
		length $ENV{TMUX_PANE} && length $ENV{TMUX} ?
		     (tmux_pane => $ENV{TMUX_PANE},
		      tmux_srv => $ENV{TMUX}) : (),
		length $ENV{WINDOWID} ?
		     (xwinid => $ENV{WINDOWID}) : (),
	       });
	    $viewer{client_env} = 1;
	}
	my $separator = Irssi::current_theme->get_format(__PACKAGE__, set 'separator');
	my $sepLen = sb_length($separator);
	my $item_bg = Irssi::current_theme->get_format(__PACKAGE__, set 'viewer_item_bg');
	$str .= _encode_var(redraw => 1) if delete $viewer{fullRedraw};
	$str .= _encode_var(separator => $separator,
			    seplen => $sepLen,
			    itembg => $item_bg,
			    mouse => $mouse_coords{refnum},
			    key2 => \%wnmap_exp,
			    win => \@win_items);

	my $was = $viewer{client}->blocking(1);
	$viewer{client}->print($str);
	$viewer{client}->blocking($was);
    }
    elsif ($viewer{server}) {
	if (defined $viewer{msg}) {
	    @actString = ((uc setc()).": $viewer{msg}");
	}
	else {
	    @actString = ();
	}
    }
    elsif (defined $viewer{msg}) {
	@actString = ((uc setc()).": $viewer{msg}");
    }
    if (@actString) {
	Irssi::timeout_add_once(100, 'syncLines', undef);
    }
    elsif ($currentLines) {
	killOldStatus();
	$currentLines = 0;
    }
}

sub reset_awl {
    Irssi::timeout_remove($shade_line_timer) if $shade_line_timer; $shade_line_timer = undef;
    my $was_sort = $S{sort} // '';
    my $was_xform = $S{xform} // '';
    my $was_shared = $S{shared_sbar};
    my $was_no_hint = $S{no_mode_hint};
    %S = (
	sort	      => Irssi::settings_get_str( set 'sort'),
	fancy_abbrev  => Irssi::settings_get_str('fancy_abbrev'),
	xform	      => Irssi::settings_get_str( set 'custom_xform'),
	block	      => Irssi::settings_get_int( set 'block'),
	banned_on     => Irssi::settings_get_bool('banned_channels_on'),
	prefer_name   => Irssi::settings_get_bool(set 'prefer_name'),
	hide_data     => Irssi::settings_get_int( set 'hide_data'),
	hide_name     => Irssi::settings_get_int( set 'hide_name_data'),
	hide_empty    => Irssi::settings_get_int( set 'hide_empty'),
	sbar_maxlen   => Irssi::settings_get_bool(set 'sbar_maxlength'),
	placement     => Irssi::settings_get_str( set 'placement'),
	position      => Irssi::settings_get_int( set 'position'),
	maxlines      => Irssi::settings_get_int( set 'maxlines'),
	maxcolumns    => Irssi::settings_get_int( set 'maxcolumns'),
	all_disable   => Irssi::settings_get_bool(set 'all_disable'),
	height_adjust => Irssi::settings_get_int( set 'height_adjust'),
	mouse_offset  => Irssi::settings_get_int( set 'mouse_offset'),
	mouse_scroll  => Irssi::settings_get_int( 'mouse_scroll'),
	mouse_escape  => Irssi::settings_get_int( 'mouse_escape'),
	line_shade    => Irssi::settings_get_time(set 'last_line_shade'),
	no_mode_hint  => Irssi::settings_get_bool(set 'no_mode_hint'),
	viewer_launch	      => Irssi::settings_get_bool(set 'viewer_launch'),
	viewer_launch_env     => Irssi::settings_get_str(set 'viewer_launch_env'),
	viewer_xwin_command   => Irssi::settings_get_str(set 'viewer_xwin_command'),
	viewer_custom_command => Irssi::settings_get_str(set 'viewer_custom_command'),
	viewer_tmux_position  => Irssi::settings_get_str(set 'viewer_tmux_position'),
	);
    $S{fancy_strict} = $S{fancy_abbrev} =~ /^strict/i;
    $S{fancy_head} = $S{fancy_abbrev} =~ /^head/i;
    my $shared = Irssi::settings_get_str(set 'shared_sbar');
    if ($shared =~ /^(\d+)([<])(\d+)$/) {
	$S{shared_sbar} = [$1, $2, $3];
    }
    else {
	Irssi::settings_set_str(set 'shared_sbar', 'OFF');
	$S{shared_sbar} = undef;
    }
    lock_keys(%S);
    if ($was_sort ne $S{sort}) {
	$print_text_activity = undef;
	my @sort_order = grep { @$_ > 4 } map {
	    s/^\s*//;
	    my $reverse = s/^\W*\K[-!]//;
	    my $undef_check = s/^\W*\K~// ? 1 : undef;
	    my $equal_check = s/=(.*)\s?$// ? $1 : undef;
	    s/\s*$//;
	    my $ignore_case = s/#i$// ? 1 : undef;

	    $print_text_activity = 1 if $_ eq 'last_line';

	    my @path = split '/';
	    my $class_check = @path && $path[-1] =~ s/(::.*)$// ? $1 : undef;

	    [ $reverse ? -1 : 1, $undef_check, $equal_check, $class_check, $ignore_case, @path ]
	} "$S{sort}," =~ /([^+,]*|[^+,]*=[^,]*?\s(?=\+)|[^+,]*=[^,]*)[+,]/g;
	$window_sort_func = sub {
	    no warnings qw(numeric uninitialized);
	    for my $so (@sort_order) {
		my @x = map {
		    my $ret = 0;
		    $_ = lc1459($_) if defined $_ && !ref $_ && $so->[4];
		    $ret = $_ eq ($so->[4] ? lc1459($so->[2]) : $so->[2]) ? 1 : -1 if defined $so->[2];
		    $ret = defined $_ ? ($ret || -3) : 3 if $so->[1];
		    $ret = ref $_ && $_->isa('Irssi'.$so->[3]) ? 2 : ($ret || -2) if $so->[3];
		    -$ret || $_
		}
		map {
		    reduce { return unless ref $a; $a->{$b} } $_, @{$so}[5..$#$so]
		} $a, $b;
		return ((($x[0] <=> $x[1] || $x[0] cmp $x[1]) * $so->[0]) || next);
	    }
	    return ($a->{refnum} <=> $b->{refnum});
	};
    }
    if ($was_xform ne $S{xform}) {
	if ($S{xform} !~ /\S/) {
	    $custom_xform = undef;
	}
	else {
	    my $script_pkg = __PACKAGE__ . '::custom_xform';
	    local $@;
	    $custom_xform = eval qq{
package $script_pkg;
use strict;
no warnings;
our (\$QUERY, \$CHANNEL, \$TAG, \$NAME);
return sub {
# line 1 @{[ set 'custom_xform' ]}\n$S{xform}\n}};
	    if ($@) {
		$@ =~ /^(.*)/;
		print '%_'.(set 'custom_xform').'%_ did not compile: '.$1;
	    }
	}
    }

    my $new_settings = join "\n", $VIEWER_MODE
	 ? ("\\", $S{block}, $S{height_adjust}, $S{maxlines}, $S{maxcolumns})
	 : ("!", $S{placement}, $S{position});

    if ($settings_str ne $new_settings) {
	@actString = ();
	%abbrev_cache = ();
	$currentLines = 0;
	killOldStatus();
	delete $viewer{client_settings};
	$settings_str = $new_settings;
    }

    my $was_mouse_mode = $MOUSE_ON;
    if ($MOUSE_ON = Irssi::settings_get_bool(set 'mouse') and !$was_mouse_mode) {
	install_mouse();
    }
    elsif ($was_mouse_mode and !$MOUSE_ON) {
	uninstall_mouse();
    }

    my $path = Irssi::settings_get_str(set 'path');
    my $was_viewer_mode = $VIEWER_MODE;
    if ($was_viewer_mode &&
	defined $viewer{path} && $viewer{path} ne $path) {
	stop_viewer();
	$was_viewer_mode = 0;
    }
    elsif ($was_viewer_mode && $S{no_mode_hint} != $was_no_hint + 0) {
	set_viewer_mode_hint();
    }
    $viewer{path} = $path;
    if ($VIEWER_MODE = Irssi::settings_get_bool(set 'viewer') and !$was_viewer_mode) {
	start_viewer();
    }
    elsif ($was_viewer_mode and !$VIEWER_MODE) {
	stop_viewer();
    }

    %banned_channels = map { lc1459(to_uni($_)) => undef }
	split ' ', Irssi::settings_get_str('banned_channels');

    my @sb_base = split /\177/, sb_format_expand("{sb \177}"), 2;
    $sb_base_width_pre = sb_length($sb_base[0]);
    $sb_base_width_post = sb_length($sb_base[1]);
    $sb_base_width = $sb_base_width_pre + $sb_base_width_post;

    if ($print_text_activity && $S{line_shade}) {
	$shade_line_timer = Irssi::timeout_add(max(10 * GLOB_QUEUE_TIMER, 100*$S{line_shade}**(1/3)), 'wl_changed', undef);
    }

    $CHANGED{AWINS} = 1;
}

sub stop_mouse_tracking {
    print STDERR "\e[?1005l\e[?1000l";
}
sub start_mouse_tracking {
    print STDERR "\e[?1000h\e[?1005h";
}
sub install_mouse {
    Irssi::command_bind('mouse_xterm' => 'mouse_xterm');
    Irssi::command('^bind meta-[M command mouse_xterm');
    Irssi::signal_add_first('gui key pressed' => 'mouse_key_hook');
    start_mouse_tracking();
}
sub uninstall_mouse {
    stop_mouse_tracking();
    Irssi::signal_remove('gui key pressed' => 'mouse_key_hook');
    Irssi::command('^bind -delete meta-[M');
    Irssi::command_unbind('mouse_xterm' => 'mouse_xterm');
}

sub awl_mouse_event {
    return if $VIEWER_MODE;
    if ((($_[0] == 3 and $_[3] == 0)
	     || $_[0] == 64 || $_[0] == 65) and
	    $_[1] == $_[4] and $_[2] == $_[5]) {
	my $top = lc $S{placement} eq 'top';
	my ($pos, $line) = @_[1 .. 2];
	unless ($top) {
	    $line -= $screenHeight;
	    $line += $currentLines;
	    $line += $S{mouse_offset};
	}
	else {
	    $line -= $S{mouse_offset};
	}
	$pos -= $sb_base_width_pre;
	return if $line < 0 || $line >= $currentLines;
	if ($_[0] == 64) {
	    Irssi::command('window up');
	}
	elsif ($_[0] == 65) {
	    Irssi::command('window down');
	}
	elsif (exists $mouse_coords{$line}{$pos}) {
	    my $win = $mouse_coords{$line}{$pos};
	    Irssi::command('window ' . $win);
	}
	Irssi::signal_stop;
    }
}

sub mouse_scroll_event {
    return unless $S{mouse_scroll};
    if (($_[3] == 64 or $_[3] == 65) and
	    $_[0] == $_[3] and $_[1] == $_[4] and $_[2] == $_[5]) {
	my $cmd = 'scrollback goto ' . ($_[3] == 64 ? '-' : '+') . $S{mouse_scroll};
	Irssi::active_win->command($cmd);
	Irssi::signal_stop;
    }
    elsif ($_[0] == 64 or $_[0] == 65) {
	Irssi::signal_stop;
    }
}

sub mouse_escape {
    return unless $S{mouse_escape} > 0;
    if ($_[0] == 3) {
	my $tm = $S{mouse_escape};
	$tm *= 1000 if $tm < 1000;
	stop_mouse_tracking();
	Irssi::timeout_add_once($tm, 'start_mouse_tracking', undef);
	Irssi::signal_stop;
    }
}

sub UNLOAD {
    @actString = ();
    killOldStatus();
    stop_viewer() if $VIEWER_MODE;
    uninstall_mouse() if $MOUSE_ON;
}

sub addPrintTextHook { # update on print text
    return unless defined $^S;
    return if $BLOCK_ALL;
    return unless $print_text_activity;
    return if $_[0]->{level} == 262144 and $_[0]->{target} eq ''
	and !defined($_[0]->{server});
    &wl_changed;
}

sub block_event_window_change {
    Irssi::signal_stop;
}

sub update_awins {
    my @wins = Irssi::windows;
    local $BLOCK_ALL = 1;
    Irssi::signal_add_first('window changed' => 'block_event_window_change');
    my $bwin =
	my $awin = Irssi::active_win;
    my $lwin;
    my $defer_irssi_broken_last;
    unless ($wins[0]{refnum} == $awin->{refnum}) {
	# special case: more than 1 last win, so /win last;
	# /win last doesn't come back to the current window. eg. after
	# connect & autojoin; we can't handle this situation, bail out
	$defer_irssi_broken_last = 1;
    }
    else {
	$awin->command('window last');
	$lwin = Irssi::active_win;
	$lwin->command('window last');
	$defer_irssi_broken_last = $lwin->{refnum} == $bwin->{refnum};
    }
    my $awin_counter = 0;
    Irssi::signal_remove('window changed' => 'block_event_window_change');
    unless ($defer_irssi_broken_last) {
	# we need to keep the fe-windows code running here
	Irssi::signal_add_priority('window changed' => 'block_event_window_change', -99);
	%awins = %wnmap_exp = ();
	do {
	    Irssi::active_win->command('window up');
	    $awin = Irssi::active_win;
	    $awins{$awin->{refnum}} = undef;
	    ++$awin_counter;
	} until ($awin->{refnum} == $bwin->{refnum} || $awin_counter >= @wins);
	Irssi::signal_remove('window changed' => 'block_event_window_change');

	Irssi::signal_add_first('window changed' => 'block_event_window_change');
	for my $key (keys %wnmap) {
	    next unless Irssi::window_find_name($key) || Irssi::window_find_item($key);
	    $awin->command("window goto $key");
	    my $cwin = Irssi::active_win;
	    $wnmap_exp{ $cwin->{refnum} } = $wnmap{$key};
	    $cwin->command('window last')
		if $cwin->{refnum} != $awin->{refnum};
	}
	for my $win (reverse @wins) { # restore original window order
	    Irssi::active_win->command('window '.$win->{refnum});
	}
	$awin->command('window '.$lwin->{refnum}); # restore last win
	Irssi::active_win->command('window last');
	Irssi::signal_remove('window changed' => 'block_event_window_change');
    }
    $CHANGED{WL} = 1;
}

sub resizeTerm {
    if (defined (my $r = `stty size 2>/dev/null`)) {
	($screenHeight, $screenWidth) = split ' ', $r;
	$CHANGED{SETUP} = 1;
    }
    else {
	$CHANGED{SIZE} = 1;
    }
}

sub awl_refresh {
    $globTime = undef;
    resizeTerm()   if delete $CHANGED{SIZE};
    reset_awl()    if delete $CHANGED{SETUP};
    update_awins() if delete $CHANGED{AWINS};
    update_wl()    if delete $CHANGED{WL};
}

sub termsize_changed { $CHANGED{SIZE}  = 1; &queue_refresh; }
sub setup_changed    { $CHANGED{SETUP} = 1; &queue_refresh; }
sub awins_changed    { $CHANGED{AWINS} = 1; &queue_refresh; }
sub wl_changed       { $CHANGED{WL}    = 1; &queue_refresh; }

sub window_changed {
    &awins_changed if $_[1];
}

sub queue_refresh {
    return if $BLOCK_ALL;
    Irssi::timeout_remove($globTime)
	    if defined $globTime; # delay the update further
    $globTime = Irssi::timeout_add_once(GLOB_QUEUE_TIMER, 'awl_refresh', undef);
}

sub awl_init {
    termsize_changed();
    update_keymap();
}

sub runsub {
    my $cmd = shift;
    sub {
	my ($data, $server, $item) = @_;
	Irssi::command_runsub($cmd, $data, $server, $item);
    };
}

Irssi::signal_register({
    'gui mouse' => [qw/int int int int int int/],
   });
{ my $broken_expandos = (Irssi::version >= 20081128 && Irssi::version < 20110210)
      ? sub { my $x = shift; $x =~ s/\$\{cumode_space\}/ /; $x } : undef;
  Irssi::theme_register([
    map { $broken_expandos ? $broken_expandos->($_) : $_ }
    set 'display_nokey'		=>   '$N${cumode_space}$H$C$S',
    set 'display_key'		=>   '$Q${cumode_space}$H$C$S',
    set 'display_nokey_visible' => '%2$N${cumode_space}$H$C$S',
    set 'display_key_visible'	=> '%2$Q${cumode_space}$H$C$S',
    set 'display_nokey_active'	=> '%1$N${cumode_space}$H$C$S',
    set 'display_key_active'	=> '%1$Q${cumode_space}$H$C$S',
    set 'display_header'	=> '%8$C|${N}',
    set 'name_display'		=> '$0',
    set 'separator'		=> ' ',
    set 'separator2'		=> '',
    set 'viewer_item_bg'	=> sb_format_expand('{sb_background}'),
   ]);
}
Irssi::settings_add_bool(setc, set 'prefer_name',    0); #
Irssi::settings_add_int( setc, set 'hide_empty',     0); #
Irssi::settings_add_int( setc, set 'hide_data',      0); #
Irssi::settings_add_int( setc, set 'hide_name_data', 0); #
Irssi::settings_add_int( setc, set 'maxlines',       9); #
Irssi::settings_add_int( setc, set 'maxcolumns',     4); #
Irssi::settings_add_int( setc, set 'block',          15); #
Irssi::settings_add_bool(setc, set 'sbar_maxlength', 1); #
Irssi::settings_add_int( setc, set 'height_adjust',  2); #
Irssi::settings_add_str( setc, set 'sort',           'refnum'); #
Irssi::settings_add_str( setc, set 'placement',      'bottom'); #
Irssi::settings_add_int( setc, set 'position',       0); #
Irssi::settings_add_bool(setc, set 'all_disable',    1); #
Irssi::settings_add_bool(setc, set 'viewer',         1); #
Irssi::settings_add_str( setc, set 'shared_sbar',    'OFF'); #
Irssi::settings_add_bool(setc, set 'mouse',          0); #
Irssi::settings_add_str( setc, set 'path', Irssi::get_irssi_dir . '/_windowlist'); #
Irssi::settings_add_str( setc, set 'custom_xform',   ''); #
Irssi::settings_add_time(setc, set 'last_line_shade', '0'); #
Irssi::settings_add_int( setc, set 'mouse_offset',   1); #
Irssi::settings_add_int( setc, 'mouse_scroll',       3); #
Irssi::settings_add_int( setc, 'mouse_escape',       1); #
Irssi::settings_add_str( setc, 'banned_channels',    '');
Irssi::settings_add_bool(setc, 'banned_channels_on', 1);
Irssi::settings_add_str( setc, 'fancy_abbrev',       'fancy'); #
Irssi::settings_add_bool(setc, set 'no_mode_hint',   0); #
Irssi::settings_add_bool(setc, set 'viewer_launch',  1); #
Irssi::settings_add_str( setc, set 'viewer_launch_env',  ''); #
Irssi::settings_add_str( setc, set 'viewer_tmux_position',  'left'); #
Irssi::settings_add_str( setc, set 'viewer_xwin_command',  'xterm +sb -e %A'); #
Irssi::settings_add_str( setc, set 'viewer_custom_command',  ''); #

Irssi::signal_add_last({
    'setup changed'    => 'setup_changed',
    'print text'       => 'addPrintTextHook',
    'terminal resized' => 'termsize_changed',
    'setup reread'     => 'screenFullRedraw',
    'window hilight'   => 'wl_changed',
    'command format'   => 'wl_changed',
});
Irssi::signal_add({
    'window changed'	       => 'window_changed',
    'window item changed'      => 'wl_changed',
    'window changed automatic' => 'window_changed',
    'window created'	       => 'awins_changed',
    'window destroyed'	       => 'awins_changed',
    'window name changed'      => 'wl_changed',
    'window refnum changed'    => 'wl_changed',
});
Irssi::signal_add_last('gui mouse' => 'mouse_escape');
Irssi::signal_add_last('gui mouse' => 'mouse_scroll_event');
Irssi::signal_add_last('gui mouse' => 'awl_mouse_event');
Irssi::command_bind( setc() => runsub(setc()) );
Irssi::command_bind( setc() . ' redraw' => 'screenFullRedraw' );
Irssi::command_bind( setc() . ' restart' => 'restartViewerServer' );

{
    my $l = set 'shared';
    {
	no strict 'refs';
	*{$l} = $awl_shared_empty;
    }
    Irssi::statusbar_item_register($l, '$0', $l);
}

awl_init();

# Mouse script based on irssi mouse patch by mirage
{ my $mouse_status = -1; # -1:off 0,1,2:filling mouse_combo
  my @mouse_combo; # 0:button 1:x 2:y
  my @mouse_previous; # previous contents of mouse_combo

  sub mouse_xterm_off {
      $mouse_status = -1;
  }
  sub mouse_xterm {
      $mouse_status = 0;
      Irssi::timeout_add_once(10, 'mouse_xterm_off', undef);
  }

  sub mouse_key_hook {
      my ($key) = @_;
      if ($mouse_status != -1) {
	  if ($mouse_status == 0) {
	      @mouse_previous = @mouse_combo;
		  #if @mouse_combo && $mouse_combo[0] < 64;
	  }
	  $mouse_combo[$mouse_status] = $key - 32;
	  $mouse_status++;
	  if ($mouse_status == 3) {
	      $mouse_status = -1;
	      # match screen coordinates
	      $mouse_combo[1]--;
	      $mouse_combo[2]--;
	      Irssi::signal_emit('gui mouse', @mouse_combo[0 .. 2], @mouse_previous[0 .. 2]);
	  }
	  Irssi::signal_stop;
      }
  }
}

sub string_LCSS {
    my $str = join "\0", @_;
    (sort { length $b <=> length $a } $str =~ /(?=(.+).*\0.*\1)/g)[0]
}

{ package Irssi::Nick }

UNITCHECK
{ package AwlViewer;
  use strict;
  use warnings;
  no warnings 'redefine';
  use Encode;
  use IO::Socket::UNIX;
  use IO::Select;
  use List::Util qw(max);
  use constant BLOCK_SIZE => 1024;
  use constant RECONNECT_TIME => 5;

  my $sockpath;

  our $VERSION = '0.8';

  our ($got_int, $resized, $timeout);

  my %vars;
  my (%c2w, @seqlist);
  my %mouse_coords;
  my (@mouse, @last_mouse);
  my ($err, $sock, $loop);
  my ($keybuf, $rcvbuf);
  my @screen;
  my ($screenHeight, $screenWidth);
  my ($disp_update, $fs_open, $one_shot_integration, $one_shot_resize);
  my $integration_position;
  my $show_title_bar;

  sub connect_it {
      $sock = IO::Socket::UNIX->new(
	  Type => SOCK_STREAM,
	  Peer => $sockpath,
	 );
      unless ($sock) {
	  $err = $!;
	  return;
      }
      $sock->blocking(0);
      $loop->add($sock);
  }

  sub remove_conn {
      my $fh = shift;
      $loop->remove($fh);
      $fh->close;
      $sock = undef;
      %vars = ();
      @screen = ();
  }

  { package Terminfo; # xterm
    sub civis      { "\e[?25l" }
    sub sc	   { "\e7" }
    sub cup	   { "\e[" . ($_[0] + 1) . ';' . ($_[1] + 1) . 'H' }
    sub el	   { "\e[K" }
    sub rc	   { "\e8" }
    sub cnorm      { "\e[?25h" }
    sub setab      { "\e[4" . $_[0] . 'm' }
    sub setaf      { "\e[3" . $_[0] . 'm' }
    sub setaf16    { "\e[9" . $_[0] . 'm' }
    sub setab16    { "\e[10" . $_[0] . 'm' }
    sub setaf256   { "\e[38;5;" . $_[0] . 'm' }
    sub setab256   { "\e[48;5;" . $_[0] . 'm' }
    sub sgr0       { "\e[0m" }
    sub bold       { "\e[1m" }
    sub it         { "\e[3m" }
    sub ul         { "\e[4m" }
    sub blink      { "\e[5m" }
    sub rev	   { "\e[7m" }
    sub op	   { "\e[39;49m" }
    sub exit_bold  { "\e[22m" }
    sub exit_it    { "\e[23m" }
    sub exit_ul    { "\e[24m" }
    sub exit_blink { "\e[25m" }
    sub exit_rev   { "\e[27m" }
    sub smcup      { "\e[?1049h" }
    sub rmcup      { "\e[?1049l" }
    sub smmouse    { "\e[?1000h\e[?1005h" }
    sub rmmouse    { "\e[?1005l\e[?1000l" }
  }

  sub init {
      $sockpath = shift // "$ENV{HOME}/.irssi/_windowlist";
      STDOUT->autoflush(1);
      printf "\r%swaiting for %s...", Terminfo::sc, $::IRSSI{name};

      `stty -icanon -echo`;

      $loop = IO::Select->new;
      STDIN->blocking(0);
      $loop->add(\*STDIN);

      $SIG{INT} = sub {
	  $got_int = 1
      };
      $SIG{WINCH} = sub {
	  $resized = 1
      };

      $resized = 3;

      $disp_update = 2;

      $show_title_bar = 1;
  }

  sub enter_fs {
      return if $fs_open;
      safe_print(Terminfo::rc, Terminfo::smcup, Terminfo::civis, Terminfo::smmouse);
      $fs_open = 1;
  }

  sub leave_fs {
      return unless $fs_open;
      safe_print(Terminfo::rmmouse, Terminfo::cnorm, Terminfo::rmcup);
      safe_print(sprintf "\r%swaiting for %s...", Terminfo::sc, $::IRSSI{name}) if $_[0];

      $fs_open = 0;
  }

  sub end_prog {
      leave_fs();
      STDIN->blocking(1);
      `stty sane`;
      printf "\r%s%sthanks for using %s\n", Terminfo::rc, Terminfo::el, $::IRSSI{name};
  }

  sub safe_print {
      my $st = STDIN->blocking(1);
      print @_;
      STDIN->blocking($st);
  }

  sub safe_qx {
      my $st = STDIN->blocking(1);
      my $ret = `$_[0]`;
      STDIN->blocking($st);
      $ret
  }

  sub safe_print_sock {
      return unless $sock;
      my $was = $sock->blocking(1);
      $sock->print(@_);
      $sock->blocking($was);
  }

  sub process_recv {
      my $need = 0;
      while ($rcvbuf =~ s/\n(.+)_BEGIN\n((?: .*\n)*)\1_END\n//) {
	  my $var = lc $1;
	  my $data = $2;
	  my @data = split "\n ", "\n$data ", -1;
	  shift @data; pop @data;
	  my $itembg = $vars{itembg};
	  if ($var =~ s/list$//) {
	      $vars{$var} = \@data;
	  }
	  elsif ($var =~ s/map$//) {
	      $vars{$var} = +{ @data };
	  }
	  else {
	      $vars{$var} = join "\n", @data;
	  }
	  $need = 1 if $var eq 'win';
	  $need = 1 if $var eq 'redraw' && $vars{$var};
	  if (($itembg//'') ne ($vars{itembg}//'')) {
	      $need = $vars{redraw} = 1;
	  }
	  _build_keymap() if $var eq 'key2';
      }
      $need
  }

  { my %ansi_table;
    my ($i, $j, $k) = (0, 0, 0);
    my %term_state;
    sub reset_term_state { my %old_term = %term_state; %term_state = (); %old_term }
    sub set_term_state { my %old_term = %term_state; %term_state = @_; %old_term }
    %ansi_table = (
	# fe-common::core::formats.c:format_expand_styles
	(map { my $t = $i++; ($_ => sub { my $n = $term_state{hicolor} ? \&Terminfo::setab16 : \&Terminfo::setab;
					  $n->($t) }) } (split //, '01234567' )),
	(map { my $t = $j++; ($_ => sub { my $n = $term_state{hicolor} ? \&Terminfo::setaf16 : \&Terminfo::setaf;
					  $n->($t) }) } (split //, 'krgybmcw' )),
	(map { my $t = $k++; ($_ => sub { my $n = $term_state{hicolor} ? \&Terminfo::setaf : \&Terminfo::setaf16;
					  $n->($t) }) } (split //, 'KRGYBMCW')),
	# reset
	n => sub { $term_state{hicolor} = 0; my $r = Terminfo::op;
		   for (qw(blink rev bold)) {
		       $r .= Terminfo->can("exit_$_")->() if delete $term_state{$_};
		   }
		   {
		       local $ansi_table{n} = $ansi_table{N};
		       $r .= formats_to_ansi_basic($vars{itembg});
		   }
		   $r
	       },
	N => sub { reset_term_state(); Terminfo::sgr0 },
	# flash/bright
	F => sub { my $n = 'blink'; my $e = ($term_state{$n} ^= 1) ? $n : "exit_$n"; Terminfo->can($e)->() },
	# reverse
	8 => sub { my $n = 'rev'; my $e = ($term_state{$n} ^= 1) ? $n : "exit_$n"; Terminfo->can($e)->() },
	# bold
	"_" => sub { my $n = 'bold'; my $e = ($term_state{$n} ^= 1) ? $n : "exit_$n"; Terminfo->can($e)->() },
	# underline
	U => sub { my $n = 'ul'; my $e = ($term_state{$n} ^= 1) ? $n : "exit_$n"; Terminfo->can($e)->() },
	# italic
	I => sub { my $n = 'it'; my $e = ($term_state{$n} ^= 1) ? $n : "exit_$n"; Terminfo->can($e)->() },
	# bold, used as colour modifier if AWL_HI9 is set
	9 => $ENV{AWL_HI9} ? sub { $term_state{hicolor} ^= 1; '' }
	    : sub { my $n = 'bold'; my $e = ($term_state{$n} ^= 1) ? $n : "exit_$n"; Terminfo->can($e)->() },
	#      delete                other stuff
	(map { $_ => sub { '' } } (split //, ':|>#[')),
	#      escape
	(map { my $close = $_; $_ => sub { $close } } (split //, '{}%')),
       );
    for my $base (0 .. 15) {
	my $close = $base;
	my $idx = ($close&8) | ($close&4)>>2 | ($close&2) | ($close&1)<<2;
	$ansi_table{ (sprintf "x0%x", $close) } =
	    $ansi_table{ (sprintf "x0%X", $close) } =
		sub { Terminfo::setab256($idx) };
	$ansi_table{ (sprintf "X0%x", $close) } =
	    $ansi_table{ (sprintf "X0%X", $close) } =
		sub { Terminfo::setaf256($idx) };
    }
    for my $plane (1 .. 6) {
	for my $coord (0 .. 35) {
	    my $close = 16 + ($plane-1) * 36 + $coord;
	    my $ch = $coord < 10 ? $coord : chr( $coord - 10 + ord 'a' );
	    $ansi_table{ "x$plane$ch" } =
		$ansi_table{ "x$plane\U$ch" } =
		    sub { Terminfo::setab256($close) };
	    $ansi_table{ "X$plane$ch" } =
		$ansi_table{ "X$plane\U$ch" } =
		    sub { Terminfo::setaf256($close) };
	}
    }
    for my $gray (0 .. 23) {
	my $close = 232 + $gray;
	my $ch = chr( $gray + ord 'a' );
	$ansi_table{ "x7$ch" } =
	    $ansi_table{ "x7\U$ch" } =
		sub { Terminfo::setab256($close) };
	$ansi_table{ "X7$ch" } =
	    $ansi_table{ "X7\U$ch" } =
		sub { Terminfo::setaf256($close) };
    }
    sub formats_to_ansi_basic {
	my $o = shift;
	$o =~ s/(%(X..|x..|.))/exists $ansi_table{$2} ? $ansi_table{$2}->() : $1/gex;
	$o
    }
  }

  sub _header {
      my $str = uc ::setc();
      my $space = int( ((abs $vars{block}) - length $str) / (1 + length $str));
      if ($space > 0) {
	  my $ss = ' ' x $space;
	  $str = join $ss, '', (split //, $str), '';
      }
      my $pad = (abs $vars{block}) - length $str;
      $str = ' ' x ($pad/2) . $str . ' ' x ($pad/2 + $pad%2);
      $str
  }

  sub _add_item {
      my ($i, $j, $c, $wi, $screen, $mouse) = @_;
      $screen->[$i][$j] = "%N%n$wi";
      if (exists $vars{mouse}{$c - 1}) {
	  $mouse->[$i][$j] = $vars{mouse}{$c - 1};
      }
  }
  sub update_screen {
      $disp_update = 0;
      unless ($sock && exists $vars{seplen} && exists $vars{block}) {
	  leave_fs(1);
	  return;
      }
      enter_fs();
      @screen = () if delete $vars{redraw};
      %mouse_coords = ();
      my $ncols = ($vars{seplen} + abs $vars{block}) ?
	  int( ($screenWidth + $vars{seplen}) / ($vars{seplen} + abs $vars{block}) ) : 0;
      my $xenl = ($vars{seplen} + abs $vars{block})
	  && $ncols > int( ($screenWidth + $vars{seplen} - 1) / ($vars{seplen} + abs $vars{block}) );
      my $nrows = $screenHeight - $vars{ha};
      my @wi = @{$vars{win}//[]};
      my $max_items = $ncols * $nrows;
      my $c = $show_title_bar ? 1 : 0;
      my $items = @wi + $c;
      my $titems = $items > $max_items ? $max_items : $items;
      my $i = 0;
      my $j = 0;
      my @new_screen;
      my @new_mouse;
      $new_screen[0][0] = _header() . ' ' x $vars{seplen}
	  if $show_title_bar;
      unless ($nrows > $ncols) { # line layout
	  ++$j if $show_title_bar;
	  for my $wi (@wi) {
	      if ($j >= $ncols) {
		  $j = 0;
		  ++$i;
	      }
	      last if $i >= $nrows;
	      _add_item($i, $j, $show_title_bar ? $c : $c + 1,
			$wi, \@new_screen, \@new_mouse);
	      if ($c + 1 < $titems && $j + 1 < $ncols) {
		  $new_screen[$i][$j] .= $vars{separator};
	      }
	      ++$j;
	      ++$c;
	  }
      }
      else { # column layout
	  ++$i if $show_title_bar;
	  for my $wi (@wi) {
	      if ($i >= $nrows) {
		  $i = 0;
		  ++$j;
	      }
	      last if $j >= $ncols;
	      _add_item($i, $j, $show_title_bar ? $c : $c + 1,
			$wi, \@new_screen, \@new_mouse);
	      if ($c + $nrows < $titems) {
		  $new_screen[$i][$j] .= $vars{separator};
	      }
	      ++$i;
	      ++$c;
	  }
      }
      my $step = $vars{seplen} + abs $vars{block};
      $i = 0;
      my $str = Terminfo::sc . Terminfo::sgr0;
      for (my $i = 0; $i < @new_screen; ++$i) {
	  for (my $j = 0; $j < @{$new_screen[$i]}; ++$j) {
	      if (defined $new_mouse[$i] && defined $new_mouse[$i][$j]) {
		  my $from = $j * $step;
		  $mouse_coords{$i}{$_} = $new_mouse[$i][$j]
		      for $from .. $from + abs $vars{block};
	      }
	      next if defined $screen[$i] && defined $screen[$i][$j]
		  && $screen[$i][$j] eq $new_screen[$i][$j];
	      $str .= Terminfo::cup($i, $j * $step)
		   .  formats_to_ansi_basic($new_screen[$i][$j])
		   .  Terminfo::sgr0;
	      $str .= Terminfo::el if $j == $#{$new_screen[$i]} && (!$xenl || $j + 1 != $ncols);
	  }
      }
      for (@new_screen .. $screenHeight - 1) {
	  if (!@screen || defined $screen[$_]) {
	      $str .= Terminfo::cup($_, 0) . Terminfo::sgr0 . Terminfo::el;
	  }
      }
      $str .= Terminfo::rc;
      safe_print $str;
      @screen = @new_screen;
  }

  sub handle_resize {
      if (defined (my $r = safe_qx('stty size'))) {
	  ($screenHeight, $screenWidth) = split ' ', $r;
	  $resized = 0;
	  @screen = ();
	  $disp_update = 1;
	  if ($one_shot_integration == 2) {
	      $one_shot_resize--;
	  }
      }
      else {
      }
  }

  sub _build_keymap {
      %c2w = reverse( %{$vars{key}}, %{$vars{key2}} );
      if (!grep { /^[+-]./ } keys %c2w) {
	  %c2w = (%c2w, map { ("-$_" => $c2w{$_}) } grep { !/^\^./ } keys %c2w);
      }
      %c2w = map {
	  my $key = $_;
	  s{^(-)?(\+)?(\^)?(.)}{
	      join '', (
		  ($1 ? "\e" : ''),
		  ($2 ? "\e\e" : ''),
		  ($3 ? "$4"^"@" : $4)
		 )
	  }e;
	  $_ => $c2w{$key}
      } keys %c2w;
      @seqlist = sort { length $b <=> length $a } keys %c2w;
  }

  sub _match_tmux {
      length $ENV{TMUX} && exists $vars{irssienv}{tmux_srv} && length $vars{irssienv}{tmux_pane}
	  && $ENV{TMUX} eq $vars{irssienv}{tmux_srv}
  }

  sub process_keys {
      Encode::_utf8_on($keybuf);
      my $win;
      my $use_mouse;
      my $maybe;
  KEY: while (length $keybuf && !$maybe) {
	  $maybe = 0;
	  if ($keybuf =~ s/^\e\[M(.)(.)(.)//) {
	      @last_mouse = @mouse;# if @mouse && $mouse[0] < 64;
	      @mouse = map { -32 + ord } ($1, $2, $3);
	      $use_mouse = 1;
	      next KEY;
	  }
	  for my $s (@seqlist) {
	      if ($keybuf =~ s/^\Q$s//) {
		  $win = $c2w{$s};
		  $use_mouse = 0;
		  next KEY;
	      }
	      elsif (length $keybuf < length $s && $s =~ /^\Q$keybuf/) {
		  $maybe = 1;
	      }
	  }
	  unless ($maybe) {
	      substr $keybuf, 0, 1, '';
	  }
      }
      if ($use_mouse && @mouse && @last_mouse &&
	      $mouse[2] == $last_mouse[2] &&
		  $mouse[1] == $last_mouse[1] &&
		      ($mouse[0] == 3 || $mouse[0] == 64 || $mouse[0] == 65)) {
	  if ($mouse[0] == 64) {
	      $win = 'up';
	  }
	  elsif ($mouse[0] == 65) {
	      $win = 'down';
	  }
	  elsif (exists $mouse_coords{$mouse[2] - 1}{$mouse[1] - 1}) {
	      $win = $mouse_coords{$mouse[2] - 1}{$mouse[1] - 1};
	  }
	  elsif ($mouse[2] == 1 && $mouse[1] <= abs $vars{block}) {
	      $win = $last_mouse[0] != 0 ? 'last' : 'active';
	  }
	  else {
	  }
      }
      if (defined $win) {
	  $win =~ s/^_//;
	  safe_print_sock("$win\n");
	  if (!exists $ENV{AWL_AUTOFOCUS} || $ENV{AWL_AUTOFOCUS}) {
	      if (_match_tmux()) {
		  safe_qx("tmux selectp -t $vars{irssienv}{tmux_pane} 2>&1");
	      }
	      elsif (exists $vars{irssienv}{xwinid}) {
		  safe_qx("wmctrl -ia $vars{irssienv}{xwinid} 2>/dev/null");
	      }
	  }
      }
      Encode::_utf8_off($keybuf);
  }

  sub check_integration {
      return unless $vars{irssienv};
      return unless $sock && exists $vars{seplen} && exists $vars{block};
      if ($one_shot_integration == 1) {
	  my $nrows = $screenHeight - $vars{ha};
	  my $ncols = ($vars{seplen} + abs $vars{block}) ? int( ($screenWidth + $vars{seplen}) / ($vars{seplen} + abs $vars{block}) ) : 0;
	  my $items = ($show_title_bar ? 1 : 0) + @{$vars{win}//[]};
	  my $dcols_required = $nrows ? int($items/$nrows) + !!($items%$nrows) : 0;
	  my $rows_required = $ncols ? int($items/$ncols) + !!($items%$ncols) : 0;
	  $rows_required = abs $vars{ml}
	      if ($vars{ml} < 0 || ($vars{ml} > 0 && $rows_required > $vars{ml}));
	  $dcols_required = abs $vars{mc}
	      if ($vars{mc} < 0 || ($vars{mc} > 0 && $dcols_required > $vars{mc}));
	  my $rows = $rows_required + $vars{ha};
	  my $cols = ($dcols_required * ($vars{seplen} + abs $vars{block})) - $vars{seplen};
	  if (_match_tmux()) {
	      # int( ($screenWidth + $vars{seplen}) / ($vars{seplen} + abs $vars{block}) );
	      my ($pos_flag, $before);
	      if ($integration_position eq 'left') {
		  $pos_flag = 'h';
		  $before = 1;
	      }
	      elsif ($integration_position eq 'top') {
		  $pos_flag = 'v';
		  $before = 1;
	      }
	      elsif ($integration_position eq 'right') {
		  $pos_flag = 'h';
	      }
	      else {
		  $pos_flag = 'v';
	      }
	      my @cmd = "joinp -d$pos_flag -s $ENV{TMUX_PANE} -t $vars{irssienv}{tmux_pane}";
	      push @cmd, "swapp -d -t $ENV{TMUX_PANE} -s $vars{irssienv}{tmux_pane}"
		  if $before;
	      $cols = max($cols, 2);
	      $rows = max($rows, 2);

	      safe_qx("tmux " . (join " \\\; ", @cmd) . " 2>&1");
	  }
	  else {
	      $resized = 1;
	      #safe_qx("resize -s $screenHeight $cols 2>&1")
		#  if $cols > 0;
	  }
	  $one_shot_integration++;
	  if ($resized == 1) {
	      handle_resize();
	      resize_integration();
	  }
      }
      elsif ($one_shot_integration == 2) {
	  resize_integration(1);
      }
  }

  sub resize_integration {
      return unless $one_shot_integration;
      return unless ($one_shot_resize//0) < 0 || shift;
      my $nrows = $screenHeight - $vars{ha};
      my $ncols = ($vars{seplen} + abs $vars{block}) ? int( ($screenWidth + $vars{seplen}) / ($vars{seplen} + abs $vars{block}) ) : 0;
      my $items = ($show_title_bar ? 1 : 0) + @{$vars{win}//[]};
      my $dcols_required = $nrows ? (int($items/$nrows) + !!($items%$nrows)) : 0;
      my $rows_required = $ncols ? int($items/$ncols) + !!($items%$ncols) : 0;
      $rows_required = abs $vars{ml}
	  if ($vars{ml} < 0 || ($vars{ml} > 0 && $rows_required > $vars{ml}));
      $dcols_required = abs $vars{mc}
	  if ($vars{mc} < 0 || ($vars{mc} > 0 && $dcols_required > $vars{mc}));
      my $rows = $rows_required + $vars{ha};
      my $cols = ($dcols_required * ($vars{seplen} + abs $vars{block})) - $vars{seplen};
      if (_match_tmux()) {
	  my $pos_flag;
	  my $before = 0;
	  if ($integration_position eq 'left') {
	      $pos_flag = 'h';
	      $before = 1;
	  }
	  elsif ($integration_position eq 'top') {
	      $pos_flag = 'v';
	      $before = 1;
	  }
	  elsif ($integration_position eq 'right') {
	      $pos_flag = 'h';
	  }
	  else {
	      $pos_flag = 'v';
	  }
	  my @cmd;
	  # hard tmux limits
	  $cols = max($cols, 2);
	  $rows = max($rows, 2);
	  if ($pos_flag eq 'h' && $cols != $screenWidth) {
	      my $change = $screenWidth - $cols;
	      my $dir = ($before ^ ($change<0)) ? 'L' : 'R';
	      push @cmd, "resizep -$dir -t $ENV{TMUX_PANE} @{[abs $change]}";
	      #push @cmd, "resizep -x $cols -t $ENV{TMUX_PANE}";
	      $one_shot_resize = 1;
	  }
	  if ($pos_flag eq 'v' && $rows != $screenHeight) {
	      #push @cmd, "resizep -y $rows -t $ENV{TMUX_PANE}";
	      my $change = $screenHeight - $rows;
	      my $dir = ($before ^ ($change<0)) ? 'U' : 'D';
	      push @cmd, "resizep -$dir -t $ENV{TMUX_PANE} @{[abs $change]}";
	      $one_shot_resize = 1;
	  }

	  safe_qx("tmux " . (join " \\\; ", @cmd) . " 2>&1")
	      if @cmd;
      }
      else {
	  $cols = max($cols, 1);
	  $rows = max($rows, 1);
	  unless ($nrows > $ncols) { # line layout
	      if ($rows != $screenHeight) {
		  safe_qx("resize -s $rows $screenWidth 2>&1");
		  $one_shot_resize = 1;
	      }
	  }
	  else {
	      if ($cols != $screenWidth) {
		  safe_qx("resize -s $screenHeight $cols 2>&1");
		  $one_shot_resize = 1;
	      }
	  }
      }
      if ($resized == 1) {
	  handle_resize();
      }
  }

  sub init_integration {
      return unless $one_shot_integration;
      if (_match_tmux()) {
      }
      else {
      }
      safe_print("\e]2;".(uc ::setc())."\e\\");
  }

  sub main {
      require Getopt::Std;
      my %opts;
      Getopt::Std::getopts('1p:', \%opts);
      my $one_shot = $opts{1};
      $integration_position = $opts{p};
      $one_shot_integration = 0+!!$one_shot;
      #shift if @_ && $_[0] eq '--';
      &init;
      $show_title_bar = 0 if $ENV{AWL_NOTITLE};
      init_integration();
      until ($got_int) {
	  $timeout = undef;
	  if ($resized) {
	      if ($resized == 1) {
		  $timeout = 1;
		  $resized++;
	      }
	      else {
		  handle_resize();
		  resize_integration();
	      }
	  }
	  unless ($sock || $timeout) {
	      connect_it();
	  }
	  $timeout ||= RECONNECT_TIME unless $sock;
	  update_screen() if $disp_update;
      SELECT: while (my @read = $loop->can_read($timeout)) {
	      for my $fh (@read) {
		  if ($fh == \*STDIN) {
		      if (read STDIN, my $buf, BLOCK_SIZE) {
			  do {
			      $keybuf .= $buf;
			  } while read STDIN, $buf, BLOCK_SIZE;
		      }
		      else {
			  $got_int = 1;
			  last SELECT;
		      }
		  }
		  else {
		      if ($fh->read(my $buf, BLOCK_SIZE)) {
			  do {
			      $rcvbuf .= $buf;
			  } while $fh->read($buf, BLOCK_SIZE);
		      }
		      else {
			  $disp_update = 1;
			  remove_conn($fh);
			  if ($one_shot) {
			      $got_int = 1;
			      last SELECT;
			  }
			  $timeout ||= RECONNECT_TIME;
		      }
		  }
	      }
	      $disp_update |= process_recv() if length $rcvbuf;
	      process_keys() if length $keybuf;
	      check_integration() if $one_shot;
	      update_screen() if $disp_update;
	  }
	  continue {
	  }
      }
      end_prog();
  }
}

1;

# Changelog
# =========
# 1.1
# - infinite loop on shortening certain window names reported by Kalan
#
# 1.0
# - new awl_viewer_launch setting and an array of related settings
# - fixed regression bug /exec -interactive
# - fixed some warnings in perl 5.10 reported by kl3
# - workaround for crash due to infinite recursion in irssi's Perl
#   error handling
#
# 0.9
# - fix endless loop in awin detection code!
# - correct colour swap in awl_viewer
# - fix passing of alternate socket path to the viewer
# - potential undefinedness in mouse refnum hinted at by Canopus
# - fixed regression bug /exec -interactive
# - add case-insensitive modifier to awl_sort
# - run custom_xform on awl_prefer_name also
# - avoid inconsistent active window state after awin detection
#   reported by ss
# - revert %9-hack in the viewer prompted by discussion with pierrot
# - fix new warning in perl 5.22
#
# 0.8
# - replace fifo mode with external viewer script
# - remove bundled cpan modules
# - work around bogus irssi warning
# - improve mouse support
# - workaround for broken cumode in irssi 0.8.15
# - fix handling of non-meta windows (uninitialized warning)
# - add 256 colour support, strip true colour codes
# - fix totally bogus $N padding reported by Ed S.
# - make /window goto #name mappings work but ignore non-existant ones
# - improve incomplete reads reported by bcode
# - fix single % in awl_viewer reported by bcode
# - add support for key bindings by nike and ferret
# - coerce utf8 key binds
# - add settings: custom_xform, last_line_shade, hide_name_data
# - abbreviations were broken in some cases
# - fix some misuse of / as cmdchar in mouse script reported by bcode
# - add shared status bar mode
# - ${type} variables for custom_xform setting
# - crash if custom_xform had runtime error
# - update sorting documentation
# - fix odd case in size calculation noted by lasers
# - add missing font styles to the viewer reported by ishanyx
# - add italic
#
# 0.7g
# - remove screen support and replace it with fifo support
# - add double-width support to the shortener
# - correct documentation regarding $T vs. display_header
# - add missing refresh for window item changed (thanks vague)
# - add visible windows
# - add exemptions for active window
# - workaround for hiding the window changes from trackbar
# - hack to force 16colours in screen mode
# - remember last window (reported by earthnative)
# - wrong window focus on new queries (reported by emsid)
# - dataloss bug on trying to remember last window
#
# 0.6d+
# - add support for network headers
# - fixed regression bug /exec -interactive
#
# 0.6ca+
# - add screen support (from nicklist.pl)
# - names can now have a max length and window names can be used
# - fixed a bug with block display in screen mode and status bar mode
# - added space handling to ir_fe and removed it again
# - now handling formats on my own
# - started to work on $tag display
# - added warning about missing sb_act_none abstract leading to
# - display*active settings
# - added warning about the bug in awl_display_(no)key_active settings
# - mouse hack
#
# 0.5d
# - add setting to also hide the last status bar if empty (awl_all_disable)
# - reverted to old utf8 code to also calculate broken utf8 length correctly
# - simplified dealing with status bars in wlreset
# - added a little tweak for the renamed term_type somewhere after Irssi 0.8.9
# - fixed bug in handling channel #$$
# - reset background colour at the beginning of an entry
#
# 0.4d
# - fixed order of disabling status bars
# - several attempts at special chars, without any real success
#   and much more weird new bugs caused by this
# - setting to specify sort order
# - reduced timeout values
# - added awl_hide_data
# - make it so the dynamic sub is actually deleted
# - fix a bug with removing of the last separator
# - take into consideration parse_special
#
# 0.3b
# - automatically kill old status bars
# - reset on /reload
# - position/placement settings
#
# 0.2
# - automated retrieval of key bindings (thanks grep.pl authors)
# - improved removing of status bars
# - got rid of status chop
#
# 0.1
# - Based on chanact.pl which was apparently based on lightbar.c and
#   nicklist.pl with various other ideas from random scripts.
