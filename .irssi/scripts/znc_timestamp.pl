
use strict;
use warnings;
use vars qw($VERSION %IRSSI);

$VERSION = '0.1';
%IRSSI   = (
    authors     => 'Johannes Plunien',
    contact     => 'plu@pqpq.de',
    description => 'Reformat znc buffer playback messages',
    license     => 'GPL',
    name        => 'znc_timestamp',
    url         => 'https://gist.github.com/gists/1541253',
);

# 20:18:26 < ***> Buffer Playback...
# 20:18:26 < somebody> [18:42:09] foo
# 20:18:26 < somebodyelse> [18:49:10] bar
# 20:18:26 < ***> Playback Complete.

# will be changed to:

# 20:18:26 < ***> Buffer Playback...
# 18:42:09 < somebody> foo
# 18:49:10 < somebodyelse> bar
# 20:18:26 < ***> Playback Complete.

# If you use another timestamp format in znc than the one in the
# example above, you must change following regular expression to
# match your format and capture the wanted parts.
my $TIMESTAMP_REGEX = qr/\[(\d{2}:\d{2}:\d{2})\] /;

my %PLAYBACK;

sub privmsg {
    my ( $server, $data, $nick, $address ) = @_;
    my ( $target, $text ) = split / :/, $data, 2;

    if ( $nick eq '***' && $text eq 'Buffer Playback...' ) {
        $PLAYBACK{$target} = 1;
    }
    elsif ( $nick eq '***' && $text eq 'Playback Complete.' ) {
        delete $PLAYBACK{$target};
    }
    elsif ( $PLAYBACK{$target} ) {
        my $timestamp_format = Irssi::settings_get_str('timestamp_format');
        $text =~ s/$TIMESTAMP_REGEX//;
        Irssi::settings_set_str( 'timestamp_format', $1 );
        Irssi::signal_continue( $server, $target . ' :' . $text, $nick, $address );
        Irssi::settings_set_str( 'timestamp_format', $timestamp_format );
    }
}

Irssi::signal_add( 'event privmsg', 'privmsg' );
