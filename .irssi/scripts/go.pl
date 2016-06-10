use strict;
use vars qw($VERSION %IRSSI);
use Irssi;
use Irssi::Irc;

# Usage:
# /script load go.pl
# If you are in #irssi you can type /go #irssi or /go irssi or even /go ir ...
# also try /go ir<tab> and /go  <tab> (that's two spaces)

# 20100125 - added /ago, to switch window while generating activity in the one we're leaving
# 20071002 - hacked by zigdon to work with window items, prefer exact matches, and retry
# from a rotating list

$VERSION = '1.01';

%IRSSI = (
    authors     => 'nohar (then zigdon)',
    contact     => 'nohar@freenode (zigdon@foonetic)',
    name        => 'go to window',
    description =>
'Implements /go command that activates a window given a name/partial name. It features a nice completion.',
    license => 'GPLv2 or later',
    changed => '08-17-04',
    url     => 'https://github.com/zigdon/Zigdon/blob/master/irssi/go.pl',
);

sub signal_complete_go {
    my ( $complist, $window, $word, $linestart, $want_space ) = @_;
    my $channel = $window->get_active_name();
    my $k       = Irssi::parse_special('$k');

    return unless ( $linestart =~ /^\Q${k}\Ea?go/i );

    @$complist = map {$_->[1] ? $_->[1]{visible_name} : $_->[0]->get_active_name} &get_list($word);
    Irssi::signal_stop();
}

sub cmd_activate {
    my ( $word, $server, $witem ) = @_;

    &cmd_go(@_);

    $witem->print( "*** MARK SET", MSGLEVEL_MSGS );
}

sub cmd_go {
    my ( $word, $server, $witem ) = @_;

    #foreach my $w (Irssi::windows) {
    #   my $name = $w->get_active_name();
    #   if ($name =~ /^#?\Q${chan}\E/) {
    #       $w->set_active();
    #       return;
    #   }
    #}

    my $c = 0;
    my $win_name;
    if    (ref $witem eq 'Irssi::Irc::Channel') { $win_name = $witem->{name} }
    elsif (ref $witem eq 'Irssi::Irc::Query')   { $win_name = $witem->{name} }
    elsif (    $witem eq '0'                  ) { $win_name = "status"       };
    # print "win_name = $win_name";

    my @opts = &get_list($word, $win_name);
    # print "opts ($word): ", join(", ", map {$_->[1]{visible_name}} @opts);
    #print "witem = $witem";

    if (my ($exact) = grep { $word eq $_->[1]{visible_name} } @opts) {
      $exact->[0]->set_active() if $exact->[0];
      $exact->[1]->set_active() if $exact->[1];
      return;
    }

    # check the short list first - prefer a prefix match
    my @short = grep {$_->[1]{visible_name} =~ /^#?$word/i} @opts;
    if (@short) {
      # print "short list: ", join(", ", map {$_->[1]{visible_name}} @short);
      @opts = @short;
    }

    # rotate options so that the currently active window is the last one
    if (grep { $win_name eq $_->[1]{visible_name} } @opts) {
      # print "rotating opts:\n";
        until ($opts[-1][1]{visible_name} eq $win_name or $c++ > @opts) {
          # print "$c: ", join(", ", map {$_->[1]{visible_name}} @opts);
            push @opts, shift @opts;
        }
    }
    # print "$c: ", join(", ", map {$_->[1]{visible_name}} @opts);

    $opts[0][0]->set_active() if $opts[0][0];
    $opts[0][1]->set_active() if $opts[0][1];

    unless ($opts[0][0]) {
      if ($witem) { $witem->print("No matches for '$word'") };
    }
    return;

}

sub get_list {
    my $word = shift;
    my $current  = shift || "";

    $word =~ s/^\s+|\s+$//;

    if (0) {
      my @list = ([], []);
      for my $exact (qw/1 0/) {
          foreach my $w (Irssi::windows) {

            # print "window found: ", $w->get_active_name;
              foreach my $i ( $w->items() ) {
                # print "item found: ", $i->{visible_name};
                  next if lc $i->{visible_name} eq lc $current;
                  next
                    unless not $word or
                          ($exact ? lc $i->{visible_name} eq lc $word
                                  : $i->{visible_name} =~ /\Q$word\E/i);

                  # print "item added";
                  push @{$list[$exact]}, [$w, $i];
              }
          }
      }
    }

    my @list = ();
    foreach my $w (Irssi::windows) {

      #print "window keys: ", join ", ", sort keys %$w;
      #print "window keys: ", join ", ", sort keys %{$w->{active_server}};
      #print "window found: ", $w->get_active_name, " ($w->{name}), server: $w->{active_server}{chatnet}";
      #return ();
      foreach my $i ( $w->items() ) {
        next unless ref $i;

        #print "item found: $i->{visible_name}/$i->{server}{chatnet}";
        next if $word and $i->{visible_name} !~ /\Q$word/i;

        #print "item found: $i->{visible_name}/$i->{server}{chatnet}";
        push @list, [$w, $i];
      }

      #if ($word and $w->{name} =~ /\Q$word/i) {
      #  push @list, [$w, undef];
      #}
    }

    # check if the window/channel we're currently on is on the list.  If so,
    # continue from that point.

    return () unless @list;
    # @list = sort {$a->[1]->{visible_name} cmp $b->[1]->{visible_name}} @list;
    @list = sort {length $a->[1]->{visible_name} <=> length $b->[1]->{visible_name}} @list;
    # for (1..@list) {
    #   push @list, shift @list;
    #   last if $list[-1][1]->is_active();
    # }

    # print "returning list = ", join ", ", map {$_->[1]->{visible_name}} @list;
    return @list;

    #return @{$list[1]},
    #       sort {$a->[0]->get_active_name cmp $b->[0]->get_active_name ||
    #             $a->[1]->{visible_name}  cmp $b->[1]->{visible_name} }
    #          @{$list[0]};
}

Irssi::command_bind( "go", "cmd_go" );
Irssi::command_bind( "ago", "cmd_activate" );
Irssi::signal_add_first( 'complete word', 'signal_complete_go' );
