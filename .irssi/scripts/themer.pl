# For example '/theme fe-common/core nick_changed old_nick new_nick'

use strict;
use warnings;
use Irssi;
use vars qw($VERSION %IRSSI);

$VERSION = '1.0.0';
%IRSSI = (
  authors     => 'Michael Carlberg',
  contact     => 'jaagr@freenode#irssi',
  name        => 'themer',
  description => 'Utility commands used for theme development.',
  license     => 'GNU General Public License',
);


sub format {
  my ($module, $format, @replacements) = split(/ /, $_[0]);
  {
    local *CORE::GLOBAL::caller = sub { $module };
    *CORE::GLOBAL::caller if 0; # Suppress 'once' warning
    Irssi::active_win()->printformat(Irssi::MSGLEVEL_CLIENTCRAP, $format, @replacements);
  }
}

Irssi::command_bind('themer_format', 'format');


sub reload {
  Irssi::command('script load themer.pl');
  Irssi::themes_reload();
}

Irssi::command_bind('themer_reload', 'reload');


sub reload_exec {
  reload();
  Irssi::command($_[0]);
}

Irssi::command_bind('themer_reload_exec', 'reload_exec');


sub debug {
  reload();

  Irssi::command('script load timer.pl');

  Irssi::command('timer stop themer');
  Irssi::command('timer add themer 1 360 /themer_reload_exec themer_format fe-common/core nick_changed abcdefghijklmnopqrstuvwxyz 1234567890123456789012345');

  Irssi::command('timer stop themer2');
  Irssi::command('timer add themer2 1 360 /themer_reload_exec themer_format fe-common/core join jaagr');

  Irssi::command('timer stop themer3');
  Irssi::command('timer add themer3 1 360 /themer_reload_exec themer_format fe-common/core kick kicked_nick');

  Irssi::command('timer stop themer4');
  Irssi::command('timer add themer4 1 360 /themer_reload_exec themer_format fe-common/core pubmsg_me jaagr testing testing');
}

Irssi::command_bind('themer_debug', 'debug');
