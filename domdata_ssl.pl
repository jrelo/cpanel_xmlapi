#!/usr/bin/perl
#view domaindata for domain using cPanel xml-api.
use strict;
use LWP::UserAgent;
use XML::Simple;
use Data::Dumper;
use HTTP::Cookies;

my $num_args = $#ARGV + 1;
if ($num_args != 1) {
    print "\nUsage: $0 <domain.com>\n";
    exit;
}

$ENV{PERL_LWP_SSL_VERIFY_HOSTNAME} = 0;
my $hostname = 'localhost';
my $protocol = 'https';
open(FH, '<', '/root/.accesshash');
my $accesshash = '';
while(<FH>) {
    chomp();
    $accesshash .= $_;
}
close(FH);

my $domain = $ARGV[0];
my $ua = LWP::UserAgent->new(
cookie_jar => HTTP::Cookies->new,
);
my $request = HTTP::Request->new( GET => "$protocol://$hostname:2087/xml-api/domainuserdata?domain=$domain" );
$ua->default_header( 'Authorization' => "WHM root:$accesshash" );
my $response = $ua->request($request);
my $xml_string = $response->content;
my $xml_hashref = XMLin($xml_string);
print "$response\n$xml_hashref\n$xml_string\n";
