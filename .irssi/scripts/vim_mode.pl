=pod

=head1 NAME

vim_mode.pl

=head1 DESCRIPTION

An Irssi script to emulate some of the vi(m) features for the Irssi inputline.

=head1 INSTALLATION

Copy into your F<~/.irssi/scripts/> directory and load with
C</SCRIPT LOAD vim_mode.pl>. You may wish to have it autoload in one of the
L<usual ways|https://github.com/shabble/irssi-docs/wiki/Guide#Autorunning_Scripts>.

=head2 DEPENDENCIES

For proper :ex mode support, vim-mode requires the installation of F<uberprompt.pl>
Uberprompt can be downloaded from:

L<https://github.com/shabble/irssi-scripts/raw/master/prompt_info/uberprompt.pl>

and follow the instructions at the top of that file for installation.

If you don't need Ex-mode, you can run vim_mode.pl without the
uberprompt.pl script, but it is strongly recommended that you use it.

=head3 Irssi requirements

0.8.12 and above should work fine. However the following features are
disabled in irssi < 0.8.13:

=over 4

=item * C<j> C<k> (only with count, they work fine without count in older versions)

=item * C<gg>, C<G>

=back

It is intended to work with at Irssi  0.8.12 and later versions. However some
features are disabled in older versions (see below for details).

Perl >= 5.8.1 is recommended for UTF-8 support (which can be disabled if
necessary).  Please report bugs in older versions as well, we'll try to fix
them.  Later versions of Perl are also faster, which is probably beneficial
to a script of this size and complexity.

=head2 SETUP

Vim Mode provides certain feedback to the user, such as the currently active
mode (command, insert, ex), and if switching buffers, which buffer(s) currently
match the search terms.

There are two ways to go about displaying this information, as described in
the following sections:

=head3 Statusbar Items

Run the following command to add a statusbar item that shows which mode
you're in.

C</statusbar window add vim_mode>

And the following to let C<:b [str]> display a list of channels matching your
search string.

C</statusbar window add vim_windows>

B<Note:> Remember to C</save> after adding these statusbar items to make them
permanent.

B<Note:> If you would rather have these statusbar items on your prompt
line rather than thte window statusbar, please follow these steps.

For technical reasons, I<uberprompt> must occasionally call C</statusbar prompt
reset>, which will remove or deactivate any manually added items on the prompt
statusbar.  To get around this, uberprompt provides two command hooks,
C<uberprompt_load_hook> and C<uberprompt_unload_hook>.  Both of these settings
can contain one (or more, using C</EVAL>) commands to be executed when the prompt
is enabled and disabled, respectively.

See the L<uberprompt documentation|https://github.com/shabble/irssi-scripts/blob/master/prompt_info/README.pod> for further details.

For I<right-aligned> items (that is, after the input field:

=over 4

=item 1 C</alias vm_add /^statusbar prompt add -after input -alignment right vim_mode>

=item 2 C</alias vm_del /^statusbar prompt remove vim_mode>

=item 3 C</set uberprompt_load_hook /^vm_add>

=item 4 C</set uberprompt_unload_hook /^vm_del>

=back

For I<left-aligned> items (before the prompt):

=over 4

=item 1 C</alias vm_add /^statusbar prompt add -before prompt -alignment left vim_mode>

=item 2 C</alias vm_del /^statusbar prompt remove vim_mode>

=item 3 C</set uberprompt_load_hook /^vm_add>

=item 4 C</set uberprompt_unload_hook /^vm_del>

=back

If you wish to add both C<vim_mode> and C<vim_windows> items, replace steps 1 and 2
above with the following (right-aligned):

=over 4

=item 1 C</alias vm_add /^eval /^statusbar prompt add -after input -alightment right vim_mode ; /^statusbar prompt add -after input -alignment right vim_windows>

=item 2 C</alias vm_del /^eval /^statusbar prompt remove vim_mode ; /^statusbar prompt remove vim_windows>

=back

and then complete stages 3 and 4 as above.  Replace the C<-after> and C<-alignment>
to suit your location preferences.

B<Note:> It is also possible to place the items between the prompt and input field,
by specifying C<-after prompt> or C<-before input> as appropriate.

=head3 Expando Variables

Vim mode augments the existing Irssi expando (automatic variables) with two
additional ones: C<$vim_cmd_mode> and C<$vim_wins>.

C<$vim_cmd_mode> is the equivalent of the C<vim_mode> statusbar item, and
C<$vim_wins> is the counterpart of C<vim_windows>.

They can be added to your theme, or inserted into your uberprompt using
a command such as:

"C</set uberprompt_format [$vim_cmd_mode] $*$uber] >"

=head3 FILE-BASED CONFIGURATION

Additionally to the irssi settings described in L<settings|/SETTINGS>, vim_mode
can be configured through an external configuration file named "vim_moderc"
located in F<~/.irssi/vim_moderc>. If available it's loaded on startup and every
supported ex-command is run. Its syntax is similar to "vimrc". To (re)load it
while vim_mode is running use C<:so[urce]>.

Currently Supported ex-commands:

=over 4

=item * C<:map>

=back

=head1 USAGE

The following section is divided into the different modes as supported by Vim itself:

=head2 COMMAND MODE

It supports most commonly used command mode features:

=over 2

=item * Insert/Command mode.

C<Esc> and C<Ctrl-C> enter command mode.  C</set vim_mode_cmd_seq j> allows
to use C<jj> as Escape (any other character can be used as well).

=item * Cursor motion:

C<h l 0 ^ $ E<lt>SpaceE<gt> E<lt>BSE<gt> f t F T>

=item * History motion:

C<j k gg G> C<gg> moves to the oldest (first) history line.  C<G> without a
count moves to the current input line, with a count it goes to the I<count-th>
history line (1 is the oldest).

=item * Cursor word motion:

C<w b ge e W gE B E>

=item * Word objects (only the following work yet):

C<aw aW>

=item * Yank and paste:

 C<y p P>

=item * Change and delete:

C<c d>

=item * Delete at cursor:

C<x X>

=item * Replace at cursor:

C<r>

=item * Insert mode:

C<i a I A>

=item * Switch case:

C<~>

=item * Repeat change:

C<.>

=item * Repeat

C<ftFT: ; ,>

=item * Registers:

C<"a-"z "" "0 "* "+ "_> (black hole)

=item * Line-wise shortcuts:

C<dd cc yy>

=item * Shortcuts:

C<s S C D>

=item * Scroll the scrollback buffer:

C<Ctrl-E Ctrl-D Ctrl-Y Ctrl-U Ctrl-F Ctrl-B>

=item * Switch to last active window:

C<Ctrl-6/Ctrl-^>

=item * Switch split windows:

<Ctrl-W j Ctrl-W k>

=item * Undo/Redo:

C<u Ctrl-R>

=back

Counts and combinations work as well, e.g. C<d5fx> or C<3iabcE<lt>escE<gt>>. Counts also work with mapped ex-commands (see below), e.g. if you map C<gb> to do C<:bn>, then C<2gb> will switch to the second next buffer.  Repeat also supports counts.

=head3 REGISTERS

=over 4

=item * Appending to register with C<"A-"Z>

=item * C<""> is the default yank/delete register.

=item * C<"0> contains the last yank (if no register was specified).

=item * The special registers C<"* "+> both contain irssi's internal cut-buffer.

=back

=head2 INSERT MODE

The following insert mode mappings are supported:

=over 4

=item * Insert register content: Ctrl-R x (where x is the register to insert)

=back

=head2 EX-MODE

Ex-mode (activated by C<:> in command mode) supports the following commands:

=over 4

=item * Command History:

C<E<lt>uparrowE<gt>> - cycle backwards through history

C<E<lt>downarrowE<gt>> - cycle forwards through history

C<:eh> - show ex history

=item * Switching buffers:

C<:[N]b [N]> - switch to channel number

C<:b#>       - switch to last channel

C<:b> E<lt>partial-channel-nameE<gt>

C<:b> <partial-server>/<partial-channel>

C<:buffer {args}> (same as C<:b>)

C<:[N]bn[ext] [N]> - switch to next window

C<:[N]bp[rev] [N]> - switch to previous window

=item * Close window:

C<:[N]bd[elete] [N]>

=item * Display windows:

C<:ls>, C<:buffers>

=item * Display registers:

C<:reg[isters] {args}>, C<:di[splay] {args}>

=item * Display undolist:

C<:undol[ist]> (mostly used for debugging)

=item * Source files:

C<:so[urce]> - only sources vim_moderc at the moment,
                         F<{file}> not supported

=item * Mappings:

C<:map> - display custom mappings

=item * Saving mappings:

C<:mkv[imrc][!]> - like in Vim, but [file] not supported

=item * Substitution:

C<:s///> - I<i> and I<g> are supported as flags, only C<///> can be used as
eparator, and it uses Perl regex syntax instead of Vim syntax.

=item * Settings:

C<:se[t]> - display all options

C<:se[t] {option}>         - display all matching options

C<:se[t] {option} {value}> - change option to value

=back

=head3 MAPPINGS

=head4 Commands

=over 4

=item * C<:map {lhs}>       - display mappings starting with {lhs}

=item * C<:map {lhs} {rhs}> - add mapping

=item * C<:unm[ap] {lhs}>   - remove custom mapping

=back

=head4 Parameters

I<{lhs}> is the key combination to be mapped, I<{rhs}> the target. The
C<E<lt>E<gt>> notation is used

(e.g. C<E<lt>C-FE<gt>> is I<Ctrl-F>), case is ignored.
 Supported C<E<lt>E<gt>> keys are:

=over 4

=item * C<E<lt>C-AE<gt>> - C<E<lt>C-ZE<gt>>,

=item * C<E<lt>C-^E<gt>>, C<E<lt>C-6E<gt>>

=item * C<E<lt>SpaceE<gt>>

=item * C<E<lt>CRE<gt>> - Enter

=item * C<E<lt>BSE<gt>> - Backspace

=item * C<E<lt>NopE<gt>> - No-op (Do Nothing).

=back

Mapping ex-mode and irssi commands is supported. When mapping ex-mode commands
the trailing C<E<lt>CrE<gt>> is not necessary. Only default mappings can be used
in I<{rhs}>.

Examples:

=over 4

=item * C<:map w  W>      - to remap w to work like W

=item * C<:map gb :bnext> - to map gb to call :bnext

=item * C<:map gB :bprev>

=item * C<:map g1 :b 1>   - to map g1 to switch to buffer 1

=item * C<:map gb :b>     - to map gb to :b, 1gb switches to buffer 1, 5gb to 5

=item * C<:map E<lt>C-LE<gt> /clear> - map Ctrl-L to irssi command /clear

=item * C<:map E<lt>C-GE<gt> /window goto 1>

=item * C<:map E<lt>C-EE<gt> <Nop>> - disable E<lt>C-EE<gt>, it does nothing now

=item * C<:unmap E<lt>C-EE<gt>> - restore default behavior of C<E<lt>C-EE<gt>>
after disabling it

=back

Note that you must use C</> for irssi commands (like C</clear>), the current value
of Irssi's cmdchars does B<not> work! This is necessary do differentiate between
ex-commands and irssi commands.

=head2 SETTINGS

The settings are stored as irssi settings and can be set using C</set> as usual
(prepend C<vim_mode_> to setting name) or using the C<:set> ex-command. The
following settings are available:

=over 4

=item * utf8 - Support UTF-8 characters, boolean, default on

=item * debug - Enable debug output, boolean, default off

=item * cmd_seq - Char that when double-pressed simulates C<E<lt>EscE<gt>>, string, default '' (disabled)

=item * start_cmd - Start every line in command mode, boolean, default off

=item * max_undo_lines - Sze of the undo buffer. Integer, default 50 items.

=item * ex_history_size - Number of items stored in the ex-mode history. Integer, default 100.

=item * prompt_leading_space - Ddetermines whether ex mode prepends a space to the displayed input. Boolean, default on

=back

In contrast to irssi's settings, C<:set> accepts 0 and 1 as values for boolean
settings, but only vim_mode's settings can be set/displayed.

Examples:

   :set cmd_seq=j   # set cmd_seq to j
   :set cmd_seq=    # disable cmd_seq
   :set debug=on    # enable debug
   :set debug=off   # disable debug

=head1 KNOWN ISSUES

If you use tmux and want to use <esc> to exit insert mode you might want to
reduce the escape-time for a better experience (500 is the default value):

    set -s escape-time 100

A similar problem exist in GNU screen, the following settings in ~/.screenrc
fix it (thanks to jsbronder for reporting the screen issue and fix):

    maptimeout 0
    defc1 off

defc1 might not be necessary.

=head1 SUPPORT

Any behavior different from Vim (unless explicitly documented) should be
considered a bug and reported.

B<NOTE:> This script is still under heavy development, and there may be bugs.
Please submit reproducible sequences to the bug-tracker at:
L<http://github.com/shabble/irssi-scripts/issues/new>

or contact rudi_s or shabble on irc.freenode.net (#irssi and #irssi_vim)

=head1 AUTHORS

Copyright E<copy> 2010-2011 Tom Feist C<E<lt>shabble+irssi@metavore.orgE<gt>> and

Copyright E<copy> 2010-2011 Simon Ruderich C<E<lt>simon@ruderich.orgE<gt>>

=head1 THANKS

Particular thanks go to

=over 4

=item * estragib: a lot of testing and many bug reports and feature requests

=item * iaj: testing

=item * tmr: explaining how various bits of vim work

=back

as well as the rest of C<#irssi> and C<#irssi_vim> on Freenode IRC.

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

count before register doesn't work: e.g. 3"ap doesn't work, but "a3p does

=item *

mapping an incomplete ex-command doesn't open the ex-mode with the partial
command (e.g. C<:map gb :b> causes an error instead of opening the ex-mode and
displaying C<:bE<lt>cursorE<gt>>)

=item *

 undo/redo cursor positions are mostly wrong

=back

=head1 TODO

=over 4

=item *

Make sure the input line is empty when entering ex mode. Stuff hanging around
just looks silly.

=item *

History:

=over 4

=item *

 C< * /,?,n,N> to search through history (like rl_history_search.pl)

=back

=item *

Window switching (C<:b>)

=over 4

=item *

Tab completion of window(-item) names

=item *

non-sequential matches(?)

=back

=back

See also the TODO file at
L<github|https://github.com/shabble/irssi-scripts/blob/master/vim-mode/TODO> for
many many more things.

=head2 WONTFIX

Things we're not ever likely to do:

=over 4

=item * Macros

=back

=cut

use strict;
use warnings;

use Encode;
use List::Util;

use Irssi;
use Irssi::TextUI;              # for sbar_items_redraw
use Irssi::Irc;                 # necessary for 0.8.14



our $VERSION = "1.1.0";
our %IRSSI   =
  (
   authors         => "Tom Feist (shabble), Simon Ruderich (rudi_s)",
   contact         => 'shabble+irssi@metavore.org, '
                    . 'shabble@#irssi/Freenode, simon@ruderich.org'
                    . 'rudi_s@#irssi/Freenode',
   name            => "vim_mode",
   description     => "Give Irssi Vim-like commands for editing the inputline",
   license         => "MIT",
   changed         => "3/2/2012"
  );


# CONSTANTS

# command mode
sub M_CMD () { 1 }
# insert mode
sub M_INS () { 0 }
# extended mode (after a :?)
sub M_EX  () { 2 }

# operator command
sub C_OPERATOR   () { 0 }
# normal command, no special handling necessary
sub C_NORMAL     () { 1 }
# command taking another key as argument
sub C_NEEDSKEY   () { 2 }
# text-object command (i a)
sub C_TEXTOBJECT () { 3 }
# commands entering insert mode
sub C_INSERT     () { 4 }
# ex-mode commands
sub C_EX         () { 5 }
# irssi commands
sub C_IRSSI      () { 6 }
# does nothing
sub C_NOP        () { 7 }

# setting types, match irssi types as they are stored as irssi settings
sub S_BOOL () { 0 }
sub S_INT  () { 1 }
sub S_STR  () { 2 }
sub S_TIME () { 3 }

# word and non-word regex, keep in sync with setup_changed()!
my $word     = qr/[\w_]/o;
my $non_word = qr/[^\w_\s]/o;

# COMMANDS

# All available commands in command mode, they are stored with a char as key,
# but this is not necessarily the key the command is currently mapped to.
my $commands
  = {
     # operators
     c => { char => 'c', func => \&cmd_operator_c, type => C_OPERATOR,
            repeatable => 1 },
     d => { char => 'd', func => \&cmd_operator_d, type => C_OPERATOR,
            repeatable => 1 },
     y => { char => 'y', func => \&cmd_operator_y, type => C_OPERATOR,
            repeatable => 1 },

     # arrow like movement
      h     => { char => 'h',       func => \&cmd_h, type => C_NORMAL },
      l     => { char => 'l',       func => \&cmd_l, type => C_NORMAL },
     "\x08" => { char => '<BS>',    func => \&cmd_h, type => C_NORMAL },
     "\x7F" => { char => '<BS>',    func => \&cmd_h, type => C_NORMAL },
     ' '    => { char => '<Space>', func => \&cmd_l, type => C_NORMAL },
     # history movement
     j      => { char => 'j',  func => \&cmd_j,  type => C_NORMAL,
                 no_operator => 1 },
     k      => { char => 'k',  func => \&cmd_k,  type => C_NORMAL,
                 no_operator => 1 },
     gg     => { char => 'gg', func => \&cmd_gg, type => C_NORMAL,
                 no_operator => 1 },
     G      => { char => 'G',  func => \&cmd_G,  type => C_NORMAL,
                 needs_count => 1, no_operator => 1 },
     # char movement, take an additional parameter and use $movement
      f  => { char => 'f', func => \&cmd_f, type => C_NEEDSKEY,
              selection_needs_move_right => 1 },
      t  => { char => 't', func => \&cmd_t, type => C_NEEDSKEY,
              selection_needs_move_right => 1 },
      F  => { char => 'F', func => \&cmd_F, type => C_NEEDSKEY },
      T  => { char => 'T', func => \&cmd_T, type => C_NEEDSKEY },
     ';' => { char => ';', func => \&cmd_semicolon, type => C_NORMAL },
     ',' => { char => ',', func => \&cmd_comma, type => C_NORMAL },
     # word movement
     w  => { char => 'w',  func => \&cmd_w,  type => C_NORMAL },
     b  => { char => 'b',  func => \&cmd_b,  type => C_NORMAL },
     e  => { char => 'e',  func => \&cmd_e,  type => C_NORMAL,
             selection_needs_move_right => 1 },
     ge => { char => 'ge', func => \&cmd_ge, type => C_NORMAL,
             selection_needs_move_right => 1 },
     W  => { char => 'W',  func => \&cmd_W,  type => C_NORMAL },
     B  => { char => 'B',  func => \&cmd_B,  type => C_NORMAL },
     E  => { char => 'E',  func => \&cmd_E,  type => C_NORMAL },
     gE => { char => 'gE', func => \&cmd_gE, type => C_NORMAL,
             selection_needs_move_right => 1 },
     # text-objects, leading _ means can't be mapped!
     _i => { char => 'i', func => \&cmd__i,      type => C_TEXTOBJECT },
     _a => { char => 'a', func => \&cmd__a,      type => C_TEXTOBJECT },
     # line movement
     '0' => { char => '0', func => \&cmd_0,      type => C_NORMAL },
     '^' => { char => '^', func => \&cmd_caret,  type => C_NORMAL },
     '$' => { char => '$', func => \&cmd_dollar, type => C_NORMAL },
     # delete chars
     x => { char => 'x', func => \&cmd_x, type => C_NORMAL,
            repeatable => 1, no_operator => 1 },
     X => { char => 'X', func => \&cmd_X, type => C_NORMAL,
            repeatable => 1, no_operator => 1 },
          # C_NORMAL is correct, operator c takes care of insert mode
     s => { char => 's', func => \&cmd_s, type => C_NORMAL,
            repeatable => 1, no_operator => 1 },
          # C_NORMAL is correct, operator c takes care of insert mode
     S => { char => 'S', func => \&cmd_S, type => C_NORMAL,
            repeatable => 1, no_operator => 1 },
     # insert mode
     i => { char => 'i', func => \&cmd_i, type => C_INSERT,
            repeatable => 1, no_operator => 1 },
     I => { char => 'I', func => \&cmd_I, type => C_INSERT,
            repeatable => 1, no_operator => 1 },
     a => { char => 'a', func => \&cmd_a, type => C_INSERT,
            repeatable => 1, no_operator => 1 },
     A => { char => 'A', func => \&cmd_A, type => C_INSERT,
            repeatable => 1, no_operator => 1 },
     # replace
     r => { char => 'r', func => \&cmd_r, type => C_NEEDSKEY,
            repeatable => 1, no_operator => 1 },
     # paste
     p => { char => 'p', func => \&cmd_p, type => C_NORMAL,
            repeatable => 1, no_operator => 1 },
     P => { char => 'P', func => \&cmd_P, type => C_NORMAL,
            repeatable => 1, no_operator => 1 },
     # to end of line
     C => { char => 'C', func => \&cmd_C, type => C_NORMAL,
            repeatable => 1, no_operator => 1 },
     D => { char => 'D', func => \&cmd_D, type => C_NORMAL,
            repeatable => 1, no_operator => 1 },
     # scrolling
     "\x05" => { char => '<C-E>', func => \&cmd_ctrl_d, type => C_NORMAL,
                 no_operator => 1 },
     "\x04" => { char => '<C-D>', func => \&cmd_ctrl_d, type => C_NORMAL,
                 needs_count => 1, no_operator => 1 },
     "\x19" => { char => '<C-Y>', func => \&cmd_ctrl_u, type => C_NORMAL,
                 no_operator => 1 },
     "\x15" => { char => '<C-U>', func => \&cmd_ctrl_u, type => C_NORMAL,
                 needs_count => 1, no_operator => 1 },
     "\x06" => { char => '<C-F>', func => \&cmd_ctrl_f, type => C_NORMAL,
                 no_operator => 1 },
     "\x02" => { char => '<C-B>', func => \&cmd_ctrl_b, type => C_NORMAL,
                 no_operator => 1 },
     # window switching
     "\x17j" => { char => '<C-W>j', func => \&cmd_ctrl_wj, type => C_NORMAL,
                  no_operator => 1 },
     "\x17k" => { char => '<C-W>k', func => \&cmd_ctrl_wk, type => C_NORMAL,
                  no_operator => 1 },
     "\x1e"  => { char => '<C-^>',  func => \&cmd_ctrl_6,  type => C_NORMAL,
                  no_operator => 1 },
     # misc
     '~'  => { char => '~', func => \&cmd_tilde, type => C_NORMAL,
               repeatable => 1, no_operator => 1 },
     '"'  => { char => '"', func => \&cmd_register, type => C_NEEDSKEY,
               no_operator => 1 },
     '.'  => { char => '.', type => C_NORMAL, repeatable => 1,
               no_operator => 1 },
     ':'  => { char => ':', type => C_NORMAL },
     "\n" => { char => '<CR>', type => C_NORMAL }, # return
     # undo
     'u'    => { char => 'u',     func => \&cmd_undo, type => C_NORMAL,
                 no_operator => 1 },
     "\x12" => { char => '<C-R>', func => \&cmd_redo, type => C_NORMAL,
                 no_operator => 1 },
    };

# All available commands in Ex-Mode.
my $commands_ex
  = {
     # arrow keys - not actually used, see handle_input_buffer()
     # TODO: make these work.
     "\e[A"    => { char => ':exprev',    func => \&ex_history_back,
                    type => C_EX },
     "\e[B"    => { char => ':exnext',    func => \&ex_history_fwd,
                    type => C_EX },

     # normal Ex mode commands.
     eh        => { char => ':exhist',    func => \&ex_history_show,
                    type => C_EX },
     s         => { char => ':s',         func => \&ex_substitute,
                    type => C_EX },
     bnext     => { char => ':bnext',     func => \&ex_bnext,
                    type => C_EX, uses_count => 1 },
     bn        => { char => ':bn',        func => \&ex_bnext,
                    type => C_EX, uses_count => 1 },
     bprev     => { char => ':bprev',     func => \&ex_bprev,
                    type => C_EX, uses_count => 1 },
     bp        => { char => ':bp',        func => \&ex_bprev,
                    type => C_EX, uses_count => 1 },
     bdelete   => { char => ':bdelete',   func => \&ex_bdelete,
                    type => C_EX, uses_count => 1 },
     bd        => { char => ':bd',        func => \&ex_bdelete,
                    type => C_EX, uses_count => 1 },
     buffer    => { char => ':buffer',    func => \&ex_buffer,
                    type => C_EX, uses_count => 1 },
     b         => { char => ':b',         func => \&ex_buffer,
                    type => C_EX, uses_count => 1 },
     registers => { char => ':registers', func => \&ex_registers,
                    type => C_EX },
     reg       => { char => ':reg',       func => \&ex_registers,
                    type => C_EX },
     display   => { char => ':display',   func => \&ex_registers,
                    type => C_EX },
     di        => { char => ':di',        func => \&ex_registers,
                    type => C_EX },
     buffers   => { char => ':buffer',    func => \&ex_buffers,
                    type => C_EX },
     ls        => { char => ':ls',        func => \&ex_buffers,
                    type => C_EX },
     undolist  => { char => ':undolist',  func => \&ex_undolist,
                    type => C_EX },
     undol     => { char => ':undol',     func => \&ex_undolist,
                    type => C_EX },
     map       => { char => ':map',       func => \&ex_map,
                    type => C_EX },
     unmap     => { char => ':unmap',     func => \&ex_unmap,
                    type => C_EX },
     unm       => { char => ':unm',       func => \&ex_unmap,
                    type => C_EX },
     source    => { char => ':source',    func => \&ex_source,
                    type => C_EX },
     so        => { char => ':so',        func => \&ex_source,
                    type => C_EX },
     mkvimrc   => { char => ':mkvimrc',   func => \&ex_mkvimrc,
                    type => C_EX },
     mkv       => { char => ':mkv',       func => \&ex_mkvimrc,
                    type => C_EX },
     se        => { char => ':se',        func => \&ex_set,
                    type => C_EX },
     set       => { char => ':set',       func => \&ex_set,
                    type => C_EX },
     itemnext  => { char => ':itemnext',  func => \&ex_item_next,
                    type => C_EX },
     inext     => { char => ':itemnext',  func => \&ex_item_next,
                    type => C_EX },
     itemprev  => { char => ':itemprev',  func => \&ex_item_prev,
                    type => C_EX },
     iprev     => { char => ':itemprev',  func => \&ex_item_prev,
                    type => C_EX },
     servernext  => { char => ':servernext', func => \&ex_server_next,
                    type => C_EX },
     snext       => { char => ':servernext', func => \&ex_server_next,
                    type => C_EX },
     serverprev  => { char => ':serverprev', func => \&ex_server_prev,
                    type => C_EX },
     sprev       => { char => ':serverprev', func => \&ex_server_prev,
                    type => C_EX },

    };

# MAPPINGS

# default command mode mappings
my $maps = {};

# current imap still pending (first character entered)
my $imap = undef;

# maps for insert mode
my $imaps
  = {
     # CTRL-R, insert register
     "\x12" => { map  => undef, func => \&insert_ctrl_r },
    };


# GLOBAL VARIABLES

# all vim_mode settings, must be enabled in vim_mode_init() before usage
my $settings
  = {
     # print debug output
     debug          => { type => S_BOOL, value => 0 },
     # use UTF-8 internally for string calculations/manipulations
     utf8           => { type => S_BOOL, value => 1 },
     # esc-shortcut in insert mode
     cmd_seq        => { type => S_STR,  value => '' },
     # start every line in command mode
     start_cmd      => { type => S_BOOL, value => 0 },
     # not used yet
     max_undo_lines => { type => S_INT,  value => 50 },
     # size of history buffer for Ex mode.
     ex_history_size => { type => S_INT, value => 100 },
     # prompt_leading_space
     prompt_leading_space => { type => S_BOOL, value => 1 },
     # <Leader> value for prepending to commands.
     map_leader     => { type => S_STR,  value => '\\' },
     # timeout for keys following esc. In milliseconds.
     esc_buf_timeout => { type => S_TIME, value =>  '10ms' },

    };

sub DEBUG { $settings->{debug}->{value} }

# buffer to keep track of the last N keystrokes, used for Esc detection and
# insert mode mappings
my @input_buf;
my $input_buf_timer;
my $input_buf_enabled = 0;

# insert mode repeat buffer, used to repeat (.) last insert
my @insert_buf;

# flag to allow us to emulate keystrokes without re-intercepting them
my $should_ignore = 0;

# ex mode buffer
my @ex_buf;

# ex mode history storage.
my @ex_history;
my $ex_history_index = 0;

# we are waiting for another mapped key (e.g. g pressed, but there are
# multiple mappings like gg gE etc.)
my $pending_map = undef;

# for commands like 10x
my $numeric_prefix = undef;
# current operator as $command hash
my $operator = undef;
# vi movements, only used when a movement needs more than one key (like f t).
my $movement = undef;
# last vi command, used by .
my $last
  = {
     'cmd' => $commands->{i}, # = i to support . when loading the script
     'numeric_prefix' => undef,
     'operator' => undef,
     'movement' => undef,
     'register' => '"',
    };
# last ftFT movement, used by ; and ,
my $last_ftFT
  = {
     type => undef, # f, t, F or T
     char => undef,
    };

# what Vi mode we're in. We start in insert mode.
my $mode = M_INS;

# current active register
my $register = '"';

# vi registers
my $registers
  = {
     '"' => '', # default register
     '0' => '', # yank register
     '+' => '', # contains irssi's cut buffer
     '*' => '', # same
     '_' => '', # black hole register, always empty
    };

# index into the history list (for j,k)
my $history_index = undef;
# current line, necessary for j,k or the current input line gets destroyed
my $history_input = undef;
# position in input line
my $history_pos = 0;

# Undo/redo buffer.

my @undo_buffer;
my $undo_index = undef;

# tab completion state vars

my @tab_candidates;
my $completion_active = 0;
my $completion_string = '';

sub script_is_loaded {
    return exists($Irssi::Script::{shift(@_) . '::'});
}




# INSERT MODE COMMANDS

sub insert_ctrl_r {
    my ($key) = @_;
    _debug("ctrl-r called");
    my $char = chr($key);
    _debug("ctrl-r called with $char");

    return if not defined $registers->{$char} or $registers->{$char} eq '';

    my $pos = _insert_at_position($registers->{$char}, 1, _input_pos());
    _input_pos($pos + 1);
}


# COMMAND MODE OPERATORS

sub cmd_operator_c {
    my ($old_pos, $new_pos, $move_cmd, $repeat) = @_;

    # Changing a word or WORD doesn't delete the last space before a word, but
    # not if we are on that whitespace before the word.
    if ($move_cmd and ($move_cmd == $commands->{w} or
                       $move_cmd == $commands->{W})) {
        my $input = _input();
        if ($new_pos - $old_pos > 1 and
                substr($input, $new_pos - 1, 1) =~ /\s/) {
            $new_pos--;
        }
    }

    cmd_operator_d($old_pos, $new_pos, $move_cmd, $repeat, 1);

    if (!$repeat) {
        _update_mode(M_INS);
    } else {
        my $pos = _input_pos();
        $pos = _insert_buffer(1, $pos);
        _input_pos($pos);
    }
}

sub cmd_operator_d {
    my ($old_pos, $new_pos, $move_cmd, $repeat, $change) = @_;

    my ($pos, $length) = _get_pos_and_length($old_pos, $new_pos, $move_cmd);

    # Remove the selected string from the input.
    my $input = _input();
    my $string = substr $input, $pos, $length, '';
    if ($register =~ /[A-Z]/) {
        $registers->{lc $register} .= $string;
        print "Deleted into $register: ", $registers->{lc $register} if DEBUG;
    } else {
        $registers->{$register} = $string;
        print "Deleted into $register: ", $registers->{$register} if DEBUG;
    }
    _input($input);

    # Prevent moving after the text when we delete the last character. But not
    # when changing (C).
    $pos-- if $pos == length($input) and !$change;

    _input_pos($pos);
}

sub cmd_operator_y {
    my ($old_pos, $new_pos, $move_cmd, $repeat) = @_;

    my ($pos, $length) = _get_pos_and_length($old_pos, $new_pos, $move_cmd);

    # Extract the selected string and put it in the " register.
    my $input = _input();
    my $string = substr $input, $pos, $length;
    if ($register =~ /[A-Z]/) {
        $registers->{lc $register} .= $string;
        print "Yanked into $register: ", $registers->{lc $register} if DEBUG;
    } else {
        $registers->{$register} = $string;
        print "Yanked into $register: ", $registers->{$register} if DEBUG;
        if ($register eq '"') {
            $registers->{0} = $string;
            print "Yanked into 0: ", $registers->{0} if DEBUG;
        }
    }

    # Always move to the lower position.
    if ($old_pos > $new_pos) {
        _input_pos($new_pos);
    } else {
        _input_pos($old_pos);
    }
}

sub _get_pos_and_length {
    my ($old_pos, $new_pos, $move_cmd) = @_;

    my $length = $new_pos - $old_pos;
    # We need a positive length and $old_pos must be smaller.
    if ($length < 0) {
        $old_pos = $new_pos;
        $length *= -1;
    }

    # Some commands don't move one character after the deletion area which is
    # necessary for all commands moving to the right. Fix it.
    if ($move_cmd->{selection_needs_move_right}) {
        $length += 1;
    }

    return ($old_pos, $length);
}

# COMMAND MODE COMMANDS

sub cmd_h {
    my ($count, $pos, $repeat) = @_;

    $pos -= $count;
    $pos = 0 if $pos < 0;
    return (undef, $pos);
}

sub cmd_l {
    my ($count, $pos, $repeat) = @_;

    my $length = _input_len();
    $pos += $count;
    $pos = _fix_input_pos($pos, $length);
    return (undef, $pos);
}

# later history (down)
sub cmd_j {
    my ($count, $pos, $repeat) = @_;

    if (Irssi::version < 20090117) {
        # simulate a down-arrow
        _emulate_keystrokes(0x1b, 0x5b, 0x42);
        return (undef, undef);
    }

    my @history = Irssi::active_win->get_history_lines();

    if (defined $history_index) {
        $history_index += $count;
        print "History Index: $history_index" if DEBUG;
    # Prevent destroying the current input when pressing j after entering
    # command mode. Not exactly like in default irssi, but simplest solution
    # (and S can be used to clear the input line fast, which is what <down>
    # does in plain irssi).
    } else {
        return (undef, undef);
    }

    if ($history_index > $#history) {
        # Restore the input line.
        _input($history_input);
        _input_pos($history_pos);
        $history_index = $#history + 1;
    } elsif ($history_index >= 0) {
        my $history = $history[$history_index];
        # History is not in UTF-8!
        if ($settings->{utf8}->{value}) {
            $history = decode_utf8($history);
        }
        _input($history);
        _input_pos(0);
    }
    return (undef, undef);
}

# earlier history (up)
sub cmd_k {
    my ($count, $pos, $repeat) = @_;

    if (Irssi::version < 20090117) {
        # simulate an up-arrow
        _emulate_keystrokes(0x1b, 0x5b, 0x41);
        return (undef, undef);
    }

    my @history = Irssi::active_win->get_history_lines();

    if (defined $history_index) {
        $history_index -= $count;
        $history_index = 0 if $history_index < 0;
    } else {
        $history_index = $#history;
        $history_input = _input();
        $history_pos = _input_pos();
    }
    print "History Index: $history_index" if DEBUG;
    if ($history_index >= 0) {
        my $history = $history[$history_index];
        # History is not in UTF-8!
        if ($settings->{utf8}->{value}) {
            $history = decode_utf8($history);
        }
        _input($history);
        _input_pos(0);
    }
    return (undef, undef);
}

sub cmd_G {
    my ($count, $pos, $repeat) = @_;

    if (Irssi::version < 20090117) {
        _warn("G and gg not supported in irssi < 0.8.13");
        return;
    }

    my @history = Irssi::active_win->get_history_lines();

    # Go to the current input line if no count was given or it's too big.
    if (not $count or $count - 1 >= scalar @history) {
        if (defined $history_input and defined $history_pos) {
            _input($history_input);
            _input_pos($history_pos);
            $history_index = undef;
        }
        return;
    } else {
        # Save input line so it doesn't get lost.
        if (not defined $history_index) {
            $history_input = _input();
            $history_pos = _input_pos();
        }
        $history_index = $count - 1;
    }

    my $history = $history[$history_index];
    # History is not in UTF-8!
    if ($settings->{utf8}->{value}) {
        $history = decode_utf8($history);
    }
    _input($history);
    _input_pos(0);

    return (undef, undef);
}

sub cmd_gg {
    my ($count, $pos, $repeat) = @_;

    return cmd_G(1, $pos, $repeat);
}

sub cmd_f {
    my ($count, $pos, $repeat, $char) = @_;

    $pos = _next_occurrence(_input(), $char, $count, $pos);

    $last_ftFT = { type => 'f', char => $char };
    return (undef, $pos);
}

sub cmd_t {
    my ($count, $pos, $repeat, $char) = @_;

    $pos = _next_occurrence(_input(), $char, $count, $pos);
    if (defined $pos) {
        $pos--;
    }

    $last_ftFT = { type => 't', char => $char };
    return (undef, $pos);
}

sub cmd_F {
    my ($count, $pos, $repeat, $char) = @_;

    my $input = reverse _input();
    $pos = _next_occurrence($input, $char, $count, length($input) - $pos - 1);
    if (defined $pos) {
        $pos = length($input) - $pos - 1;
    }

    $last_ftFT = { type => 'F', char => $char };
    return (undef, $pos);
}

sub cmd_T {
    my ($count, $pos, $repeat, $char) = @_;

    my $input = reverse _input();
    $pos = _next_occurrence($input, $char, $count, length($input) - $pos - 1);
    if (defined $pos) {
        $pos = length($input) - $pos - 1 + 1;
    }

    $last_ftFT = { type => 'T', char => $char };
    return (undef, $pos);
}

# Find $count-th next occurrence of $char.
sub _next_occurrence {
    my ($input, $char, $count, $pos) = @_;

    while ($count-- > 0) {
        $pos = index $input, $char, $pos + 1;
        if ($pos == -1) {
            return undef;
        }
    }
    return $pos;
}

sub cmd_semicolon {
    my ($count, $pos, $repeat) = @_;

    return (undef, undef) if not defined $last_ftFT->{type};

    (undef, $pos)
        = $commands->{$last_ftFT->{type}}
                   ->{func}($count, $pos, $repeat, $last_ftFT->{char});
    return (undef, $pos);
}

sub cmd_comma {
    my ($count, $pos, $repeat) = @_;

    return (undef, undef) if not defined $last_ftFT->{type};

    # Change direction.
    my $save = $last_ftFT->{type};
    my $type = $save;
    $type =~ tr/ftFT/FTft/;

    (undef, $pos)
        = $commands->{$type}
                   ->{func}($count, $pos, $repeat, $last_ftFT->{char});
    # Restore type as the move functions overwrites it.
    $last_ftFT->{type} = $save;
    return (undef, $pos);
}

sub cmd_w {
    my ($count, $pos, $repeat) = @_;

    my $input = _input();
    $pos = _beginning_of_word($input, $count, $pos);
    $pos = _fix_input_pos($pos, length $input);
    return (undef, $pos);
}

sub cmd_b {
    my ($count, $pos, $repeat) = @_;

    my $input = reverse _input();
    $pos = length($input) - $pos - 1;
    $pos = 0 if ($pos < 0);

    $pos = _end_of_word($input, $count, $pos);
    $pos = length($input) - $pos - 1;
    $pos = 0 if ($pos < 0);
    return (undef, $pos);
}

sub cmd_e {
    my ($count, $pos, $repeat) = @_;

    my $input = _input();
    $pos = _end_of_word($input, $count, $pos);
    $pos = _fix_input_pos($pos, length $input);
    return (undef, $pos);
}

sub cmd_ge {
    my ($count, $pos, $repeat, $char) = @_;

    my $input = reverse _input();
    $pos = length($input) - $pos - 1;
    $pos = 0 if ($pos < 0);

    $pos = _beginning_of_word($input, $count, $pos);
    $pos = length($input) - $pos - 1;
    $pos = 0 if ($pos < 0);

    return (undef, $pos);
}

# Go to the beginning of $count-th word, like vi's w.
sub _beginning_of_word {
    my ($input, $count, $pos) = @_;

    while ($count-- > 0) {
        # Go to end of next word/non-word.
        if (substr($input, $pos) =~ /^$word+/ or
            substr($input, $pos) =~ /^$non_word+/) {
            $pos += $+[0];
        }
        # And skip over any whitespace if necessary. This also happens when
        # we're inside whitespace.
        if (substr($input, $pos) =~ /^\s+/) {
            $pos += $+[0];
        }
    }

    return $pos;
}

# Go to the end of $count-th word, like vi's e.
sub _end_of_word {
    my ($input, $count, $pos) = @_;

    while ($count-- > 0 and length($input) > $pos) {
        my $skipped = 0;
        # Skip over whitespace if in the middle of it or directly after the
        # current word/non-word.
        if (substr($input, $pos + 1) =~ /^\s+/) {
            $pos += $+[0] + 1;
            $skipped = 1;
        }
        elsif (substr($input, $pos) =~ /^\s+/) {
            $pos += $+[0];
            $skipped = 1;
        }
        # We are inside a word/non-word, skip to the end of it.
        if (substr($input, $pos) =~ /^$word{2,}/ or
            substr($input, $pos) =~ /^$non_word{2,}/) {
            $pos += $+[0] - 1;
        # We are the border of word/non-word. Skip to the end of the next one.
        # But not if we've already jumped over whitespace because there could
        # be only one word/non-word char after the whitespace.
        } elsif (!$skipped and (substr($input, $pos) =~ /^$word($non_word+)/ or
                                substr($input, $pos) =~ /^$non_word($word+)/)) {
            $pos += $+[0] - 1;
        }
    }

    # Necessary for correct deletion at the end of the line.
    if (length $input == $pos + 1) {
        $pos++;
    }

    return $pos;
}

sub cmd_W {
    my ($count, $pos, $repeat) = @_;

    my $input = _input();
    $pos = _beginning_of_WORD($input, $count, $pos);
    $pos = _fix_input_pos($pos, length $input);
    return (undef, $pos);
}

sub cmd_B {
    my ($count, $pos, $repeat) = @_;

    my $input = reverse _input();
    $pos = _end_of_WORD($input, $count, length($input) - $pos - 1);
    if ($pos == -1) {
        return cmd_0();
    } else {
        return (undef, length($input) - $pos - 1);
    }
}

sub cmd_E {
    my ($count, $pos, $repeat) = @_;

    $pos = _end_of_WORD(_input(), $count, $pos);
    if ($pos == -1) {
        return cmd_dollar();
    } else {
        return (undef, $pos);
    }
}

sub cmd_gE {
    my ($count, $pos, $repeat, $char) = @_;

    my $input = reverse _input();
    $pos = _beginning_of_WORD($input, $count, length($input) - $pos - 1);
    if ($pos == -1 or length($input) - $pos - 1 == -1) {
        return cmd_0();
    } else {
        $pos = length($input) - $pos - 1;
    }

    return (undef, $pos);
}

# Go to beginning of $count-th WORD, like vi's W.
sub _beginning_of_WORD {
    my ($input, $count, $pos) = @_;

    # Necessary for correct movement between two words with only one
    # whitespace.
    if (substr($input, $pos) =~ /^\s\S/) {
        $pos++;
        $count--;
    }

    while ($count-- > 0 and length($input) > $pos) {
        if (substr($input, $pos + 1) !~ /\s+/) {
            return length($input);
        }
        $pos += $+[0] + 1;
    }

    return $pos;
}

# Go to end of $count-th WORD, like vi's E.
sub _end_of_WORD {
    my ($input, $count, $pos) = @_;

    return $pos if $pos >= length($input);

    # We are inside a WORD, skip to the end of it.
    if (substr($input, $pos + 1) =~ /^\S+(\s)/) {
        $pos += $-[1];
        $count--;
    }

    while ($count-- > 0) {
        if (substr($input, $pos) !~ /\s+\S+(\s+)/) {
            return -1;
        }
        $pos += $-[1] - 1;
    }
    return $pos;
}

sub cmd__i {
    my ($count, $pos, $repeat, $char) = @_;

    _warn("i_ not implemented yet");
    return (undef, undef);
}

sub cmd__a {
    my ($count, $pos, $repeat, $char) = @_;

    my $cur_pos;
    my $input = _input();

    # aw and aW
    if ($char eq 'w' or $char eq 'W') {
        while ($count-- > 0 and length($input) > $pos) {
            if (substr($input, $pos, 1) =~ /\s/) {
                # Any whitespace before the word/WORD must be removed.
                if (not defined $cur_pos) {
                    $cur_pos = _find_regex_before($input, '\S', $pos, 0);
                    if ($cur_pos < 0) {
                        $cur_pos = 0;
                    } else {
                        $cur_pos++;
                    }
                }
                # Move before the word/WORD.
                if (substr($input, $pos + 1) =~ /^\s+/) {
                    $pos += $+[0];
                }
                # And delete the word.
                if ($char eq 'w') {
                    if (substr($input, $pos) =~ /^\s($word+|$non_word+)/) {
                        $pos += $+[0];
                    } else {
                        $pos = length($input);
                    }
                # WORD
                } else {
                    if (substr($input, $pos + 1) =~ /\s/) {
                        $pos += $-[0] + 1;
                    } else {
                        $pos = length($input);
                    }
                }

            # word
            } elsif ($char eq 'w') {
                # Start at the beginning of this WORD.
                if (not defined $cur_pos and $pos > 0
                    and substr($input, $pos - 1, 2)
                    !~ /(\s.|$word$non_word|$non_word$word)/) {

                    $cur_pos = _find_regex_before
                      (
                       $input,
                       "^($word+$non_word|$non_word+$word|$word+\\s|$non_word+\\s)",
                       $pos, 1
                      );

                    if ($cur_pos < 0) {
                        $cur_pos = 0;
                    } else {
                        $cur_pos += 2;
                    }
                }
                # Delete to the end of the word.
                if (substr($input, $pos) =~
                    /^($word+$non_word|$non_word+$word|$word+\s+\S|$non_word+\s+\S)/) {

                    $pos += $+[0] - 1;
                } else {
                    $pos = length($input);
                    # If we are at the end of the line, whitespace before
                    # the word is also deleted.
                    my $new_pos = _find_regex_before
                      ($input,
                       "^($word+\\s+|$non_word+\\s+)",
                       $pos, 1);

                    if ($new_pos != -1 and
                        (not defined $cur_pos or
                         $cur_pos > $new_pos + 1)) {

                        $cur_pos = $new_pos + 1;
                    }
                }

            # WORD
            } else {
                # Start at the beginning of this WORD.
                if (not defined $cur_pos and $pos > 0 and
                        substr($input, $pos - 1, 1) !~ /\s/) {
                    $cur_pos = _find_regex_before($input, '\s', $pos - 1, 0);
                    if ($cur_pos < 0) {
                        $cur_pos = 0;
                    } else {
                        $cur_pos++;
                    }
                }
                # Delete to the end of the word.
                if (substr($input, $pos + 1) =~ /^\S*\s+\S/) {
                    $pos += $+[0];
                } else {
                    $pos = length($input);
                    # If we are at the end of the line, whitespace before
                    # the WORD is also deleted.
                    my $new_pos = _find_regex_before($input, '\s+', $pos, 1);
                    if (not defined $cur_pos or $cur_pos > $new_pos + 1) {
                        $cur_pos = $new_pos + 1;
                    }
                }
            }
        }
    }

    return ($cur_pos, $pos);
}

# Find regex as close as possible before the current position. If $end is true
# the end of the match is returned, otherwise the beginning.
sub _find_regex_before {
    my ($input, $regex, $pos, $end) = @_;

    $input = reverse $input;
    $pos = length($input) - $pos - 1;
    $pos = 0 if $pos < 0;

    if (substr($input, $pos) =~ /$regex/) {
        if (!$end) {
            $pos += $-[0];
        } else {
            $pos += $+[0];
        }
        return length($input) - $pos - 1;
    } else {
        return -1;
    }
}

sub cmd_0 {
    return (undef, 0);
}

sub cmd_caret {
    my $input = _input();
    my $pos;
    # No whitespace at all.
    if ($input !~ m/^\s/) {
        $pos = 0;
    # Some non-whitespace, go to first one.
    } elsif ($input =~ m/[^\s]/) {
        $pos = $-[0];
    # Only whitespace, go to the end.
    } else {
        $pos = _fix_input_pos(length $input, length $input);
    }
    return (undef, $pos);
}

sub cmd_dollar {
    my $length = _input_len();
    return (undef, _fix_input_pos($length, $length));
}

sub cmd_x {
    my ($count, $pos, $repeat) = @_;

    cmd_operator_d($pos, $pos + $count, $commands->{x}, $repeat);
    return (undef, undef);
}

sub cmd_X {
    my ($count, $pos, $repeat) = @_;

    return (undef, undef) if $pos == 0;

    my $new = $pos - $count;
    $new = 0 if $new < 0;
    cmd_operator_d($pos, $new, $commands->{X}, $repeat);
    return (undef, undef);
}

sub cmd_s {
    my ($count, $pos, $repeat) = @_;

    $operator = $commands->{c};
    return (undef, $pos + $count);
}

sub cmd_S {
    my ($count, $pos, $repeat) = @_;

    $operator = $commands->{c};
    return (0, _input_len());
}

sub cmd_i {
    my ($count, $pos, $repeat) = @_;

    if (!$repeat) {
        _update_mode(M_INS);
    } else {
        $pos = _insert_buffer($count, $pos);
    }
    return (undef, $pos);
}

sub cmd_I {
    my ($count, $pos, $repeat) = @_;

    $pos = cmd_caret();
    if (!$repeat) {
        _update_mode(M_INS);
    } else {
        $pos = _insert_buffer($count, $pos);
    }
    return (undef, $pos);
}

sub cmd_a {
    my ($count, $pos, $repeat) = @_;

    # Move after current character. Can't use cmd_l() because we need to mover
    # after last character at the end of the line.
    my $length = _input_len();
    $pos += 1;
    $pos = $length if $pos > $length;

    if (!$repeat) {
        _update_mode(M_INS);
    } else {
        $pos = _insert_buffer($count, $pos);
    }
    return (undef, $pos);
}

sub cmd_A {
    my ($count, $pos, $repeat) = @_;

    $pos = _input_len();

    if (!$repeat) {
        _update_mode(M_INS);
    } else {
        $pos = _insert_buffer($count, $pos);
    }
    return (undef, $pos);
}

# Add @insert_buf to _input() at the given position.
sub _insert_buffer {
    my ($count, $pos) = @_;
    return _insert_at_position(join('', @insert_buf), $count, $pos);
}

sub _insert_at_position {
    my ($string, $count, $pos) = @_;

    $string = $string x $count;

    my $input = _input();
    # Check if we are not at the end of the line to prevent substr outside of
    # string error.
    if (length $input > $pos) {
        substr($input, $pos, 0) = $string;
    } else {
        $input .= $string;
    }
    _input($input);

    return $pos - 1 + length $string;
}

sub cmd_r {
    my ($count, $pos, $repeat, $char) = @_;

    my $input = _input();

    # Abort if at end of the line.
    return (undef, undef) if length($input) < $pos + $count;

    substr $input, $pos, $count, $char x $count;
    _input($input);
    return (undef, $pos + $count - 1);
}

sub cmd_p {
    my ($count, $pos, $repeat) = @_;
    $pos = _paste_at_position($count, $pos + 1);
    return (undef, $pos);
}

sub cmd_P {
    my ($count, $pos, $repeat) = @_;
    $pos = _paste_at_position($count, $pos);
    return (undef, $pos);
}

sub _paste_at_position {
    my ($count, $pos) = @_;

    return if $registers->{$register} eq '';
    return _insert_at_position($registers->{$register}, $count, $pos);
}

sub cmd_C {
    my ($count, $pos, $repeat) = @_;

    $operator = $commands->{c};
    return (undef, _input_len());
}

sub cmd_D {
    my ($count, $pos, $repeat) = @_;

    $operator = $commands->{d};
    return (undef, _input_len());
}

sub cmd_ctrl_d {
    my ($count, $pos, $repeat) = @_;

    my $window = Irssi::active_win();
    # no count = half of screen
    if (not defined $count) {
        $count = $window->{height} / 2;
    }
    $window->view()->scroll($count);

    Irssi::statusbar_items_redraw('more');
    return (undef, undef);
}

sub cmd_ctrl_u {
    my ($count, $pos, $repeat) = @_;

    my $window = Irssi::active_win();
    # no count = half of screen
    if (not defined $count) {
        $count = $window->{height} / 2;
    }
    $window->view()->scroll($count * -1);

    Irssi::statusbar_items_redraw('more');
    return (undef, undef);
}

sub cmd_ctrl_f {
    my ($count, $pos, $repeat) = @_;

    my $window = Irssi::active_win();
    $window->view()->scroll($count * $window->{height});

    Irssi::statusbar_items_redraw('more');
    return (undef, undef);
}

sub cmd_ctrl_b {
    my ($count, $pos, $repeat) = @_;

    return cmd_ctrl_f($count * -1, $pos, $repeat);
}

sub cmd_ctrl_wj {
    my ($count, $pos, $repeat) = @_;

    while ($count-- > 0) {
        Irssi::command('window down');
    }

    return (undef, undef);
}

sub cmd_ctrl_wk {
    my ($count, $pos, $repeat) = @_;

    while ($count-- > 0) {
        Irssi::command('window up');
    }

    return (undef, undef);
}

sub cmd_ctrl_6 {
    # like :b#
    Irssi::command('window last');
    return (undef, undef);
}

sub cmd_tilde {
    my ($count, $pos, $repeat) = @_;

    my $input = _input();
    my $string = substr $input, $pos, $count;
    $string =~ s/(.)/(uc($1) eq $1) ? lc($1) : uc($1)/ge;
    substr $input, $pos, $count, $string;

    _input($input);
    return (undef, _fix_input_pos($pos + $count, length $input));
}

sub cmd_register {
    my ($count, $pos, $repeat, $char) = @_;

    if (not exists $registers->{$char} and not exists $registers->{lc $char}) {
        print "Wrong register $char, ignoring." if DEBUG;
        return (undef, undef);
    }

    # make sure black hole register is always empty
    if ($char eq '_') {
        $registers->{_} = '';
    }

    # + and * contain both irssi's cut-buffer
    if ($char eq '+' or $char eq '*') {
        $registers->{'+'} = Irssi::parse_special('$U');
        $registers->{'*'} = $registers->{'+'};
    }

    $register = $char;
    print "Changing register to $register" if DEBUG;
    return (undef, undef);
}

sub cmd_undo {
    print "Undo!" if DEBUG;

    if ($undo_index != $#undo_buffer) {
        $undo_index++;
        _restore_undo_entry($undo_index);
        print "Undoing entry index: $undo_index of " . scalar(@undo_buffer)
            if DEBUG;
    } else {
        print "No further undo." if DEBUG;
    }
    return (undef, undef);
}

sub cmd_redo {
    print "Redo!" if DEBUG;

    if ($undo_index != 0) {
        $undo_index--;
        print "Undoing entry index: $undo_index of " . scalar(@undo_buffer)
            if DEBUG;
        _restore_undo_entry($undo_index);
    } else {
        print "No further Redo." if DEBUG;
    }
    return (undef, undef);
}

# Adapt the input position depending if an operator is active or not.
sub _fix_input_pos {
    my ($pos, $length) = @_;

    # Allow moving past the last character when an operator is active to allow
    # correct handling of last character in line.
    if ($operator) {
        $pos = $length if $pos > $length;
    # Otherwise forbid it.
    } else {
        $pos = $length - 1 if $pos > $length - 1;
    }

    return $pos;
}


# EX MODE COMMANDS

sub cmd_ex_command {
    my $arg_str = join '', @ex_buf;

    if ($arg_str !~ /^(\d*)?([a-z]+)/) {
        return _warn("Invalid Ex-mode command!");
    }

    # Abort if command doesn't exist or used with count for unsupported
    # commands.
    if (not exists $commands_ex->{$2} or
        ($1 ne '' and not $commands_ex->{$2}->{uses_count})) {
        return _warn("Ex-mode $1$2 doesn't exist!");
    }

    # add this item to the ex mode history
    ex_history_add($arg_str);
    $ex_history_index = 0; # and reset the history position.

    my $count = $1;
    if ($count eq '') {
        $count = undef;
    }
    $commands_ex->{$2}->{func}($arg_str, $count);
}

sub ex_substitute {
    my ($arg_str, $count) = @_;

    # :s///
    if ($arg_str =~ m|^s/(.+)/(.*)/([ig]*)|) {
        my ($search, $replace, $flags) = ($1, $2, $3);
        print "Searching for $search, replace: $replace, flags; $flags"
          if DEBUG;

        my $rep_fun = sub { $replace };

        my $line = _input();
        my @re_flags = split '', defined $flags?$flags:'';

        if (scalar grep { $_ eq 'i' } @re_flags) {
            $search = '(?i)' . $search;
        }

        print "Search is $search" if DEBUG;

        my $re_pattern = qr/$search/;

        if (scalar grep { $_ eq 'g' } @re_flags) {
            $line =~ s/$re_pattern/$rep_fun->()/eg;
        } else {
            print "Single replace: $replace" if DEBUG;
            $line =~ s/$re_pattern/$rep_fun->()/e;
        }

        print "New line is: $line" if DEBUG;
        _input($line);
    } else {
        _warn_ex('s');
    }
}

sub ex_bnext {
    my ($arg_str, $count) = @_;

    if (not defined $count) {
        if ($arg_str =~ /^bn(?:ext)?\s(\d+)$/) {
            $count = $1;
        } else {
            $count = 1;
        }
    }

    while ($count-- > 0) {
        Irssi::command('window next');
    }
}

sub ex_bprev {
    my ($arg_str, $count) = @_;

    if (not defined $count) {
        if ($arg_str =~ /^bp(?:rev)?\s(\d+)$/) {
            $count = $1;
        } else {
            $count = 1;
        }
    }

    while ($count-- > 0) {
        Irssi::command('window previous');
    }
}

sub ex_bdelete {
    my ($arg_str, $count) = @_;

    if (not defined $count) {
        if ($arg_str =~ /^bd(?:elete)?\s(\d+)$/) {
            $count = $1;
        }
    }

    if (defined $count) {
        my $window = Irssi::window_find_refnum($count);
        if (not $window) {
            return;
        }
        $window->set_active();
    }
    Irssi::command('window close');
}

sub ex_buffer {
    my ($arg_str, $count) = @_;

    # :b[buffer] {args}
    if ($arg_str =~ m|^b(?:uffer)?\s*(.+)$| or defined $count) {
        my $window;
        my $item;
        my $buffer = $1;

        # :[N]:b[uffer]
        if (defined $count) {
            $window = Irssi::window_find_refnum($count);
        # Go to window number.
        } elsif ($buffer =~ /^[0-9]+$/) {
            $window = Irssi::window_find_refnum($buffer);
        # Go to previous window.
        } elsif ($buffer eq '#') {
            Irssi::command('window last');
        # Go to best regex matching window.
        } else {
            eval {
                my $matches = _matching_windows($buffer);
                if (scalar @$matches > 0) {
                    $window = @$matches[0]->{window};
                    $item = @$matches[0]->{item};
                }
            };
            # Catch errors in /$buffer/ regex.
            if ($@) {
                _warn($@);
            }
        }

        if ($window) {
            $window->set_active();
            if ($item) {
                $item->set_active();
            }
        }
    } else {
        _warn_ex('buffer');
    }
}

sub ex_item_next {
    my ($arg_str, $count) = @_;
    my $win = Irssi::active_win;
    $count = 1 unless defined $count;

    $win->item_next for (1..$count);
}

sub ex_item_prev {
    my ($arg_str, $count) = @_;
    my $win = Irssi::active_win;
    $count = 1 unless defined $count;

    $win->item_prev for (1..$count);
}

# TODO: factor out the shared search code for server next/prev.
sub ex_server_next {
    my ($arg_str, $count) = @_;

    my @server_ids = map { $_->{tag} . "\x1d" . $_->{nick} } Irssi::servers;
    my $server = Irssi::active_server;

    return unless $server;

    my $current_id = $server->{tag} . "\x1d" . $server->{nick};
    my $next = 0;
    my $server_count = scalar @server_ids;
    for my $i (0..$server_count - 1) {
        my $s_id = $server_ids[$i];
        if (defined($s_id) and ($s_id eq $current_id)) {
            print "Found match at $i" if DEBUG;
            $next = ($i + 1) % $server_count;
            last;
        }
    }

    my $next_server = $server_ids[$next];
    $next_server =~ s|^([^\x1d]+)\x1d.*$|$1|;

    print "Changing to server: $next: $next_server" if DEBUG;
    Irssi::command("window server $next_server");
}

sub ex_server_prev {
    my ($arg_str, $count) = @_;

    my @server_ids = map { $_->{tag} . "\x1d" . $_->{nick} } Irssi::servers;
    my $server = Irssi::active_server;

    return unless $server;

    my $current_id = $server->{tag} . "\x1d" . $server->{nick};
    my $prev = 0;
    my $server_count = scalar @server_ids;

    for my $i (0..$server_count - 1) {
        my $s_id = $server_ids[$i];
        if (defined($s_id) and ($s_id eq $current_id)) {
            print "Found match at $i" if DEBUG;
            $prev = ($i - 1) % $server_count;
            last;
        }
    }

    my $prev_server = $server_ids[$prev];
    $prev_server =~ s|^([^\x1d]+)\x1d.*$|$1|;

    print "Changing to server: $prev: $prev_server" if DEBUG;
    Irssi::command("window server $prev_server");

}

sub ex_registers {
    my ($arg_str, $count) = @_;

    # :reg[isters] {arg} and :di[splay] {arg}
    if ($arg_str =~ /^(?:reg(?:isters)?|di(?:splay)?)(?:\s+(.+)$)?/) {
        my @regs;
        if ($1) {
            my $regs = $1;
            $regs =~ s/\s+//g;
            @regs = split //, $regs;
        } else {
            @regs = keys %$registers;
        }

        # Update "+ and "* registers so correct values are displayed.
        $registers->{'+'} = Irssi::parse_special('$U');
        $registers->{'*'} = $registers->{'+'};

        my @empty_regs;
        my $special_regs = { '+' => 1, '*' => 1, '_' => 1, '"' => 1, '0' => 1 };

        my $active_window = Irssi::active_win;
        foreach my $key (sort @regs) {
            next if $key eq '_'; # skip black hole
            if (defined $registers->{$key}) {
                my $register_val = $registers->{$key};
                if (length $register_val or exists $special_regs->{$key}) {
                    $register_val =~ s/%/%%/g;
                    $active_window->print("register $key: $register_val");
                } else {
                    push @empty_regs, $key;
                }
            }
        }

        # coalesce empty registers into a single line.
        if (@empty_regs) {
            my @runs;
            my $run_start;
            foreach my $i (0..$#empty_regs) {
                my $cur  = $empty_regs[$i];
                my $next = $empty_regs[$i+1];

                $run_start = $cur unless $run_start;
                if (defined $next and ord($cur) + 1 == ord($next)) {
                    # extend range.
                } else {
                    # terminate range and restart
                    my $run_str = $run_start;

                    if ($cur ne $run_start) {
                        $run_str .= "-$cur";
                    }
                    push @runs, $run_str;
                    $run_start = undef;
                }
            }
            $active_window->print("Empty registers: " . join(', ', @runs));
        }
    } else {
        _warn_ex(':registers');
    }
}

sub ex_buffers {
    my ($arg_str, $count) = @_;

    Irssi::command('window list');
}

sub ex_undolist {
    my ($arg_str, $count) = @_;

    _print_undo_buffer();
}

sub ex_map {
    my ($arg_str, $count) = @_;

    # :map {lhs} {rhs}
    if ($arg_str =~ /^map (\S+) (\S.*)$/) {
        my $lhs = _parse_mapping($1);
        my $rhs = $2;

        if (not defined $lhs) {
            return _warn_ex('map', 'invalid {lhs}');
        }

        # Add new mapping.
        my $command;
        # Ex-mode command
        if (index($rhs, ':') == 0) {
            $rhs =~ /^:(\S+)(\s.+)?$/;
            if (not exists $commands_ex->{$1}) {
                return _warn_ex('map', "$rhs not found");
            } else {
                $command = { char => $rhs,
                             func => $commands_ex->{$1}->{func},
                             type => C_EX,
                           };
            }
        # Irssi command
        } elsif (index($rhs, '/') == 0) {
            $command = { char => $rhs,
                         func => substr($rhs, 1),
                         type => C_IRSSI,
                       };
        # <Nop> does nothing
        } elsif (lc $rhs eq '<nop>') {
            $command = { char => '<Nop>',
                         func => undef,
                         type => C_NOP,
                       };
        # command-mode command
        } else {
            $rhs = _parse_mapping($2);
            if (not defined $rhs) {
                return _warn_ex('map', 'invalid {rhs}');
            } elsif (not exists $commands->{$rhs}) {
                return _warn_ex('map', "$2 not found");
            } else {
                $command = $commands->{$rhs};
            }
        }
        add_map($lhs, $command);

    # :map [lhs]
    } elsif ($arg_str =~ m/^map\s*$/ or $arg_str =~ m/^map (\S+)$/) {
        # Necessary for case insensitive matchings. lc alone won't work.
        my $search = $1;
        $search = '' if not defined $search;
        $search = _parse_mapping_reverse(_parse_mapping($search));

        my $active_window = Irssi::active_win();
        foreach my $key (sort keys %$maps) {
            my $map = $maps->{$key};
            my $cmd = $map->{cmd};
            if (defined $cmd) {
                next if $map->{char} eq $cmd->{char}; # skip default mappings
                # FIXME: Hack so <C-H> doesn't show up as mapped to <BS>.
                next if $map->{char} eq '<C-H>' and $cmd->{char} eq '<BS>';
                next if $map->{char} !~ /^\Q$search\E/; # skip non-matches
                $active_window->print(sprintf "%-15s %s", $map->{char},
                                                          $cmd->{char});
            }
        }
    } else {
        _warn_ex('map');
    }
}
sub ex_unmap {
    my ($arg_str, $count) = @_;

    # :unm[ap] {lhs}
    if ($arg_str !~ /^unm(?:ap)? (\S+)$/) {
        return _warn_ex('unmap');
    }

    my $lhs = _parse_mapping($1);
    if (not defined $lhs) {
        return _warn_ex('unmap', 'invalid {lhs}');
    # Prevent unmapping of unknown or default mappings.
    } elsif (not exists $maps->{$lhs} or not defined $maps->{$lhs}->{cmd} or
             ($commands->{$lhs} and $maps->{$lhs}->{cmd} == $commands->{$lhs})) {
        return _warn_ex('unmap', "$1 not found");
    }

    delete_map($lhs);
}
sub _parse_mapping {
    my ($string) = @_;

    $string =~ s/<([^>]+)>/_parse_mapping_bracket($1)/ge;
    _debug("Parse mapping: $string");
    if (index($string, '<invalid>') != -1) {
        return undef;
    }
    return $string;
}
sub _parse_mapping_bracket {
    my ($string) = @_;

    $string = lc $string;

    # <C-X>, get corresponding CTRL char.
    if ($string =~ /^c-([a-z])$/i) {
        $string = chr(ord($1) - 96);
    # <C-6> and <C-^>
    } elsif ($string =~ /^c-[6^]$/i) {
        $string = chr(30);
    # <Space>
    } elsif ($string eq 'space') {
        $string = ' ';
    # <CR>
    } elsif ($string eq 'cr') {
        $string = "\n";
    # <BS>
    } elsif ($string eq 'bs') {
        $string = chr(127);
    } elsif ($string eq 'leader') {
        $string = $settings->{map_leader}->{value};
    # Invalid char, return special string to recognize the error.
    } else {
        $string = '<invalid>';
    }
    return $string;
}
sub _parse_mapping_reverse {
    my ($string) = @_;

    if (not defined $string) {
        _warn("Unable to reverse-map command: " . join('', @ex_buf));
        return;
    }

    my $escaped_leader = quotemeta($settings->{map_leader}->{value});
    $string =~ s/$escaped_leader/<Leader>/g;

    # Convert char to <char-name>.
    $string =~ s/ /<Space>/g;
    $string =~ s/\n/<CR>/g;
    $string =~ s/\x7F/<BS>/g;
    # Convert Ctrl-X to <C-X>.
    $string =~ s/([\x01-\x1A])/"<C-" . chr(ord($1) + 64) . ">"/ge;
    # Convert Ctrl-6 and Ctrl-^ to <C-^>.
    $string =~ s/\x1E/<C-^>/g;

    return $string;
}
sub _parse_partial_command_reverse {
    my ($string) = @_;

    my $escaped_leader = quotemeta($settings->{map_leader}->{value});
    $string =~ s/$escaped_leader/<Leader>/g;

    # Convert Ctrl-X to ^X.
    $string =~ s/([\x01-\x1A])/"^" . chr(ord($1) + 64)/ge;
    # Convert Ctrl-6 and Ctrl-^ to <C-^>.
    $string =~ s/\x1E/^^/g;

    return $string;
}

sub ex_source {
    my ($arg_str, $count) = @_;

    # :so[urce], but only loads the vim_moderc file at the moment

    open my $file, '<', Irssi::get_irssi_dir() . '/vim_moderc' or return;

    while (my $line = <$file>) {
        next if $line =~ /^\s*$/ or $line =~ /^\s*"/;

        chomp $line;
        # :map {lhs} {rhs}, keep in sync with ex_map()
        if ($line =~ /^\s*map (\S+) (\S.*)$/) {
            ex_map($line);
        } else {
            _warn_ex('source', "command not supported: $line");
        }
    }
}

sub ex_mkvimrc {
    my ($arg_str, $count) = @_;

    # :mkv[imrc][!], [file] not supported

    my $vim_moderc = Irssi::get_irssi_dir(). '/vim_moderc';
    if (-f $vim_moderc and $arg_str !~ /^mkv(?:imrc)?!$/) {
        return _warn_ex('mkvimrc', "$vim_moderc already exists");
    }

    open my $file, '>', $vim_moderc or return;

    # copied from ex_map()
    foreach my $key (sort keys %$maps) {
        my $map = $maps->{$key};
        my $cmd = $map->{cmd};
        if (defined $cmd) {
            next if $map->{char} eq $cmd->{char}; # skip default mappings
            print $file "map $map->{char} $cmd->{char}\n";
        }
    }

    close $file;
}

sub ex_set {
    my ($arg_str, $count) = @_;

    # :se[t] [option] [value]
    if ($arg_str =~ /^se(?:t)?(?:\s([^=]+)(?:=(.*)$)?)?/) {
        # :se[t] {option} {value}
        if (defined $1 and defined $2) {
            if (not exists $settings->{$1}) {
                return _warn_ex('map', "setting '$1' not found");
            }
            my $name = $1;
            my $value = $2;
            # Also accept numeric values for boolean options.
            if ($settings->{$name}->{type} == S_BOOL) {
                if ($value =~ /^(on|off)$/i) {
                    $value = lc $value eq 'on' ? 1 : 0;
                } elsif ($value eq '') {
                    $value = 0;
                }
            }
            _setting_set($name, $value);
            setup_changed();

        # :se[t] [option]
        } else {
            my $search = defined $1 ? $1 : '';
            my $active_window = Irssi::active_win();
            foreach my $setting (sort keys %$settings) {
                next if $setting !~ /^\Q$search\E/; # skip non-matches
                my $value = $settings->{$setting}->{value};
                # Irssi only accepts 'on' and 'off' as values for boolean
                # options.
                if ($settings->{$setting}->{type} == S_BOOL) {
                    $value = $value ? 'on' : 'off';
                }
                $active_window->print($setting . '=' . $value);
            }
        }
    } else {
        _warn_ex('map');
    }
}

sub _warn_ex {
    my ($command, $description) = @_;
    my $message = "Error in ex-mode command $command";
    if (defined $description) {
        $message .= ": $description";
    }
    _warn($message);
}

sub _matching_windows {
    my ($buffer) = @_;

    my $server;

    if ($buffer =~ m{^(.+)/(.+)}) {
        $server = $1;
        $buffer = $2;
    }

    print ":b searching for channel $buffer" if DEBUG;
    print ":b on server $server" if $server and DEBUG;

    my @matches;
    foreach my $window (Irssi::windows()) {
        # Matching window names.
        if ($window->{name} =~ /$buffer/i) {
            my $win_ratio = ($+[0] - $-[0]) / length($window->{name});
            push @matches, { window => $window,
                               item => undef,
                              ratio => $win_ratio,
                               text => $window->{name} };
            print ":b $window->{name}: $win_ratio" if DEBUG;
        }
        # Matching Window item names (= channels).
        foreach my $item ($window->items()) {
            # Wrong server.
            if ($server and (!$item->{server} or
                              $item->{server}->{chatnet} !~ /^$server/i)) {
                next;
            }
            if ($item->{name} =~ /$buffer/i) {
                my $length = length($item->{name});
                $length-- if index($item->{name}, '#') == 0;
                my $item_ratio = ($+[0] - $-[0]) / $length;
                push @matches, { window => $window,
                                   item => $item,
                                  ratio => $item_ratio,
                                   text => $item->{name} };
                print ":b $window->{name} $item->{name}: $item_ratio" if DEBUG;
            }
        }
    }

    @matches = sort {$b->{ratio} <=> $a->{ratio}} @matches;

    return \@matches;
}


# STATUS ITEMS

#TODO: give these things better names.
sub vim_mode_cmd {

    my $mode_str = '';
    if ($mode == M_INS) {
        $mode_str = '';
    } elsif ($mode == M_EX) {
        $mode_str = '%_ex%_';
    } else {
        $mode_str = '%_cmd%_';
        if ($register ne '"' or $numeric_prefix or $operator or $movement or
            $pending_map) {
            my $partial = '';
            if ($register ne '"') {
                $partial .= '"' . $register;
            }
            if ($numeric_prefix) {
                $partial .= $numeric_prefix;
            }
            if ($operator) {
                $partial .= $operator->{char};
            }
            if ($movement) {
                $partial .= $movement->{char};
            }
            if (defined $pending_map) {
                $partial .= $pending_map;
            }
            $partial = _parse_partial_command_reverse($partial);
            $partial =~ s/\\/\\\\\\\\/g;
            $mode_str .= " ($partial)";
        }
    }
    return $mode_str;
}

sub vim_wins_data {
    my $windows = '';

    # A little code duplication of cmd_ex_command(), but \s+ instead of \s* so
    # :bd doesn't display buffers matching d.
    my $arg_str = join '', @ex_buf;
    if ($arg_str =~ m|^b(?:uffer)?\s+(.+)$|) {
        my $buffer = $1;
        if ($buffer !~ /^[0-9]$/ and $buffer ne '#') {
            # Display matching windows.
            eval {
                my $matches = _matching_windows($buffer);
                $windows = join ',', map { $_->{text} } @$matches;
            };
            # Catch errors in /$buffer/ regex.
            if ($@) {
                _warn($@);
            }
        }
    }
    return $windows;
}

sub vim_exp_mode {
    my ($server, $witem, $arg) = @_;
    return vim_mode_cmd();
}

sub vim_exp_wins {
    my ($server, $witem, $arg) = @_;
    return vim_wins_data();
}

# vi mode status item.
sub vim_mode_cb {
    my ($sb_item, $get_size_only) = @_;
    my $mode_str = vim_mode_cmd();
    $sb_item->default_handler($get_size_only, "{sb $mode_str}", '', 0);
}

# :b window list item.
sub b_windows_cb {
    my ($sb_item, $get_size_only) = @_;

    my $windows = vim_wins_data();

    $sb_item->default_handler($get_size_only, "{sb $windows}", '', 0);
}


# INPUT HANDLING

sub got_key {
    my ($key) = @_;

    return if ($should_ignore);

    # Esc key
    if ($key == 27) {
        print "Esc seen, starting buffer" if DEBUG;
        $input_buf_enabled = 1;

        # NOTE: this timeout might be too low on laggy systems, but
        # it comes at the cost of keystroke latency for things that
        # contain escape sequences (arrow keys, etc)
        my $esc_buf_timeout = $settings->{esc_buf_timeout}->{value};

        $input_buf_timer
          = Irssi::timeout_add_once($esc_buf_timeout,
                                    \&handle_input_buffer, undef);

        print "Buffer Timer tag: $input_buf_timer" if DEBUG;

    } elsif ($mode == M_INS) {

        if ($key == 3) { # Ctrl-C enters command mode
            _update_mode(M_CMD);
            _stop();
            return;

        } elsif ($key == 10) { # enter.
            _commit_line();

        } elsif ($input_buf_enabled and $imap) {
            print "Imap $imap active" if DEBUG;
            my $map = $imaps->{$imap};
            if (not defined $map->{map} or chr($key) eq $map->{map}) {
                $map->{func}($key);
                # Clear the buffer so the imap is not printed.
                @input_buf = ();
            } else {
                push @input_buf, $key;
            }
            flush_input_buffer();
            _stop();
            $imap = undef;
            return;

        } elsif (exists $imaps->{chr($key)}) {
            print "Imap " . chr($key) . " seen, starting buffer" if DEBUG;

            # start imap pending mode
            $imap = chr($key);

            $input_buf_enabled = 1;
            push @input_buf, $key;
            $input_buf_timer
              = Irssi::timeout_add_once(1000, \&flush_input_buffer, undef);

            _stop();
            return;

        # Pressing delete resets insert mode repetition (8 = BS, 127 = DEL).
        # TODO: maybe allow it
        } elsif ($key == 8 || $key == 127) {
            @insert_buf = ();
        # All other entered characters need to be stored to allow repeat of
        # insert mode. Ignore delete and control characters.
        } elsif ($key > 31) {
            push @insert_buf, chr($key);
        }
    }

    if ($input_buf_enabled) {
        push @input_buf, $key;
        _stop();
        return;
    }

    if ($mode == M_CMD) {
        my $should_stop = handle_command_cmd($key);
        _stop() if $should_stop;
        Irssi::statusbar_items_redraw("vim_mode");

    } elsif ($mode == M_EX) {

        if ($key == 3) { # C-c cancels Ex mdoe as well.
            _update_mode(M_CMD);
            _stop();
            return;
        }

        handle_command_ex($key);
    }
}

# TODO: merge this with 'flush_input_buffer' below.

sub handle_input_buffer {

    #Irssi::timeout_remove($input_buf_timer);
    $input_buf_timer = undef;
    # see what we've collected.
    print "Input buffer contains: ", join(", ", @input_buf) if DEBUG;

    if (@input_buf == 1 && $input_buf[0] == 27) {

        print "Enter Command Mode" if DEBUG;
        _update_mode(M_CMD);

    } else {
        # we have more than a single esc, implying an escape sequence
        # (meta-* or esc-*)

        # currently, we only extract escape sequences if:
        # a) we're in ex mode
        # b) they're arrow keys (for history control)

        if ($mode == M_EX) {
            # ex mode
            my $key_str = join '', map { chr } @input_buf;
            if ($key_str =~ m/^\e\[([ABCD])/) {
                my $arrow = $1;
                _debug( "Arrow key: $arrow");
                if ($arrow eq 'A') { # up
                    ex_history_back();
                } elsif ($arrow eq 'B') { # down
                    ex_history_fwd();
                } else {
                    $arrow =~ s/C/right/;
                    $arrow =~ s/D/left/;
                    _debug("Arrow key $arrow not supported");
                }
            }
        } else {
            # otherwise, we just forward them to irssi.
            _emulate_keystrokes(@input_buf);
        }

        # Clear insert buffer, pressing "special" keys (like arrow keys)
        # resets it.
        @insert_buf = ();
    }

    @input_buf = ();
    $input_buf_enabled = 0;
}

sub flush_input_buffer {
    Irssi::timeout_remove($input_buf_timer) if defined $input_buf_timer;
    $input_buf_timer = undef;
    # see what we've collected.
    print "Input buffer flushed" if DEBUG;

    # Add the characters to @insert_buf so they can be repeated.
    push @insert_buf, map chr, @input_buf;

    _emulate_keystrokes(@input_buf);

    @input_buf = ();
    $input_buf_enabled = 0;

    $imap = undef;
}

sub flush_pending_map {
    my ($old_pending_map) = @_;

    print "flush_pending_map(): ", $pending_map, ' ', $old_pending_map
        if DEBUG;

    return if not defined $pending_map or
              $pending_map ne $old_pending_map;

    handle_command_cmd(undef);
    Irssi::statusbar_items_redraw("vim_mode");
}

sub handle_numeric_prefix {
    my ($char) = @_;
    my $num = 0+$char;

    if (defined $numeric_prefix) {
        $numeric_prefix *= 10;
        $numeric_prefix += $num;
    } else {
        $numeric_prefix = $num;
    }
}

sub handle_command_cmd {
    my ($key) = @_;

    my $pending_map_flushed = 0;

    my $char;
    if (defined $key) {
        $char = chr($key);
    # We were called from flush_pending_map().
    } else {
        $char = $pending_map;
        $key = 0;
        $pending_map_flushed = 1;
    }

    # Counts
    if (!$movement and !$pending_map and
        ($char =~ m/[1-9]/ or ($numeric_prefix && $char =~ m/[0-9]/))) {
        print "Processing numeric prefix: $char" if DEBUG;
        handle_numeric_prefix($char);
        return 1; # call _stop()
    }

    if (defined $pending_map and not $pending_map_flushed) {
        $pending_map = $pending_map . $char;
        $char = $pending_map;
    }

    my $map;
    if ($movement) {
        $map = { char => $movement->{char},
                 cmd => $movement,
                 maps => {},
               };

    } elsif (exists $maps->{$char}) {
        $map = $maps->{$char};

        # We have multiple mappings starting with this key sequence.
        if (!$pending_map_flushed and scalar keys %{$map->{maps}} > 0) {
            if (not defined $pending_map) {
                $pending_map = $char;
            }

            # The current key sequence has a command mapped to it, run if
            # after a timeout.
            if (defined $map->{cmd}) {
                Irssi::timeout_add_once(1000, \&flush_pending_map,
                                              $pending_map);
            }
            return 1; # call _stop()
        }

    } else {
        print "No mapping found for $char" if DEBUG;
        $pending_map = undef;
        $numeric_prefix = undef;
        return 1; # call _stop()
    }

    $pending_map = undef;

    my $cmd = $map->{cmd};

    # Make sure we have a valid $cmd.
    if (not defined $cmd) {
        print "Bug in pending_map_flushed() $map->{char}" if DEBUG;
        return 1; # call _stop()
    }

    # Ex-mode commands can also be bound in command mode.
    if ($cmd->{type} == C_EX) {
        print "Processing ex-command: $map->{char} ($cmd->{char})" if DEBUG;

        $cmd->{func}->(substr($cmd->{char}, 1), $numeric_prefix);
        $numeric_prefix = undef;

        return 1; # call _stop()
    # As can irssi commands.
    } elsif ($cmd->{type} == C_IRSSI) {
        print "Processing irssi-command: $map->{char} ($cmd->{char})" if DEBUG;

        _command_with_context($cmd->{func});

        $numeric_prefix = undef;
        return 1; # call _stop();
    # <Nop> does nothing.
    } elsif ($cmd->{type} == C_NOP) {
        print "Processing <Nop>: $map->{char}" if DEBUG;

        $numeric_prefix = undef;
        return 1; # call _stop();
    }

    # text-objects (i a) are simulated with $movement
    if (!$movement and ($cmd->{type} == C_NEEDSKEY or
                        ($operator and ($char eq 'i' or $char eq 'a')))) {
        print "Processing movement: $map->{char} ($cmd->{char})" if DEBUG;
        if ($char eq 'i') {
            $movement = $commands->{_i};
        } elsif ($char eq 'a') {
            $movement = $commands->{_a};
        } else {
            $movement = $cmd;
        }

    } elsif (!$movement and $cmd->{type} == C_OPERATOR) {
        print "Processing operator: $map->{char} ($cmd->{char})" if DEBUG;
        # Abort operator if we already have one pending.
        if ($operator) {
            # But allow cc/dd/yy.
            if ($operator == $cmd) {
                print "Processing line operator: ",
                  $map->{char}, " (",
                  $cmd->{char} ,")"
                    if DEBUG;

                my $pos = _input_pos();
                $cmd->{func}->(0, _input_len(), undef, 0);
                # Restore position for yy.
                if ($cmd == $commands->{y}) {
                    _input_pos($pos);
                # And save undo for other operators.
                } else {
                    _add_undo_entry(_input(), _input_pos());
                }
                if ($register ne '"') {
                    print 'Changing register to "' if DEBUG;
                    $register = '"';
                }
            }
            $numeric_prefix = undef;
            $operator = undef;
            $movement = undef;
        # Set new operator.
        } else {
            $operator = $cmd;
        }

    # Start Ex mode.
    } elsif ($cmd == $commands->{':'}) {

        if (not script_is_loaded('uberprompt')) {
            _warn("Warning: Ex mode requires the 'uberprompt' script. " .
                    "Please load it and try again.");
        } else {
            _update_mode(M_EX);
            _set_prompt(':');
        }

    # Enter key sends the current input line in command mode as well.
    } elsif ($key == 10) {
        _commit_line();
        return 0; # don't call _stop()

    } else {
        print "Processing command: $map->{char} ($cmd->{char})" if DEBUG;

        my $skip = 0;
        my $repeat = 0;

        if (!$movement) {
            # . repeats the last command.
            if ($cmd == $commands->{'.'} and defined $last->{cmd}) {
                $cmd = $last->{cmd};
                $char = $last->{char};
                # If . is given a count then it replaces original count.
                if (not defined $numeric_prefix) {
                    $numeric_prefix = $last->{numeric_prefix};
                }
                $operator = $last->{operator};
                $movement = $last->{movement};
                $register = $last->{register};
                $repeat = 1;
            } elsif ($cmd == $commands->{'.'}) {
                print '. pressed but $last->{char} not set' if DEBUG;
                $skip = 1;
            }
        }

        # Ignore invalid operator/command combinations.
        if ($operator and $cmd->{no_operator}) {
            print "Invalid operator/command: $operator->{char} $cmd->{char}"
                if DEBUG;
            $skip = 1;
        }

        if ($skip) {
            print "Skipping movement and operator." if DEBUG;
        } else {
            # Make sure count is at least 1 except for functions which need to
            # know if no count was used.
            if (not $numeric_prefix and not $cmd->{needs_count}) {
                $numeric_prefix = 1;
            }

            my $cur_pos = _input_pos();

            # If defined $cur_pos will be changed to this.
            my $old_pos;
            # Position after the move.
            my $new_pos;
            # Execute the movement (multiple times).
            if (not $movement) {
                ($old_pos, $new_pos)
                    = $cmd->{func}->($numeric_prefix, $cur_pos, $repeat);
            } else {
                ($old_pos, $new_pos)
                    = $cmd->{func}->($numeric_prefix, $cur_pos, $repeat,
                                     $char);
            }
            if (defined $old_pos) {
                print "Changing \$cur_pos from $cur_pos to $old_pos" if DEBUG;
                $cur_pos = $old_pos;
            }
            if (defined $new_pos) {
                _input_pos($new_pos);
            } else {
                $new_pos = _input_pos();
            }

            # Update input position of last undo entry so that undo/redo
            # restores correct position.
            if (@undo_buffer and _input() eq $undo_buffer[0]->[0] and
                ((defined $operator and $operator == $commands->{d}) or
                 $cmd->{repeatable})) {
                print "Updating history position: $undo_buffer[0]->[0]"
                    if DEBUG;
                $undo_buffer[0]->[1] = $cur_pos;
            }

            # If we have an operator pending then run it on the handled text.
            # But only if the movement changed the position (this prevents
            # problems with e.g. f when the search string doesn't exist).
            if ($operator and $cur_pos != $new_pos) {
                print "Processing operator: ", $operator->{char} if DEBUG;
                $operator->{func}->($cur_pos, $new_pos, $cmd, $repeat);
            }

            # Save an undo checkpoint here for operators, all repeatable
            # movements, operators and repetition.
            if ((defined $operator and $operator == $commands->{d}) or
                $cmd->{repeatable}) {
                # TODO: why do history entries still show up in undo
                # buffer? Is avoiding the commands here insufficient?

                _add_undo_entry(_input(), _input_pos());
            }

            # Store command, necessary for .
            if ($operator or $cmd->{repeatable}) {
                $last->{cmd} = $cmd;
                $last->{char} = $char;
                $last->{numeric_prefix} = $numeric_prefix;
                $last->{operator} = $operator;
                $last->{movement} = $movement;
                $last->{register} = $register;
            }
        }

        # Reset the count unless we go into insert mode, _update_mode() needs
        # to know it when leaving insert mode to support insert with counts
        # (like 3i).
        if ($repeat or $cmd->{type} != C_INSERT) {
            $numeric_prefix = undef;
        }
        $operator = undef;
        $movement = undef;

        if ($cmd != $commands->{'"'} and $register ne '"') {
            print 'Changing register to "' if DEBUG;
            $register = '"';
        }

    }

    return 1; # call _stop()
}

sub handle_command_ex {
    my ($key) = @_;

    # BS key (8) or DEL key (127) - remove last character.
    if ($key == 8 || $key == 127) {
        print "Delete" if DEBUG;
        if (@ex_buf > 0) {
            pop @ex_buf;
            _set_prompt(':' . join '', @ex_buf);
        # Backspacing over : exits ex-mode.
        } else {
            _update_mode(M_CMD);
        }

    # Return key - execute command
    } elsif ($key == 10) {
        print "Run ex-mode command" if DEBUG;
        cmd_ex_command();
        _update_mode(M_CMD);

    } elsif ($key == 9) { # TAB
        print "Tab pressed" if DEBUG;
        print "Ex buf contains: " . join('', @ex_buf) if DEBUG;
        @tab_candidates = _tab_complete(join('', @ex_buf), [keys %$commands_ex]);
        _debug("Candidates: " . join(", ", @tab_candidates));
        if (@tab_candidates == 1) {
            @ex_buf = ( split('', $tab_candidates[0]), ' ');
            _set_prompt(':' . join '', @ex_buf);
        }
    # Ignore control characters for now.
    } elsif ($key > 0 && $key < 32) {
        # TODO: use them later, e.g. completion

    # Append entered key
    } else {
        if ($key != -1) {
            # check we're not called from an ex_history_* function
            push @ex_buf, chr $key;
        }
        _set_prompt(':' . join '', @ex_buf);
    }

    Irssi::statusbar_items_redraw("vim_windows");

    _stop();
}

sub _tab_complete {
    my ($input, $source) = @_;
    my @out;
    foreach my $item (@$source) {
        if ($item =~ m/^\Q$input\E/) {
            push @out, $item;
        }
    }

    return sort { $a cmp $b } @out;
}

sub vim_mode_init {
    Irssi::signal_add_first 'gui key pressed' => \&got_key;
    Irssi::statusbar_item_register ('vim_mode',    0, 'vim_mode_cb');
    Irssi::statusbar_item_register ('vim_windows', 0, 'b_windows_cb');

    Irssi::expando_create('vim_cmd_mode' => \&vim_exp_mode, {});
    Irssi::expando_create('vim_wins'     => \&vim_exp_wins, {});


    # Register all available settings.
    foreach my $name (keys %$settings) {
        _setting_register($name);
    }

    foreach my $char ('a' .. 'z') {
        $registers->{$char} = '';
    }

    setup_changed();

    Irssi::signal_add 'setup changed' => \&setup_changed;

    # Add all default mappings.
    foreach my $char (keys %$commands) {
        next if $char =~ /^_/; # skip private commands (text-objects for now)
        add_map($char, $commands->{$char});
    }

    # Load the vim_moderc file if it exists.
    ex_source('source');

    setup_changed();
    _reset_undo_buffer();

    if ($settings->{start_cmd}->{value}) {
        _update_mode(M_CMD);
    } else {
        _update_mode(M_INS);
    }
}

sub setup_changed {
    my $value;

    if ($settings->{cmd_seq}->{value} ne '') {
        delete $imaps->{$settings->{cmd_seq}->{value}};
    }
    $value = _setting_get('cmd_seq');
    if ($value eq '') {
        $settings->{cmd_seq}->{value} = $value;
    } else {
        if (length $value == 1) {
            $imaps->{$value} = { 'map'  => $value,
                                 'func' => sub { _update_mode(M_CMD) }
                               };
            $settings->{cmd_seq}->{value} = $value;
        } else {
            _warn("Error: vim_mode_cmd_seq must be a single character");
            # Restore the value so $settings and irssi settings are
            # consistent.
            _setting_set('cmd_seq', $settings->{cmd_seq}->{value});
        }
    }

    my $new_utf8 = _setting_get('utf8');
    if ($new_utf8 != $settings->{utf8}->{value}) {
        # recompile the patterns when switching to/from utf-8
        $word     = qr/[\w_]/o;
        $non_word = qr/[^\w_\s]/o;

        $settings->{utf8}->{value} = $new_utf8;
    }
    if ($new_utf8 and (!$^V or $^V lt v5.8.1)) {
        _warn("Warning: UTF-8 isn't supported very well in perl < 5.8.1! " .
              "Please disable the vim_mode_utf8 setting.");
    }

    # Sync $settings with current irssi values.
    foreach my $name (keys %$settings) {
        # These were already handled above.
        next if $name eq 'cmd_seq' or $name eq 'cmd_seq';

        $settings->{$name}->{value} = _setting_get($name);
    }
}

sub UNLOAD {
    Irssi::signal_remove('gui key pressed' => \&got_key);
    Irssi::signal_remove('setup changed' => \&setup_changed);
    Irssi::statusbar_item_unregister ('vim_mode');
    Irssi::statusbar_item_unregister ('vim_windows');
}

sub _add_undo_entry {
    my ($line, $pos) = @_;

    # If we aren't at the top of the history stack, then drop newer entries as
    # we can't branch (yet).
    while ($undo_index > 0) {
        shift @undo_buffer;
        $undo_index--;
    }

    # check it's not a dupe of the list head
    my $current = $undo_buffer[$undo_index];
    if ($line eq $current->[0] && $pos == $current->[1]) {
        print "Not adding duplicate to undo list" if DEBUG;
    } elsif ($line eq $current->[0]) {
        print "Updating position of undo list at $undo_index" if DEBUG;
        $undo_buffer[$undo_index]->[1] = $pos;
    } else {
        print "adding $line ($pos) to undo list" if DEBUG;
        # add to the front of the buffer
        unshift @undo_buffer, [$line, $pos];
        $undo_index = 0;
    }
    my $max = $settings->{max_undo_lines}->{value};
}

sub _restore_undo_entry {
    my $entry = $undo_buffer[$undo_index];
    _input($entry->[0]);
    _input_pos($entry->[1]);
}

sub _print_undo_buffer {

    my $i = 0;
    my @buf;
    foreach my $entry (@undo_buffer) {
        my $str = '';
        if ($i == $undo_index) {
            $str .= '* ';
        } else {
            $str .= '  ';
        }
        my ($line, $pos) = @$entry;
        substr($line, $pos, 0) = '*';
        # substr($line, $pos+3, 0) = '%_';

        $str .= sprintf('%02d %s [%d]', $i, $line, $pos);
        push @buf, $str;
        $i++;
    }
    print "------ undo buffer ------";
    print join("\n", @buf);
    print "------------------ ------";

}

sub _reset_undo_buffer {
    my ($line, $pos) = @_;
    $line = _input()     unless defined $line;
    $pos  = _input_pos() unless defined $pos;

    print "Clearing undo buffer" if DEBUG;
    @undo_buffer = ([$line, $pos]);
    $undo_index  = 0;
}

sub add_map {
    my ($keys, $command) = @_;

    # To allow multiple mappings starting with the same key (like gg, ge, gE)
    # also create maps for the keys "leading" to this key (g in this case, but
    # can be longer for this like ,ls). When looking for the mapping these
    # "leading" maps are followed.
    my $tmp = $keys;
    while (length $tmp > 1) {
        my $map = substr $tmp, -1, 1, '';
        if (not exists $maps->{$tmp}) {
            $maps->{$tmp} = { char => _parse_mapping_reverse($tmp),
                               cmd => undef,
                              maps => {}
                            };
        }
        if (not exists $maps->{$tmp}->{maps}->{$tmp . $map}) {
            $maps->{$tmp}->{maps}->{$tmp . $map} = undef;
        }
    }

    if (not exists $maps->{$keys}) {
        $maps->{$keys} = { char => undef,
                            cmd => undef,
                           maps => {}
                         };
    }
    $maps->{$keys}->{char} = _parse_mapping_reverse($keys);
    $maps->{$keys}->{cmd} = $command;
}

sub delete_map {
    my ($keys) = @_;

    # Abort for non-existent mappings or placeholder mappings.
    return if not exists $maps->{$keys} or not defined $maps->{$keys}->{cmd};

    my @add = ();

    # If no maps need the current key, then remove it and all other
    # unnecessary keys in the "tree".
    if (keys %{$maps->{$keys}->{maps}} == 0) {
        my $tmp = $keys;
        while (length $tmp > 1) {
            my $map = substr $tmp, -1, 1, '';
            delete $maps->{$tmp}->{maps}->{$tmp . $map};
            if (not $maps->{$tmp}->{cmd} and keys %{$maps->{$tmp}->{maps}} == 0) {
                push @add, $tmp;
                delete $maps->{$tmp};
            } else {
                last;
            }
        }
    }

    if (keys %{$maps->{$keys}->{maps}} > 0) {
        $maps->{$keys}->{cmd} = undef;
    } else {
        delete $maps->{$keys};
    }
    push @add, $keys;

    # Restore default keybindings in case we :unmapped a <Nop> or a remapped
    # key.
    foreach my $key (@add) {
        if (exists $commands->{$key}) {
            add_map($key, $commands->{$key});
        }
    }
}


sub _commit_line {
    _update_mode(M_INS);

    # separate from call above as _update_mode() does additional internal work
    # and we need to make sure it gets correctly called.
    _update_mode(M_CMD) if $settings->{start_cmd}->{value};

    _reset_undo_buffer('', 0);
}

sub _input {
    my ($data) = @_;

    my $current_data = Irssi::parse_special('$L', 0, 0);

    if ($settings->{utf8}->{value}) {
        $current_data = decode_utf8($current_data);
    }

    if (defined $data) {
        if ($settings->{utf8}->{value}) {
            Irssi::gui_input_set(encode_utf8($data));
        } else {
            Irssi::gui_input_set($data);
        }
    } else {
        $data = $current_data;
    }

    return $data;
}

sub _input_len {
    return length _input();
}

sub _input_pos {
    my ($pos) = @_;
    my $cur_pos = Irssi::gui_input_get_pos();
    # my $dpos = defined $pos?$pos:'undef';
    # my @call = caller(1);
    # my $cfunc = $call[3];
    # $cfunc =~ s/^.*?::([^:]+)$/$1/;
    # print "pos called from line: $call[2] sub: $cfunc pos: $dpos, cur_pos: $cur_pos"
    #   if DEBUG;

    if (defined $pos) {
        #print "Input pos being set from $cur_pos to $pos" if DEBUG;
        Irssi::gui_input_set_pos($pos) if $pos != $cur_pos;
    } else {
        $pos = $cur_pos;
        #print "Input pos retrieved as $pos" if DEBUG;
    }

    return $pos;
}

sub _emulate_keystrokes {
    my @keys = @_;
    $should_ignore = 1;
    for my $key (@keys) {
        Irssi::signal_emit('gui key pressed', $key);
    }
    $should_ignore = 0;
}

sub _stop() {
    Irssi::signal_stop_by_name('gui key pressed');
}

sub _update_mode {
    my ($new_mode) = @_;

    my $pos;

    if ($mode == M_INS and $new_mode == M_CMD) {
        # Support counts with insert modes, like 3i.
        if ($numeric_prefix and $numeric_prefix > 1) {
            $pos = _insert_buffer($numeric_prefix - 1, _input_pos());
            _input_pos($pos);
            $numeric_prefix = undef;

        # In insert mode we are "between" characters, in command mode "on top"
        # of keys. When leaving insert mode we have to move on key left to
        # accomplish that.
        } else {
            $pos = _input_pos();
            if ($pos != 0) {
                _input_pos($pos - 1);
            }
        }
        # Store current line to allow undo of i/a/I/A.
        _add_undo_entry(_input(), _input_pos());

    # Change mode to i to support insert mode repetition. This doesn't affect
    # commands like i/a/I/A because handle_command_cmd() sets $last->{cmd}.
    # It's necessary when pressing enter so the next line can be repeated.
    } elsif ($mode == M_CMD and $new_mode == M_INS) {
        $last->{cmd} = $commands->{i};
    # Make sure prompt is cleared when leaving ex mode.
    } elsif ($mode == M_EX and $new_mode != M_EX) {
        _set_prompt('');
    }

    $mode = $new_mode;
    if ($mode == M_INS) {
        $history_index = undef;
        $register = '"';
        @insert_buf = ();
    # Reset every command mode related status as a fallback in case something
    # goes wrong.
    } elsif ($mode == M_CMD) {
        $numeric_prefix = undef;
        $operator = undef;
        $movement = undef;
        $register = '"';

        $pending_map = undef;

        # Also clear ex-mode buffer.
        @ex_buf = ();
    }

    Irssi::statusbar_items_redraw("vim_mode");
    Irssi::statusbar_items_redraw ('uberprompt');

}

sub _set_prompt {
    my $msg = shift;

    # add a leading space unless we're trying to clear it entirely.
    if  (length($msg) and $settings->{prompt_leading_space}->{value}) {
        $msg = ' ' . $msg;
    }

    # escape % symbols. This prevents any _set_prompt calls from using
    # colouring sequences.
    $msg =~ s/%/%%/g;

    Irssi::signal_emit('change prompt', $msg, 'UP_INNER');
}

sub _setting_get {
    my ($name) = @_;

    my $type = $settings->{$name}->{type};
    $name = "vim_mode_$name";

    my $ret = undef;

    if ($type == S_BOOL) {
        $ret = Irssi::settings_get_bool($name);
    } elsif ($type == S_INT) {
        $ret = Irssi::settings_get_int($name);
    } elsif ($type == S_STR) {
        $ret = Irssi::settings_get_str($name);
    } elsif ($type == S_TIME) {
        $ret = Irssi::settings_get_time($name);
    } else {
        _warn("Unknown setting type '$type', please report.");
    }

    return $ret;
}

sub _setting_set {
    my ($name, $value) = @_;

    my $type = $settings->{$name}->{type};
    $name = "vim_mode_$name";

    if ($type == S_BOOL) {
        Irssi::settings_set_bool($name, $value);
    } elsif ($type == S_INT) {
        Irssi::settings_set_int($name, $value);
    } elsif ($type == S_STR) {
        Irssi::settings_set_str($name, $value);
    } elsif ($type == S_TIME) {
        Irssi::settings_set_time($name, $value);
    } else {
        _warn("Unknown setting type '$type', please report.");
    }
}
sub _setting_register {
    my ($name) = @_;

    my $value = $settings->{$name}->{value};
    my $type  = $settings->{$name}->{type};
    $name = "vim_mode_$name";

    if ($type == S_BOOL) {
        Irssi::settings_add_bool('vim_mode', $name, $value);
    } elsif ($type == S_INT) {
        Irssi::settings_add_int('vim_mode', $name, $value);
    } elsif ($type == S_STR) {
        Irssi::settings_add_str('vim_mode', $name, $value);
    } elsif ($type == S_TIME) {
        Irssi::settings_add_time('vim_mode', $name, $value);
    } else {
        _warn("Unknown setting type '$type', please report.");
    }
}

sub _warn {
    my ($warning) = @_;

    print '%_vim_mode: ', $warning, '%_';
}

sub _debug {
    return unless DEBUG;

    my ($format, @args) = @_;
    my $str = sprintf($format, @args);
    print $str;
}

sub _command_with_context {
    my ($command) = @_;
    my $context;
    my $window = Irssi::active_win;
    if (defined $window) {
        my $witem = $window->{active};
        if (defined $witem and ref($witem) eq 'Irssi::Windowitem') {
            $context = $witem;
        } else {
            $context = $window;
        }
    } else {
        my $server = Irssi::active_server;
        if (defined $server) {
            $context = $server;
        }
    }
    if (defined $context) {
        print "Command $command Using context: " . ref($context) if DEBUG;
        $context->command($command);
    } else {
        print "Command $command has no context" if DEBUG;
        Irssi::command($command);
    }
}

sub ex_history_add {
    my ($line) = @_;

    # check it's not an exact dupe of the previous history line

    my $last_hist = $ex_history[$ex_history_index];
    $last_hist = '' unless defined $last_hist;

    return if $last_hist eq $line;

    _debug("Adding $line to ex command history");

    # add it to the history
    unshift @ex_history, $line;

    if ($settings->{ex_history_size}->{value} < @ex_history) {
        pop @ex_history; # junk the last entry if we've hit the max.
    }
}

sub ex_history_fwd {

    my $hist_max = $#ex_history;
    $ex_history_index++;
    if ($ex_history_index > $hist_max) {
        $ex_history_index = 0;
        _debug("ex history hit top, wrapping to 0");
    }

    my $line = $ex_history[$ex_history_index];
    $line = '' if not defined $line;

    _debug("Ex history line: $line");

    @ex_buf = split '', $line;
    handle_command_ex(-1);
}

sub ex_history_back {
    my $hist_max = $#ex_history;
    $ex_history_index--;
    if ($ex_history_index == -1) {
        $ex_history_index = $hist_max;
        _debug("ex history hit bottom, wrapping to $hist_max");

    }

    my $line = $ex_history[$ex_history_index];
    $line = '' if not defined $line;

    _debug("Ex history line: $line");
    @ex_buf = split '', $line;
    handle_command_ex(-1);

}

sub ex_history_show {
    my $win = Irssi::active_win();
    $win->print("Ex command history:");
    for my $i (0 .. $#ex_history) {
        my $flag = $i == $ex_history_index
          ? ' <'
          : '';
        $win->print("$i " . $ex_history[$i] . $flag);
    }
}
vim_mode_init();
