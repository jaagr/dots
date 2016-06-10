# Fixes for multiple servers and window items by dg
#
# 2003-08-27 coekie:
# - use item names and server tags, fixes irssi crash if window item or server is destroyed
#
# 2003-08-19
#  - changed timer stop code a bit.
#    should fix the random timer o.O never happened to me before.
#
# 2002-12-21 darix:
#  - nearly complete rewrite ;) the old version wasnt "use strict;" capable =)
#  - still some warnings with "use warnings;"
#  - use of command_runsub now :)
#

use strict;
use Data::Dumper;
use warnings;
use vars  qw ($VERSION %IRSSI);
use Irssi 20020325 qw (command_bind command_runsub command timeout_add timeout_remove signal_add_first);

$VERSION = '0.6';
%IRSSI = (
    authors     => 'Kimmo Lehto, Marcus Rueckert',
    contact     => 'kimmo@a-men.org, darix@irssi.org' ,
    name        => 'Timer',
    description => 'Provides /timer command for mIRC/BitchX type timer functionality.',
    license     => 'Public Domain',
    changed     => '2015-02-07'
);

our %timers;
# my %timer = { repeat => \d+, command => '' , windowitem => NULL , server=> NULL, timer = NULL};

sub timer_command {
    my ( $name ) = @_;
    if ( exists ( $timers{$name} ) ) {
        if ( $timers{$name}->{'repeat'} != -1 ) {
            if ( $timers{$name}->{'repeat'}-- == 0) {
                cmd_timerstop( $name );
                return;
            }
        }

        my ($server, $item);
        if ($timers{$name}->{'server'}) {
            $server = Irssi::server_find_tag( $timers{$name}->{'server'} );
        }
        if ( $server ) {
	    if ( $timers{$name}->{'windowitem'}) {
                $item = $server->window_find_item( $timers{$name}->{'windowitem'} );
            }
            ($item ? $item : $server)->command( $timers{$name}->{'command'} );
        } else {
            command( $timers{$name}->{'command'} );
        }
    }
}

sub cmd_timerstop {
    my ( $name ) = @_;

    if ( exists ( $timers{$name} ) ) {
        timeout_remove($timers{$name}->{'timer'});
        $timers{$name} = ();
        delete ( $timers{$name} );
        print( CRAP "Timer \"$name\" stopped." );
    }
    else {
        print( CRAP "\cBTimer:\cB No such timer \"$name\"." );
    }
}

sub cmd_timer_help {
    print ( <<EOF

TIMER LIST
TIMER ADD  <name> <interval in seconds> [<repeat>] <command>
TIMER STOP <name>

repeat value of 0 means unlimited too

EOF
    );
}

command_bind 'timer add' => sub {
    my ( $data, $server, $item ) = @_;
    my ( $name, $interval, $times, $command );

    if ( $data =~ /^\s*(\w+)\s+(\d+(?:\.\d+)?)\s+(-?\d+)\s+(.*)$/ ) {
        ( $name, $interval, $times, $command ) = ( $1, $2, $3, $4 );
        $times = -1 if ( $times == 0 );
    }
    elsif ( $data =~ /^\s*(\w+)\s+(\d+(?:\.\d+)?)\s+(.*)$/ )
    {
        ( $name, $interval, $times, $command ) = ( $1, $2, -1, $3 );
    }
    else {
        print( CRAP "\cBTimer:\cB parameters not understood. commandline was: timer add $data");
        return;
    };

    if ( $times < -1 ) {
        print( CRAP "\cBTimer:\cB repeat should be greater or equal to -1" );
        return;
    };

    if ( $command eq "" ) {
        print( CRAP "\cBTimer:\cB command is empty commandline was: timer add $data" );
        return;
    };

    if ( exists ( $timers{$name} ) ) {
        print( CRAP "\cBTimer:\cB Timer \"$name\" already active." );
    }
    else {
        #$timers{$name} = {};
        $timers{$name}->{'repeat'}     = $times;
        $timers{$name}->{'interval'}   = $interval;
        $timers{$name}->{'command'}    = $command;
	if ($item) {
            $timers{$name}->{'windowitem'} = $item->{'name'};
	}
	if ($server) {
            $timers{$name}->{'server'}     = $server->{'tag'};
	}

        if ( $times == -1 ) {
            $times = 'until stopped.';
        }
        else {
            $times .= " times.";
        }

        print( CRAP "Starting timer \"$name\" repeating \"$command\" every $interval seconds $times" );

        $timers{$name}->{'timer'} = timeout_add( $interval * 1000, \&timer_command, $name );
    }
};

command_bind 'timer list' => sub {
    print( CRAP "Active timers:" );
    foreach my $name ( keys %timers ) {
        if ( $timers{$name}->{repeat} == -1 ) {
            print( CRAP "$name = $timers{$name}->{'command'} (until stopped)");
        }
        else {
            print( CRAP "$name = $timers{$name}->{'command'} ($timers{$name}->{'repeat'} repeats left)" );
        }
    }
    print( CRAP "End of /timer list" );
};

command_bind 'timer stop' => sub {
    my ( $data, $server, $item ) = @_;
    cmd_timerstop ($data);
};

command_bind 'timer help' => sub { cmd_timer_help() };

command_bind 'timer' => sub {
    my ( $data, $server, $item ) = @_;
    $data =~ s/\s+$//g;
    command_runsub ( 'timer', $data, $server, $item ) ;
};


signal_add_first 'default command timer' => sub {
#
# gets triggered if called with unknown subcommand
#
    cmd_timer_help()
}
