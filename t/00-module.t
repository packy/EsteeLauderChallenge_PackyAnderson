#!perl
use strict;
use warnings;

use lib::relative '../lib';

use File::Basename;
use Try::Tiny;

use constant TESTCOUNT => 8;
use Test::More tests => &TESTCOUNT;

try {
  use_ok "DataSF::MobileFoodFacility";

  my $datafile = dirname(__FILE__) . '/data/test.csv';
  my $trucks = DataSF::MobileFoodFacility->new( datafile => $datafile );
  isa_ok($trucks, "DataSF::MobileFoodFacility");

  my @results = $trucks->filter( status => 'ANY' ); 
  cmp_ok(@results, '==', 481, "Unfiltered results");

  @results = $trucks->filter( status => 'APPROVED' );
  cmp_ok(@results, '==', 153, "Specified APPROVED");
  my $first = $results[0]; # save the first for later

  @results = $trucks->filter();
  cmp_ok(@results, '==', 153, "Default APPROVED");

  @results = $trucks->filter( food_items => 'coffee' );
  cmp_ok(@results, '==', 16, "APPROVED with coffee");

  @results = $trucks->filter( food_items => 'burrito' );
  cmp_ok(@results, '==', 77, "APPROVED with burrito");

  @results = $trucks->filter(
    distance  => 1000,
    latitude  => $first->Latitude,
    longitude => $first->Longitude
  );
  cmp_ok(@results, '==', 12, "Within 1km of first permit")
}
catch {
  my $error = $_;  # Try::Tiny puts the error in $_
  warn "Tests died: $error";
};

done_testing();
exit;