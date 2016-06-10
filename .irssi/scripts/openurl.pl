# OpenURL by Stefan'tommie' Tomanek
#
# 05.06.2002
# * complete rewrite

use strict;

use vars qw($VERSION %IRSSI);
$VERSION = "20030208";
%IRSSI = (
    authors     => "Stefan 'tommie' Tomanek",
    contact     => "stefan\@pico.ruhr.de",
    name        => "OpenURL",
    description => "Stores URLs in a list and launches mail, web or ftp software",
    license     => "GPLv2",
    url         => "http://scripts.irssi.org",
    changed     => "$VERSION",
    commands	=> "openurl"
);

use Irssi 20020324;
use Irssi::TextUI;
use Irssi::UI;

use vars qw(@urls %urltypes $recent);
$recent = 1;

# RegExp & defaultcommands
%urltypes = ( http => { regexp => qr#((?:https?://[^\s<>"]+|www\.[-a-z0-9.]+)[^\s.,;<">\):])#, cmd => 'w3m "$1"' },
              ftp  => { regexp => qr#((?:ftp://[^\s<>"]+|ftp\.[-a-z0-9.]+)[^\s.,;<">\):])#, cmd => 'ncftp "$1"' },
	      mail => { regexp => qr#([-_a-z0-9.]+\@[-a-z0-9.]+\.[-a-z0-9.]+)#, cmd => 'mutt "$1" -s "$2"' },
	    );

sub draw_box ($$$$) {
    my ($title, $text, $footer, $colour) = @_;
    my $box = '';
    $box .= '%R,--[%n%9%U'.$title.'%U%9%R]%n'."\n";
    foreach (split(/\n/, $text)) {
        $box .= '%R|%n '.$_."\n";
    }                                                                               $box .= '%R`--<%n'.$footer.'%R>->%n';
    $box =~ s/%.//g unless $colour;
    return $box;
}

sub show_help() {
    my $help=$IRSSI{name}." ".$VERSION."
/openurl
    List the saved URLs
/openurl <number> <number>...
    Load the corresponding URLs in your browser/mailer
/openurl paste <number> <number>...
    Paste the selected URLs to the current channel/query
/openurl topics
    Look for URLs in channel topics
/openurl clear
    Clear all URLs
/openurl help
    Display this help
";
    my $text = '';
    foreach (split(/\n/, $help)) {
        $_ =~ s/^\/(.*)$/%9\/$1%9/;
	$text .= $_."\n";
    }
    print CLIENTCRAP draw_box($IRSSI{name}." help", $text, "help", 1) ;
}

sub list_urls {
    my $string = '';
    my $i = 1;
    foreach (@urls) {
	my $text = $_->{url};
	my $url = $_->{url};
	$text = $_->{text} if Irssi::settings_get_bool('openurl_display_context');
	$url =~ s/%/%%/g;
	$text =~ s/%/%%/g;
	$text =~ s/\Q$url/%U$url%U/;
	if ($recent-1 == $i) {
	    $string .= '%B»%n';
	} else {
	    $string .= ' ';
	}
	$string .= '%r['.$i.']%n ';
	$string .= '<'.$_->{channel};
	$string .= '/'.$_->{nick} unless $_->{nick} eq "";
	$string .= '> ';
	$string .= $text." %n\n";
	$i++;
    }
    print CLIENTCRAP draw_box("OpenURL", $string, "URLs", 1);
}

sub event_private_message {
    my ($server, $text, $nick, $address) = @_;
    process_line($server, $nick, $nick, $text);
}
sub event_public_message {
    my ($server, $text, $nick, $address, $target) = @_;
    process_line($server, $target, $nick, $text);
}
sub event_topic_changed {
    my ($channel) = @_;
    process_line($channel->{server}, $channel->{name}, "", $channel->{topic});
}

sub process_line ($$$$) {
    my ($server, $target, $nick, $line) = @_;
    my $url = get_url($line);
    if ($url) {
	my $type = url_type($url);
	return unless Irssi::settings_get_bool('openurl_watch_'.$type);
	new_url($server, $target, $nick, $line, $url);
    }
}

sub get_url ($) {
    my ($text) = @_;
    foreach (keys %urltypes) {
	return $1 if ($text =~ /$urltypes{$_}->{regexp}/);
    }
}

sub url_type ($) {
    my ($url) = @_;
    foreach (keys %urltypes) {
	return $_ if ($url =~ /$urltypes{$_}->{regexp}/);
    }
}

sub launch_url ($) {
    my ($url) = @_;
    my $type = url_type($url);
    my $address = $url;
    my $suffix= "";
    if ($type eq "mail") {
	$address = $1 if $url =~ /(.*?@.*?)($|\?)/;
	$suffix = $2 if $url =~ /(.*?@.*?)\?subject=(.*)/;
    }
    my $command = Irssi::settings_get_str("openurl_app_".$type);
    $command =~ s/\$1/$address/;
    $command =~ s/\$2/$suffix/;
    system($command);
}

sub new_url ($$$$$) {
    my ($server, $channel, $nick, $text, $url) = @_;
    $recent = 1 if ($recent > Irssi::settings_get_int('openurl_max_urls'));
    # Check for existance of URL
    my $i = 1;
    foreach (@urls) {
	if ($text eq $_->{text} && $channel eq $_->{channel}) {
	    my $note_id = add_note($server, $channel, $i);
	    push @{$_->{notes}}, $note_id;
	    return();
	}
	$i++;
    }
    if (defined $urls[$recent-1]) {
	del_notes($recent);
    }
    $urls[$recent-1] = {channel => $channel,
                        text    => $text,
			nick    => $nick,
			url     => $url,
			notes   => [],
			};
    my $note_id = add_note($server, $channel, $recent);
    push @{$urls[$recent-1]{notes}}, $note_id;
    $recent++;
}


sub del_notes ($) {
    my ($num) = @_;
    my $view;
    my $witem = Irssi::window_item_find($urls[$num-1]->{channel});
    if (defined $witem) {
	$view =  $witem->window()->view();
    }
    if (defined $view) {
	foreach (@{$urls[$num-1]->{notes}}) {
	    my $line = $view->get_bookmark($_);
	    $view->remove_line($line) if defined $line;
	    $view->set_bookmark($_, undef);
	}
	@{$urls[$num-1]->{notes}} = ();
	$view->redraw();
    }
}

sub add_note ($$$) {
    my ($server, $target, $num) = @_;
    my $witem;
    if (defined $server) {
	$witem = $server->window_item_find($target);
    } else {
	$witem = Irssi::window_item_find($target);
    }
    if (defined $witem) {
	$witem->print("%R>>%n OpenURL ".$num, MSGLEVEL_CLIENTCRAP);
	# create a unique ID for the mark
	my $foo = time().'-'.int(rand()*1000);
	$witem->window()->view()->set_bookmark_bottom("openurl_".$num.'-'.$foo);
	return("openurl_".$num.'-'.$foo);
    }
    return(undef);
}

sub clear_urls {
    del_notes($_) foreach (0..scalar(@urls)-1);
    pop(@urls) foreach (1..scalar(@urls));
    $recent = 1;
    print CLIENTCRAP '%R>>%n URLs cleared';
}

sub cmd_openurl ($$$) {
    my ($arg, $server, $witem) = @_;
    my @args = split(/ /, $arg);
    if (scalar(@args) == 0) {
	list_urls;
    } elsif ($args[0] eq 'clear') {
	clear_urls;
    } elsif ($args[0] eq 'topics') {
    	event_topic_changed($_) foreach (Irssi::channels());
    } elsif ($args[0] eq 'help') {
	show_help();
    } elsif ($args[0] eq 'open') {
	launch_url($args[1]);
    } else {
	my $paste = 0;
	if ($args[0] eq 'paste') {
	    $paste = 1;
	    shift(@args);
	}
	foreach (@args) {
	    next unless /\d+/;
	    next unless defined $urls[$_-1];
	    my $url = $urls[$_-1]->{url};
	    if ($paste == 1) {
		if (ref $witem && ($witem->{type} eq "CHANNEL" || $witem->{type} eq "QUERY")) {
		    $witem->command("MSG ".$witem->{name}." ".$url);
		}
	    } else {
		launch_url($url);
	    }
	}
    }
}

foreach (keys %urltypes) {
    Irssi::settings_add_str($IRSSI{'name'}, 'openurl_app_'.$_, "screen ".$urltypes{$_}->{cmd});
    Irssi::settings_add_bool($IRSSI{'name'}, 'openurl_watch_'.$_, 1);
}
Irssi::settings_add_int($IRSSI{'name'}, 'openurl_max_urls', 20);
Irssi::settings_add_bool($IRSSI{'name'}, 'openurl_display_context', 1);

Irssi::signal_add_last("message private", "event_private_message");
Irssi::signal_add_last("message public", "event_public_message");
Irssi::signal_add_last("channel topic changed", "event_topic_changed");

#Irssi::signal_add('open url', \&launch_url);

foreach my $cmd ('topics', 'clear', 'paste', 'help') {
    Irssi::command_bind('openurl '.$cmd => sub {
	cmd_openurl("$cmd ".$_[0], $_[1], $_[2]); });
}
Irssi::command_bind('openurl', 'cmd_openurl');

print CLIENTCRAP '%B>>%n '.$IRSSI{name}.' '.$VERSION.' loaded: /openurl help for help';
