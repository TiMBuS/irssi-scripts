use strict;
use vars qw($VERSION %IRSSI);

$VERSION = '1.0.0';
%IRSSI = (
	authors         => 'Trevor "tee" Slocum',
	contact         => 'tslocum@gmail.com',
	name            => 'AutoClearInput',
	description     => 'Automatically clears pending input when you are away.',
	license         => 'GPLv3',
	url             => 'https://github.com/tslocum/irssi-scripts',
	changed         => '2014-05-01'
);

my ($autoclear_tag);

sub autoclear_key_pressed {
	return if (Irssi::settings_get_int("autoclear_sec") <= 0);

	if (defined($autoclear_tag)) {
		Irssi::timeout_remove($autoclear_tag);
	}

	$autoclear_tag = Irssi::timeout_add(Irssi::settings_get_int("autoclear_sec") * 1000, "autoclear_timeout", "");
}

sub autoclear_timeout {
	return if (Irssi::settings_get_int("autoclear_sec") <= 0);
	
	Irssi::gui_input_set("");
}

Irssi::settings_add_int("misc", "autoclear_sec", 30);
Irssi::signal_add_last("gui key pressed", "autoclear_key_pressed");

print $IRSSI{name} . ': v' .  $VERSION . ' loaded. Pending input ' .
	(Irssi::settings_get_int("autoclear_sec") > 0
	? ('will be cleared after %9' . Irssi::settings_get_int("autoclear_sec") . ' seconds%9 of idling.')
	: 'clearing is currently %9disabled%9.');
print $IRSSI{name} . ': Configure this delay with: /SET autoclear_sec <seconds>  [0 to disable]';
