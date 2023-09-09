package DataSF::MobileFoodFacility::Permit;
use parent qw( Class::Accessor::Fast );
use strict;
use warnings;
use 5.010;

use Readonly;

Readonly::Array my @FIELDS =>  qw/
  locationid Applicant FacilityType cnn LocationDescription Address blocklot
  block lot permit Status FoodItems X Y Latitude Longitude Schedule dayshours
  NOISent Approved Received PriorPermit ExpirationDate Location Fire
  Prevention Districts Police Districts Supervisor Districts Zip Codes
  Distance
/;
__PACKAGE__->mk_ro_accessors( @FIELDS, 'Neighborhoods' );

sub new {
  my ( $class, $data ) = @_;
  my $self = {};
  foreach my $field (@FIELDS) {
    $self->{$field} = $data->{$field};
  }
  # rename 'Neighborhoods (old)' to 'Neighborhoods'
  $self->{Neighborhoods} = $data->{'Neighborhoods (old)'};
  return bless $self, $class;
}

1;

__END__
 
=head1 DESCRIPTION

Provide an accessor class that wraps the data from the dataset.
When the results of the search are filtered by distance from a location,
a 'Distance' accessor will provide the distance in meters.

=cut