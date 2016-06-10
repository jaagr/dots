# trackbar.pl
#
# This little script will do just one thing: it will draw a line each time you
# switch away from a window. This way, you always know just upto where you've
# been reading that window :) It also removes the previous drawn line, so you
# don't see double lines.
#
#  redraw trackbar only works on irssi 0.8.17 or higher.
#
#
# Usage:
#
#     The script works right out of the box, but if you want you can change
#     the working by /set'ing the following variables:
#
#    Setting:     trackbar_style
#    Description: This setting will be the color of your trackbar line.
#                 By default the value will be '%K', only Irssi color
#                 formats are allowed. If you don't know the color formats
#                 by heart, you can take a look at the formats documentation.
#                 You will find the proper docs on http://www.irssi.org/docs.
#
#    Setting:     trackbar_string
#    Description: This is the string that your line will display. This can
#                 be multiple characters or just one. For example: '~-~-'
#                 The default setting is '-'.
#
#    Setting:     trackbar_use_status_window
#    Description: If this setting is set to OFF, Irssi won't print a trackbar
#                 in the statuswindow
#
#    Setting:     trackbar_ignore_windows
#    Description: A list of windows where no trackbar should be printed
#
#    Setting:     trackbar_print_timestamp
#    Description: If this setting is set to ON, Irssi will print the formatted
#                 timestamp in front of the trackbar.
#
#    Setting:     trackbar_require_seen
#    Description: Only clear the trackbar if it has been scrolled to.
#
#     /mark is a command that will redraw the line at the bottom.
#
#    Command:     /trackbar, /trackbar goto
#    Description: Jump to where the trackbar is, to pick up reading
#
#    Command:     /trackbar keep
#    Description: Keep this window's trackbar where it is the next time
#                 you switch windows (then this flag is cleared again)
#
#    Command:     /mark, /trackbar mark
#    Description: Remove the old trackbar and mark the bottom of this
#                 window with a new trackbar
#
#    Command:     /trackbar markvisible
#    Description: Like mark for all visible windows
#
#    Command:     /trackbar markall
#    Description: Like mark for all windows
#
#    Command:     /trackbar remove
#    Description: Remove this window's trackbar
#
#    Command:     /trackbar removeall
#    Description: Remove all windows' trackbars
#
#    Command:     /trackbar redraw
#    Description: Force redraw of trackbars
#


# For bugreports and other improvements contact one of the authors.
#
#    This program is free software; you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation; either version 2 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this script; if not, write to the Free Software
#    Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA
#
##

use strict;
use warnings;
use Irssi;
use Irssi::TextUI;
use Encode;

use POSIX qw(strftime);
use vars qw($VERSION %IRSSI);

$VERSION = "2.2"; # cb3189a33c8e5f9

%IRSSI = (
    authors     => 'Peter Leurs and Geert Hauwaerts',
    contact     => 'peter@pfoe.be',
    patchers    => 'Johan Kiviniemi (UTF-8), Uwe Dudenhoeffer (on-upgrade-remove-line)',
    name        => 'trackbar',
    description => 'Shows a bar where you have last read a window.',
    license     => 'GNU General Public License',
    url         => 'http://www.pfoe.be/~peter/trackbar/',
    changed     => 'Fri Jan 23 23:59:11 2004',
    commands    => 'trackbar',
);

## Comments and remarks.
#
# This script uses settings.
# Use /SET  to change the value or /TOGGLE to switch it on or off.
#
#
#    Tip:     The command 'trackbar' is very usefull if you bind that to a key,
#             so you can easily jump to the trackbar. Please see 'help bind' for
#             more information about keybindings in Irssi.
#
#    Command: /BIND meta2-P key F1
#             /BIND F1 command trackbar
#
##

## Bugfixes and new items in this rewrite.
#
# * Remove all the trackbars before upgrading.
# * New setting trackbar_use_status_window to control the statuswindow trackbar.
# * New setting trackbar_print_timestamp to print a timestamp or not.
# * New command 'trackbar' to scroll up to the trackbar.
# * When resizing your terminal, Irssi will update all the trackbars to the new size.
# * When changing trackbar settings, change all the trackbars to the new settings.
# * New command 'trackbar mark' to draw a new trackbar (The old '/mark').
# * New command 'trackbar markall' to draw a new trackbar in each window.
# * New command 'trackbar remove' to remove the trackbar from the current window.
# * New command 'trackbar removeall' to remove all the trackbars.
# * Don't draw a trackbar in empty windows.
# * Added a version check to prevent Irssi redraw errors.
# * Fixed a bookmark NULL versus 0 bug.
# * Fixed a remove-line bug in Uwe Dudenhoeffer his patch.
# * New command 'help trackbar' to display the trackbar commands.
# * Fixed an Irssi startup bug, now processing each auto-created window.
#
##

## Known bugs and the todolist.
#
#    Todo: * Instead of drawing a line, invert the line.
#
##

sub cmd_help {
    my ($args) = @_;
    if ($args =~ /^trackbar *$/i) {
        print CLIENTCRAP <<HELP
%9Syntax:%9

TRACKBAR
TRACKBAR GOTO
TRACKBAR KEEP
TRACKBAR MARK
TRACKBAR MARKVISIBLE
TRACKBAR MARKALL
TRACKBAR REMOVE
TRACKBAR REMOVEALL
TRACKBAR REDRAW

%9Parameters:%9

    GOTO:        Jump to where the trackbar is, to pick up reading
    KEEP:        Keep this window's trackbar where it is the next time
                 you switch windows (then this flag is cleared again)
    MARK:        Remove the old trackbar and mark the bottom of this
                 window with a new trackbar
    MARKVISIBLE: Like mark for all visible windows
    MARKALL:     Like mark for all windows
    REMOVE:      Remove this window's trackbar
    REMOVEALL:   Remove all windows' trackbars
    REDRAW:      Force redraw of trackbars

%9Description:%9

    Manage a trackbar. Without arguments, it will scroll up to the trackbar.

%9Examples:%9

    /TRACKBAR MARK
    /TRACKBAR REMOVE
HELP
    }
}

Irssi::theme_register([
    'trackbar_loaded', '%R>>%n %_Scriptinfo:%_ Loaded $0 version $1 by $2.',
    'trackbar_wrong_version', '%R>>%n %_Trackbar:%_ Please upgrade your client to 0.8.17 or above if you would like to use this feature of trackbar.',
    'trackbar_all_removed', '%R>>%n %_Trackbar:%_ All the trackbars have been removed.',
    'trackbar_not_found', '%R>>%n %_Trackbar:%_ No trackbar found in this window.',
]);

my $old_irssi = Irssi::version < 20140701;
sub check_version {
    if ($old_irssi) {
        Irssi::printformat(MSGLEVEL_CLIENTCRAP, 'trackbar_wrong_version');
        return;
    } else {
        return 1;
    }
}

sub is_utf8 {
    lc Irssi::settings_get_str('term_charset') eq 'utf-8'
}

my (%config, %keep_trackbar, %unseen_trackbar);

sub remove_one_trackbar {
    my $win = shift;
    my $view = shift || $win->view;
    my $line = $view->get_bookmark('trackbar');
    if (defined $line) {
        my $bottom = $view->{bottom};
        $view->remove_line($line);
        $win->command('^scrollback end') if $bottom && !$win->view->{bottom};
        $view->redraw;
    }
}

sub add_one_trackbar {
    my $win = shift;
    my $view = shift || $win->view;
    $win->print(line($win->{width}), MSGLEVEL_NEVER);
    $view->set_bookmark_bottom('trackbar');
    $unseen_trackbar{ $win->{_irssi} } = 1;
    $view->redraw;
}

sub update_one_trackbar {
    my $win = shift;
    my $view = shift || $win->view;
    my $force = shift;
    my $ignored = win_ignored($win, $view);
    remove_one_trackbar($win, $view)
	if $force || !defined $force || !$ignored;
    add_one_trackbar($win, $view)
	if $force || !$ignored;
}

sub win_ignored {
    my $win = shift;
    my $view = shift || $win->view;
    return 1 unless $view->{buffer}{lines_count};
    return 1 if $win->{name} eq '(status)' && !$config{use_status_window};
    return 1 if grep { $win->{name} eq $_ || $win->{refnum} eq $_
			   || $win->get_active_name eq $_ } @{ $config{ignore_windows} };
    return 0;
}

sub sig_window_changed {
    my ($newwindow, $oldwindow) = @_;
    return unless $oldwindow;
    trackbar_update_seen($newwindow);
    return if delete $keep_trackbar{ $oldwindow->{_irssi} };
    trackbar_update_seen($oldwindow);
    return if $config{require_seen} && $unseen_trackbar{ $oldwindow->{_irssi } };
    update_one_trackbar($oldwindow, undef, 0);
}

sub trackbar_update_seen {
    my $win = shift;
    return unless $win;
    my $view = $win->view;
    my $line = $view->get_bookmark('trackbar');
    unless ($line) {
        delete $unseen_trackbar{ $win->{_irssi} };
        return;
    }
    my $startline = $view->{startline};
    return unless $startline;

    if ($startline->{info}{time} < $line->{info}{time}
            || $startline->{_irssi} == $line->{_irssi}) {
        delete $unseen_trackbar{ $win->{_irssi} };
    }
}

sub screen_length;
{ local $@;
  eval { require Text::CharWidth; };
  unless ($@) {
      *screen_length = sub { Text::CharWidth::mbswidth($_[0]) };
  }
  else {
      *screen_length = sub {
          my $temp = shift;
          if (is_utf8()) {
              Encode::_utf8_on($temp);
          }
          length($temp)
      };
  }
}

{ my %strip_table = (
    (map { $_ => '' } (split //, '04261537' .  'kbgcrmyw' . 'KBGCRMYW' . 'U9_8I:|FnN>#[' . 'pP')),
    (map { $_ => $_ } (split //, '{}%')),
   );
  sub c_length {
      my $o = Irssi::strip_codes($_[0]);
      $o =~ s/(%(%|Z.{6}|z.{6}|X..|x..|.))/exists $strip_table{$2} ? $strip_table{$2} :
          $2 =~ m{x(?:0[a-f]|[1-6][0-9a-z]|7[a-x])|z[0-9a-f]{6}}i ? '' : $1/gex;
      screen_length($o)
  }
}

sub line {
    my ($width, $time)  = @_;
    my $string = $config{string};
    $string = ' ' unless length $string;
    $time ||= time;

    Encode::_utf8_on($string);
    my $length = c_length($string);

    my $format = '';
    if ($config{print_timestamp}) {
        $format = $config{timestamp_str};
        $format =~ y/%/\01/;
        $format =~ s/\01\01/%/g;
        $format = strftime($format, localtime $time);
        $format =~ y/\01/%/;
    }

    my $times = $width / $length;
    $times += 1 if $times != int $times;
    $format .= $config{style};
    $width -= c_length($format);
    $string x= $times;
    chop $string while length $string && c_length($string) > $width;
    return $format . $string;
}

sub remove_all_trackbars {
    for my $window (Irssi::windows) {
        next unless ref $window;
        remove_one_trackbar($window);
    }
}

sub UNLOAD {
    remove_all_trackbars();
}

sub redraw_trackbars {
    return unless check_version();
    for my $win (Irssi::windows) {
        next unless ref $win;
        my $view = $win->view;
        my $line = $view->get_bookmark('trackbar');
        next unless $line;
        my $bottom = $view->{bottom};
        $win->print_after($line, MSGLEVEL_NEVER, line($win->{width}, $line->{info}{time}),
                          $line->{info}{time});
        $view->set_bookmark('trackbar', $win->last_line_insert);
        $view->redraw;
        $view->remove_line($line);
        $win->command('^scrollback end') if $bottom && !$win->view->{bottom};
        $view->redraw;
    }
}

sub goto_trackbar {
    my $win = Irssi::active_win;
    my $line = $win->view->get_bookmark('trackbar');

    if ($line) {
        $win->command("scrollback goto ". strftime("%d %H:%M:%S", localtime($line->{info}{time})));
    } else {
        $win->printformat(MSGLEVEL_CLIENTCRAP, 'trackbar_not_found');
    }
}

sub cmd_mark {
    update_one_trackbar(Irssi::active_win, undef, 1);
}

sub cmd_markall {
    for my $window (Irssi::windows) {
        next unless ref $window;
        update_one_trackbar($window);
    }
}

sub signal_stop {
    Irssi::signal_stop;
}

sub cmd_markvisible {
    my @wins = Irssi::windows;
    my $awin =
        my $bwin = Irssi::active_win;
    my $awin_counter = 0;
    Irssi::signal_add_priority('window changed' => 'signal_stop', -99);
    do {
        Irssi::active_win->command('window up');
        $awin = Irssi::active_win;
        update_one_trackbar($awin);
        ++$awin_counter;
    } until ($awin->{refnum} == $bwin->{refnum} || $awin_counter >= @wins);
    Irssi::signal_remove('window changed' => 'signal_stop');
}

sub cmd_trackbar_remove_one {
    remove_one_trackbar(Irssi::active_win);
}

sub cmd_remove_all_trackbars {
    remove_all_trackbars();
    Irssi::printformat(MSGLEVEL_CLIENTCRAP, 'trackbar_all_removed');
}

sub cmd_keep_once {
    $keep_trackbar{ Irssi::active_win->{_irssi} } = 1;
}

sub trackbar_runsub {
    my ($data, $server, $item) = @_;
    $data =~ s/\s+$//g;

    if ($data) {
        Irssi::command_runsub('trackbar', $data, $server, $item);
    } else {
        goto_trackbar();
    }
}

sub update_config {
    my $was_status_window = $config{use_status_window};
    $config{style} = Irssi::settings_get_str('trackbar_style');
    $config{string} = Irssi::settings_get_str('trackbar_string');
    $config{require_seen} = Irssi::settings_get_bool('trackbar_require_seen');
    $config{ignore_windows} = [ split /[,\s]+/, Irssi::settings_get_str('trackbar_ignore_windows') ];
    $config{use_status_window} = Irssi::settings_get_bool('trackbar_use_status_window');
    $config{print_timestamp} = Irssi::settings_get_bool('trackbar_print_timestamp');
    if (defined $was_status_window && $was_status_window != $config{use_status_window}) {
        if (my $swin = Irssi::window_find_name('(status)')) {
            if ($config{use_status_window}) {
                update_one_trackbar($swin);
            }
            else {
                remove_one_trackbar($swin);
            }
        }
    }
    if ($config{print_timestamp}) {
        my $ts_format = Irssi::settings_get_str('timestamp_format');
        my $ts_theme = Irssi::current_theme->get_format('fe-common/core', 'timestamp');
        my $render_str = Irssi::current_theme->format_expand($ts_theme);
        (my $ts_escaped = $ts_format) =~ s/([%\$])/$1$1/g;
        $render_str =~ s/(?|\$(.)(?!\w)|\$\{(\w+)\})/$1 eq 'Z' ? $ts_escaped : $1/ge;
        $config{timestamp_str} = $render_str;
    }
    redraw_trackbars() unless $old_irssi;
}

Irssi::settings_add_str('trackbar', 'trackbar_string', is_utf8() ? "\x{2500}" : '-');
Irssi::settings_add_str('trackbar', 'trackbar_style', '%K');
Irssi::settings_add_str('trackbar', 'trackbar_ignore_windows', '');
Irssi::settings_add_bool('trackbar', 'trackbar_use_status_window', 1);
Irssi::settings_add_bool('trackbar', 'trackbar_print_timestamp', 0);
Irssi::settings_add_bool('trackbar', 'trackbar_require_seen', 0);

update_config();

Irssi::signal_add_last( 'mainwindow resized' => 'redraw_trackbars')
    unless $old_irssi;

Irssi::signal_register({'gui page scrolled' => [qw/Irssi::UI::Window/]});
Irssi::signal_add_last('gui page scrolled' => 'trackbar_update_seen');

Irssi::signal_add('setup changed' => 'update_config');
Irssi::signal_add_priority('session save' => 'remove_all_trackbars', Irssi::SIGNAL_PRIORITY_HIGH-1);

Irssi::signal_add('window changed' => 'sig_window_changed');

Irssi::command_bind('trackbar goto'      => 'goto_trackbar');
Irssi::command_bind('trackbar keep'      => 'cmd_keep_once');
Irssi::command_bind('trackbar mark'      => 'cmd_mark');
Irssi::command_bind('trackbar markvisible' => 'cmd_markvisible');
Irssi::command_bind('trackbar markall'   => 'cmd_markall');
Irssi::command_bind('trackbar remove'    => 'cmd_trackbar_remove_one');
Irssi::command_bind('trackbar removeall' => 'cmd_remove_all_trackbars');
Irssi::command_bind('trackbar redraw'    => 'redraw_trackbars');
Irssi::command_bind('trackbar'           => 'trackbar_runsub');
Irssi::command_bind('mark'               => 'cmd_mark');
Irssi::command_bind_last('help' => 'cmd_help');

Irssi::printformat(MSGLEVEL_CLIENTCRAP, 'trackbar_loaded', $IRSSI{name}, $VERSION, $IRSSI{authors});
