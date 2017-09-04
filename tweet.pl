#!/usr/bin/perl

use strict;
use warnings;

use Config::Simple;
use Net::Twitter::Lite::WithAPIv1_1;
use File::Random qw/:all/;
use File::Basename;
use Cwd 'abs_path';

my $path = dirname(abs_path($0));
my $config = new Config::Simple("${path}/config.ini");

my $twitter = Net::Twitter::Lite::WithAPIv1_1->new(
	access_token => $config->param('token'),
	access_token_secret => $config->param('tokensecret'),
	consumer_key => $config->param('consumerkey'),
	consumer_secret => $config->param('consumersecret'),
	legacy_lists_api => 0,
);

eval {
	$twitter->update_with_media($config->param('message'), [ $config->param('picsdir') . '/' . random_file(-dir => $config->param('picsdir')) ]);
};
if ( my $err = $@ ) {
	die $@ unless blessed $err && $err->isa('Net::Twitter::Lite::Error');
	warn "HTTP Response Code: ", $err->code, "\n",
	     "HTTP Message......: ", $err->message, "\n",
	     "Twitter error.....: ", $err->error, "\n";
}
