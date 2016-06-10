=pod

=head1 NAME

uberprompt.pl

=head1 DESCRIPTION

This script replaces the default prompt status-bar item with one capable of
displaying additional information, under either user control or via scripts.

=head1 INSTALLATION

Copy into your F<~/.irssi/scripts/> directory and load with
C</SCRIPT LOAD F<filename>>.

It is recommended that you make it autoload in one of the
L<usual ways|https://github.com/shabble/irssi-docs/wiki/Guide#Autorunning_Scripts>.

=head1 SETUP

If you have a custom prompt format, you may need to copy it to the
uberprompt_format setting. See below for details.

=head1 USAGE

Although the script is designed primarily for other scripts to set
status information into the prompt, the following commands are available:

=over 4

=item * C</prompt set [-inner|-pre|-post|only] E<lt>msgE<gt>>

Sets the prompt to the given argument. Any use of C<$p> in the argument will
be replaced by the original prompt content.

A parameter corresponding to the C<UP_*> constants listed below is required, in
the format C</prompt set -inner Hello!>

=item * C</prompt clear>

Clears the additional data provided to the prompt.

=item * C</prompt on>

Eenables the uberprompt (things may get confused if this is used
whilst the prompt is already enabled)

=item * C</prompt off>

Restore the original irssi prompt and prompt_empty statusbars.  unloading the
script has the same effect.

=item * C</help prompt>

show help for uberprompt commands

=back

=head1 SETTINGS

=head2 UBERPROMPT FORMAT

C</set uberprompt_format E<lt>formatE<gt>>

The default is C<[$*$uber]>, which is the same as the default provided in
F<default.theme>.

Changing this setting will update the prompt immediately, unlike editing your theme.

An additional variable available within this format is C<$uber>, which expands to
the content of prompt data provided with the C<UP_INNER> or C</prompt set -inner>
placement argument.

For all other placement arguments, it will expand to the empty string.

B<Note:> This setting completely overrides the C<prompt="...";> line in your
.theme file, and may cause unexpected behaviour if your theme wishes to set a
different form of prompt. It can be simply copied from the theme file into the
above setting.

=head2 OTHER SETTINGS

=over 4

=item * C<uberprompt_autostart>

Boolean value, which determines if uberprompt should enable itself automatically
upon loading.  If Off, it must be enabled manually with C</prompt on>.  Defaults to On.

=item * C<uberprompt_debug>

Boolean value, which determines if uberprompt should print debugging information.
Defaults to Off, and should probably be left that way unless requested for bug-tracing
purposes.

=item * C<uberprompt_format>

String value containing the format-string which uberprompt uses to display the
prompt. Defaults to "C<[$*$uber] >", where C<$*> is the content the prompt would
normally display, and C<$uber> is a placeholder variable for dynamic content, as
described in the section above.

=item * C<uberprompt_load_hook>

String value which can contain one or more commands to be run whenever the uberprompt
is enabled, either via autostart, or C</prompt on>. Defaults to the empty string, in
which case no commands are run.  Some examples include:

C</set uberprompt_load_hook /echo prompt enabled> or

C</^sbar prompt add -after input vim_mode> for those using vim_mode.pl who want
the command status indicator on the prompt line.

=item * C<uberprompt_unload_hook>

String value, defaulting to the empty string, which can contain commands which
are executed when the uberprompt is disabled, either by unloading the script,
or by the command C</prompt off>.

=item * C<uberprompt_use_replaces>

Boolean value, defaults to Off. If enabled, the format string for the prompt
will be subject to the I<replaces> section of the theme.  The most obvious
effect of this is that bracket characters C<[ ]> are displayed in a different
colour, typically quite dark.

=back

B<Note:> For both C<uberprompt_*_hook> settings above, multiple commands can
be chained together in the form C</eval /^cmd1 ; /^cmd2>. The C<^> prevents
any output from the commands (such as error messages) being displayed.

=head2 SCRIPTING USAGE

The primary purpose of uberprompt is to be used by other scripts to
display information in a way that is not possible by printing to the active
window or using statusbar items.

The content of the prompt can be set from other scripts via the C<"change prompt">
signal.

For Example:

    signal_emit 'change prompt' 'some_string', UberPrompt::UP_INNER;

will set the prompt to include that content, by default 'C<[$* some_string]>'

The possible position arguments are the following strings:

=over 4

=item * C<UP_PRE>   - place the provided string before the prompt - C<$string$prompt>

=item * C<UP_INNER> - place the provided string inside the prompt - C<{prompt $* $string}>

=item * C<UP_POST>  - place the provided string after the prompt  - C<$prompt$string>

=item * C<UP_ONLY>  - replace the prompt with the provided string - C<$string>

=back

All strings may use the special variable 'C<$prompt>' to include the prompt
verbatim at that position in the string.  It is probably only useful for
the C<UP_ONLY> mode however. '$C<prompt_nt>' will include the prompt, minus any
trailing whitespace.

=head2 CHANGE NOTIFICATIONS

You can also be notified when the prompt changes in response to the previous
signal or manual C</prompt> commands via:

    signal_add 'prompt changed', sub { my ($text, $len) = @_; ... do something ... };

This callback will occur whenever the contents of the prompt is changed.


=head2 NOTES FOR SCRIPT WRITERS:

The following code snippet can be used within your own script as a preamble
to ensure that uberprompt is loaded before your script to avoid
any issues with loading order.  It first checks if uberprompt is loaded, and
if not, attempts to load it.  If the load fails, the script will die
with an error message, otherwise it will call your app_init() function.

I<---- start of snippet ---->

    my $DEBUG_ENABLED = 0;
    sub DEBUG () { $DEBUG_ENABLED }

    # check we have uberprompt loaded.

    sub script_is_loaded {
       return exists($Irssi::Script::{$_[0] . '::'});
    }

    if (not script_is_loaded('uberprompt')) {

        print "This script requires 'uberprompt.pl' in order to work. "
          . "Attempting to load it now...";

        Irssi::signal_add('script error', 'load_uberprompt_failed');
        Irssi::command("script load uberprompt.pl");

        unless(script_is_loaded('uberprompt')) {
            load_uberprompt_failed("File does not exist");
        }
        app_init();
    } else {
        app_init();
    }

    sub load_uberprompt_failed {
        Irssi::signal_remove('script error', 'load_uberprompt_failed');

        print "Script could not be loaded. Script cannot continue. "
          . "Check you have uberprompt.pl installed in your path and "
            .  "try again.";

        die "Script Load Failed: " . join(" ", @_);
    }

I<---- end of snippet ---->

=head1 AUTHORS

Copyright E<copy> 2011 Tom Feist C<E<lt>shabble+irssi@metavore.orgE<gt>>

=head1 LICENCE

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

=head1 BUGS

=over 4

=item * 

Resizing the terminal rapidly whilst using this script in debug mode may cause
irssi to crash. See bug report at http://bugs.irssi.org/index.php?do=details&task_id=772 for details.

=back

=head1 TODO

=over 4

=item * report failure (somehow) to clients if hte prompt is disabled.

=item * fix issue at autorun startup with sbar item doesn't exist.

=back

=cut

use strict;
use warnings;

use Irssi;
use Irssi::TextUI;
use Data::Dumper;

{ package Irssi::Nick } # magic.

our $VERSION = "0.2";
our %IRSSI =
  (
   authors         => "shabble",
   contact         => 'shabble+irssi@metavore.org, shabble@#irssi/Freenode',
   name            => "uberprompt",
   description     => "Helper script for dynamically adding text "
   . "into the input-bar prompt.",
   license         => "MIT",
   changed         => "24/7/2010"
  );


my $DEBUG_ENABLED = 0;
sub DEBUG { $DEBUG_ENABLED }

my $prompt_data     = '';
my $prompt_data_pos = 'UP_INNER';

my $prompt_last         = '';
my $prompt_format       = '';
my $prompt_format_empty = '';

# flag to indicate whether rendering of hte prompt should allow the replaces
# theme formats to be applied to the content.
my $use_replaces = 0;
my $trim_data    = 0;

my $emit_request = 0;

my $expando_refresh_timer;
my $expando_vars = {};

my $init_callbacks = {load => '', unload => ''};

pre_init();

sub pre_init {
    Irssi::command('statusbar prompt reset');
    init();
}

sub prompt_subcmd_handler {
    my ($data, $server, $item) = @_;
    #$data =~ s/\s+$//g;         # strip trailing whitespace.
    Irssi::command_runsub('prompt', $data, $server, $item);
}

sub _error($) {
    my ($msg) = @_;
    Irssi::active_win->print($msg, MSGLEVEL_CLIENTERROR);
}

sub _debug_print($) {
    return unless DEBUG;
    my ($msg) = @_;
    Irssi::active_win->print($msg, MSGLEVEL_CLIENTCRAP);
}

sub _print_help {
    my ($args) = @_;
    if ($args =~ m/^\s*prompt/i) {
        my @help_lines =
          (
           "",
           "PROMPT ON",
           "PROMPT OFF",
           "PROMPT CLEAR",
           "PROMPT SET { -pre | -post | -only | -inner } <content>",
           "",
           "Commands for manipulating the UberPrompt.",
           "",
           "/PROMPT ON    enables uberprompt, replacing the existing prompt ",
           "              statusbar-item",
           "/PROMPT OFF   disables it, and restores the original prompt item",
           "/PROMPT CLEAR resets the value of any additional data set by /PROMPT SET",
           "              or a script",
           "/PROMPT SET   changes the contents of the prompt, according to the mode",
           "              and content provided.",
           "      { -inner sets the value of the \$uber psuedo-variable in the",
           "             /set uberprompt_format setting.",
           "      | -pre places the content before the current prompt string",
           "      | -post places the content after the prompt string",
           "      | -only replaces the entire prompt contents with the given string }",
           "",
           "See Also:",
           '',
           '/SET uberprompt_format       -- defaults to "[$*$uber] "',
           '/SET uberprompt_format_empty -- defaults to "[$*] "',
           "/SET uberprompt_autostart    -- determines whether /PROMPT ON is run",
           "                                automatically when the script loads",
           "/SET uberprompt_use_replaces -- toggles the use of the current theme",
           "                                \"replaces\" setting. Especially",
           "                                noticeable on brackets \"[ ]\" ",
           "/SET uberprompt_trim_data    -- defaults to off. Removes whitespace from",
           "                                both sides of the \$uber result.",
           "",
          );

        Irssi::print($_, MSGLEVEL_CLIENTCRAP) for @help_lines;
        Irssi::signal_stop;
    }
}

sub UNLOAD {
    deinit();
}

sub exp_lbrace() { '{' }
sub exp_rbrace() { '}' }

sub deinit {
    Irssi::expando_destroy('lbrace');
    Irssi::expando_destroy('rbrace');

    if (Irssi::settings_get_bool('uberprompt_restore_on_exit')) {
        # remove uberprompt and return the original ones.
        print "Removing uberprompt and restoring original";
        restore_prompt_items();
    }
}

sub init {
    Irssi::statusbar_item_register('uberprompt', 0, 'uberprompt_draw');

    # TODO: flags to prevent these from being recomputed?
    Irssi::expando_create('lbrace', \&exp_lbrace, {});
    Irssi::expando_create('rbrace', \&exp_rbrace, {});

    Irssi::settings_add_str ('uberprompt', 'uberprompt_format', '[$*$uber] ');
    Irssi::settings_add_str ('uberprompt', 'uberprompt_format_empty', '[$*] ');

    Irssi::settings_add_str ('uberprompt', 'uberprompt_load_hook',   '');
    Irssi::settings_add_str ('uberprompt', 'uberprompt_unload_hook', '');

    Irssi::settings_add_bool('uberprompt', 'uberprompt_debug', 0);
    Irssi::settings_add_bool('uberprompt', 'uberprompt_autostart', 1);
    Irssi::settings_add_bool ('uberprompt', 'uberprompt_restore_on_exit', 1);

    Irssi::settings_add_bool('uberprompt', 'uberprompt_use_replaces', 0);
    Irssi::settings_add_bool('uberprompt', 'uberprompt_trim_data', 0);

    Irssi::command_bind("prompt",     \&prompt_subcmd_handler);
    Irssi::command_bind('prompt on',  \&replace_prompt_items);
    Irssi::command_bind('prompt off', \&restore_prompt_items);
    Irssi::command_bind('prompt set', \&cmd_prompt_set);
    Irssi::command_bind('prompt clear',
                        sub {
                            Irssi::signal_emit 'change prompt', '$p', 'UP_POST';
                        });

    my $prompt_set_args_format = "inner pre post only";
    Irssi::command_set_options('prompt set', $prompt_set_args_format);

    Irssi::command_bind('help', \&_print_help);

    Irssi::signal_add('setup changed', \&reload_settings);

    # intialise the prompt format.
    reload_settings();

    # make sure we redraw when necessary.
    Irssi::signal_add('window changed',             \&uberprompt_refresh);
    Irssi::signal_add('window name changed',        \&uberprompt_refresh);
    Irssi::signal_add('window changed automatic',   \&uberprompt_refresh);
    Irssi::signal_add('window item changed',        \&uberprompt_refresh);
    Irssi::signal_add('window item server changed', \&uberprompt_refresh);
    Irssi::signal_add('window server changed',      \&uberprompt_refresh);
    Irssi::signal_add('server nick changed',        \&uberprompt_refresh);

    Irssi::signal_add('nick mode changed', \&refresh_if_me);

    # install our statusbars if required.
    if (Irssi::settings_get_bool('uberprompt_autostart')) {
        replace_prompt_items();
    }

    # API signals

    Irssi::signal_register({'change prompt' => [qw/string string/]});
    Irssi::signal_add('change prompt' => \&change_prompt_handler);

    # other scripts (specifically overlay/visual) can subscribe to
    # this event to be notified when the prompt changes.
    # arguments are new contents (string), new length (int)
    Irssi::signal_register({'prompt changed' => [qw/string int/]});
    Irssi::signal_register({'prompt length request' => []});

    Irssi::signal_add('prompt length request', \&length_request_handler);
}

sub cmd_prompt_set {
    my $args = shift;
    my @options_list = Irssi::command_parse_options "prompt set", $args;
    if (@options_list) {
        my ($options, $rest) = @options_list;

        my @opt_modes = keys %$options;
        if (@opt_modes != 1) {
            _error '%_/prompt set%_ must specify exactly one mode of'
              . ' {-inner, -only, -pre, -post}';
            return;
        }

        my $mode = 'UP_' . uc($opt_modes[0]);

        Irssi::signal_emit 'change prompt', $rest, $mode;
    } else {
        _error ('%_/prompt set%_ must specify a mode {-inner, -only, -pre, -post}');
    }
}

sub refresh_if_me {
    my ($channel, $nick) = @_;

    return unless $channel and $nick;

    my $server = Irssi::active_server;
    my $window = Irssi::active_win;

    return unless $server and $window;

    my $my_chan = $window->{active}->{name};
    my $my_nick = $server->parse_special('$N');

    return unless $my_chan and $my_nick;

    _debug_print "Chan: $channel->{name}, "
     . "nick: $nick->{nick}, "
     . "me: $my_nick, chan: $my_chan";

    if ($my_chan eq $channel->{name} and $my_nick eq $nick->{nick}) {
        uberprompt_refresh();
    }
}

sub length_request_handler {
    $emit_request = 1;
    uberprompt_render_prompt();
    $emit_request = 0;
}

sub reload_settings {

    $use_replaces  = Irssi::settings_get_bool('uberprompt_use_replaces');
    $DEBUG_ENABLED = Irssi::settings_get_bool('uberprompt_debug');

    $init_callbacks = {
                       load   => Irssi::settings_get_str('uberprompt_load_hook'),
                       unload => Irssi::settings_get_str('uberprompt_unload_hook'),
                      };

    if (DEBUG) {
        Irssi::signal_add 'prompt changed', 'debug_prompt_changed';
    } else {
        Irssi::signal_remove 'prompt changed', 'debug_prompt_changed';
    }

    my $new = Irssi::settings_get_str('uberprompt_format');

    if ($prompt_format ne $new) {
        _debug_print("Updated prompt format");
        $prompt_format = $new;
        $prompt_format =~ s/\$uber/\$\$uber/;
        Irssi::abstracts_register(['uberprompt', $prompt_format]);

        $expando_vars = {};

        # TODO: something clever here to check if we need to schedule
        # an update timer or something, rather than just refreshing on
        # every possible activity in init()
        while ($prompt_format =~ m/(?<!\$)(\$[A-Za-z,.:;][a-z_]*)/g) {
            _debug_print("Detected Irssi expando variable $1");
            my $var_name = substr $1, 1; # strip the $
            $expando_vars->{$var_name} = Irssi::parse_special($1);
        }
    }

    $new = Irssi::settings_get_str('uberprompt_format_empty');

    if ($prompt_format_empty ne $new) {
        _debug_print("Updated prompt format");
        $prompt_format_empty = $new;
        $prompt_format_empty =~ s/\$uber/\$\$uber/;
        Irssi::abstracts_register(['uberprompt_empty', $prompt_format_empty]);

        $expando_vars = {};

        # TODO: something clever here to check if we need to schedule
        # an update timer or something, rather than just refreshing on
        # every possible activity in init()
        while ($prompt_format_empty =~ m/(?<!\$)(\$[A-Za-z,.:;][a-z_]*)/g) {
            _debug_print("Detected Irssi expando variable $1");
            my $var_name = substr $1, 1; # strip the $
            $expando_vars->{$var_name} = Irssi::parse_special($1);
        }
    }

    $trim_data = Irssi::settings_get_bool('uberprompt_trim_data');
}

sub debug_prompt_changed {
    my ($text, $len) = @_;

    $text =~ s/%/%%/g;

    print "DEBUG_HANDLER: Prompt Changed to: \"$text\", length: $len";
}

sub change_prompt_handler {
    my ($text, $pos) = @_;

    # fix for people who used prompt_info and hence the signal won't
    # pass the second argument.
    $pos = 'UP_INNER' unless defined $pos;
    _debug_print("Got prompt change signal with: $text, $pos");

    my ($changed_text, $changed_pos);
    $changed_text = defined $prompt_data     ? $prompt_data     ne $text : 1;
    $changed_pos  = defined $prompt_data_pos ? $prompt_data_pos ne $pos  : 1;

    $prompt_data     = $text;
    $prompt_data_pos = $pos;

    if ($changed_text || $changed_pos) {
        _debug_print("Redrawing prompt");
        uberprompt_refresh();
    }
}

sub _escape_prompt_special {
    my $str = shift;
    $str =~ s/\$/\$\$/g;
    $str =~ s/\\/\\\\/g;
    #$str =~ s/%/%%/g;
    $str =~ s/{/\${lbrace}/g;
    $str =~ s/}/\${rbrace}/g;

    return $str;
}

sub uberprompt_render_prompt {

    my $window = Irssi::active_win;
    my $prompt_arg = '';

    # default prompt sbar arguments (from config)
    if (scalar( () = $window->items )) {
        $prompt_arg = '$[.15]{itemname}';
    } else {
        $prompt_arg = '${winname}';
    }

    my $prompt = '';            # rendered content of the prompt.
    my $theme  = Irssi::current_theme;

    my $arg = $use_replaces ? 0 : Irssi::EXPAND_FLAG_IGNORE_REPLACES;

    if ($prompt_data && (!$trim_data || trim($prompt_data))) {
      $prompt = $theme->format_expand("{uberprompt $prompt_arg}", $arg);
    }
    else {
      $prompt = $theme->format_expand("{uberprompt_empty $prompt_arg}", $arg);
    }

    if ($prompt_data_pos eq 'UP_ONLY') {
        $prompt =~ s/\$\$uber//; # no need for recursive prompting, I hope.

        # TODO: only compute this if necessary?
        my $prompt_nt = $prompt;
        $prompt_nt =~ s/\s+$//;

        my $pdata_copy = $prompt_data;

        $pdata_copy =~ s/\$prompt_nt/$prompt_nt/;
        $pdata_copy =~ s/\$prompt/$prompt/;

        $prompt = $pdata_copy;

    } elsif ($prompt_data_pos eq 'UP_INNER' && defined $prompt_data) {

        my $esc = _escape_prompt_special($prompt_data);
        $esc = $trim_data ? trim($esc) : $esc;
        $prompt =~ s/\$\$uber/$esc/;

    } else {
        # remove the $uber marker
        $prompt =~ s/\$\$uber//;

        # and add the additional text at the appropriate position.
        if ($prompt_data_pos eq 'UP_PRE') {
            $prompt = $prompt_data . $prompt;
        } elsif ($prompt_data_pos eq 'UP_POST') {
            $prompt .= $prompt_data;
        }
    }

    _debug_print("rendering with: $prompt");


    if (($prompt ne $prompt_last) or $emit_request) {

        # _debug_print("Emitting prompt changed signal");
        # my $exp = Irssi::current_theme()->format_expand($text, 0);
        my $ps = Irssi::parse_special($prompt);

        Irssi::signal_emit('prompt changed', $ps, length($ps));
        $prompt_last = $prompt;
    }
    return $prompt;
}

sub uberprompt_draw {
    my ($sb_item, $get_size_only) = @_;

    my $prompt = uberprompt_render_prompt();

    my $ret = $sb_item->default_handler($get_size_only, $prompt, '', 0);
    _debug_print("redrawing with: $prompt");
    return $ret;
}

sub uberprompt_refresh {
    Irssi::statusbar_items_redraw('uberprompt');
}

sub replace_prompt_items {
    # remove existing ones.
    _debug_print("Removing original prompt");

    _sbar_command('prompt', 'remove', 'prompt');
    _sbar_command('prompt', 'remove', 'prompt_empty');

    # add the new one.

    _sbar_command('prompt', 'add', 'uberprompt',
                  qw/-alignment left -before input -priority '-1'/);

    _sbar_command('prompt', 'position', '100');

    my $load_hook = $init_callbacks->{load};
    if (defined $load_hook and length $load_hook) {
        eval {
            Irssi::command($load_hook);
        };
        if ($@) {
            _error("Uberprompt user load-hook command ($load_hook) failed: $@");
        }
    }

}

sub restore_prompt_items {

    _sbar_command('prompt', 'remove', 'uberprompt');

    _debug_print("Restoring original prompt");

    _sbar_command('prompt', 'reset');

    my $unload_hook = $init_callbacks->{unload};

    if (defined $unload_hook and length $unload_hook) {
        eval {
            Irssi::command($unload_hook);
        };
        if ($@) {
            _error("Uberprompt user unload-hook command ($unload_hook) failed: $@");
        }
    }
}

sub _sbar_command {
    my ($bar, $cmd, $item, @args) = @_;

    my $args_str = join ' ', @args;

    $args_str .= ' ' if length $args_str && defined $item;

    my $command = sprintf 'STATUSBAR %s %s %s%s',
     $bar, $cmd, $args_str, defined $item ? $item : '';

    _debug_print("Running command: $command");
    Irssi::command($command);
}

sub trim {
    my $string = shift;

    $string =~ s/^\s*//;
    $string =~ s/\s*$//;

    return $string;
}
