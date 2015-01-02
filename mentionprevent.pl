use strict;
use warnings;

our $VERSION = "1.0";
our %IRSSI = (
    authors     => 'Jan Ingvoldstad',
    contact     => 'jan-irssi-mentionprevent-2015@oyet.no',
    name        => 'mentionprevent',
    description => 'Prevent accidental mentions, essentially a mangled oopsie.pl by http://dgl.cx/irssi',
    license     => 'Simplified BSD <https://github.com/jani/irssi/blob/master/LICENSE>',
    url         => 'https://github.com/jani/irssi/mentionprevent.pl',
);

# /SET mentionprevent_regexp                                                     
# This can have nearly anything in it, but you may block some commands if        
# you're not careful. \w may be useful (e.g. blocks "/ m foo bar") but \w+ is    
# problematic (it would block /exec /some/file among other useful things,        
# although if you're a bad typist maybe that is a reasonable trade-off).         

# Example: don't mention "fucker" in any command                                 
Irssi::settings_add_str('misc', 'mentionprevent_regexp', 'fucker');

Irssi::signal_add('send command' => sub {
    my ($command, $server, $rec) = @_;

    my $mention_re = Irssi::settings_get_str('mentionprevent_regexp');

    if ($command =~ /$mention_re/i) {
        Irssi::signal_stop();
        $rec->print('mention prevented: '.$command, MSGLEVEL_CRAP);
    }
});

Irssi::signal_add('setup changed' => sub {
    if (' ' =~ Irssi::settings_get_str('mentionprevent_regexp')) {
        Irssi::active_win->print('Your mentionprevent_regexp matches a space. This is a very bad idea.');
  }
});
