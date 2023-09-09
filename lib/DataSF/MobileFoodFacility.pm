package DataSF::MobileFoodFacility;
use parent qw( Class::Accessor::Fast );
use strict;
use warnings;
use 5.010;

use Carp;
use File::Spec;
use Math::Trig;
use Text::CSV qw( csv );

__PACKAGE__->mk_accessors( qw/ datafile data / );

use DataSF::MobileFoodFacility::Permit;

=head1 DataSF::MobileFoodFacility

=head2 METHODS

=head3 B<new> ARGS

The C<new> method accepts one optional named argument in a hash: C<datafile>.
If specified, this should be the pathname to the data file that will be used.
If not specified, the default is to use the data file C<Mobile_Food_Facility_Permit.csv>
in the C<data> directory next to the C<lib> directory that contains this module.

=cut

sub new {
  my ( $class, %args ) = @_;
  my $self = {};
  if (exists $args{datafile}) {
    $self->{datafile} = $args{datafile};
  }
  else {
    # get the directory of the current file
    my($vol, $directories ) = File::Spec->splitpath( __FILE__ );
    my @dirs = File::Spec->splitdir( $directories );
    while ($dirs[-1] ne 'lib') {
      pop @dirs; # discard all directories up to lib
    }
    pop @dirs; # discard lib
    push @dirs, 'data';
    $directories = File::Spec->catdir( @dirs );
    my $file = 'Mobile_Food_Facility_Permit.csv';
    $self->{datafile} = File::Spec->catpath( $vol, $directories, $file );
  }
  unless (-f $self->{datafile}) {
    carp "Unable to open data file " . $self->{datafile} . ": $!";
  }

  $self->{data} = undef;

  return bless $self, $class;
}

=head3 B<read_data>

The C<read_data> method accepts no arguments; it re-reads the data from the 
data file associated with this object.

=cut

sub read_data {
  my $self = shift;
  # because the file is small, we're reading it entirely into memory
  $self->{data} = csv( in => $self->{datafile}, headers => 'auto' );
}

=head3 B<filter> ARGS

The C<filter> method accepts several optional arguments in a hash, filters
the data based on those arguments, and returns the results as a list of 
B<DataSF::MobileFoodFacility::Permit> objects.

    status => 'string'
        filters the data based on the Status field; known values are
        APPROVED, EXPIRED, REQUESTED and SUSPENDED. The special value
        ANY disables filtering on the Status field. If omitted, rows
        matching Status == APPROVED are returned.

    food_items => 'string'
        filters the data based on the FoodItems field.

    distance => numeric
    latitude => numeric
    longitude => numeric
        calculate the distance from the specified location to the
        location based on the row's Latitude and Longitude fields,
        then filters for values less than or equal to the specified
        distance.

=cut

sub filter {
  # method to filter the permits based on various criteria
  my ( $self, %args ) = @_;
  $self->read_data();

  # if we weren't given a status, default to APPROVED
  if (! exists $args{status}) {
    $args{status} = 'APPROVED';
  }
  if ($args{status} ne 'ANY') {
    @{ $self->{data} } = grep {
      $_->{Status} =~ /$args{status}/i # look for items with desired status
    } @{ $self->{data} };
  }

  # filter based on food items
  if (exists $args{food_items}) {
    @{ $self->{data} } = grep {
      $_->{FoodItems} =~ /$args{food_items}/i # look for items that match the given string
    } @{ $self->{data} };
  }

  # filter based on location
  if (exists $args{distance}) {
    if (! exists $args{latitude} || ! exists $args{longitude}) {
      carp "filtering based on distance requires 'distance', 'latitude' and 'longitude'";
    }
    if (! $self->_is_numeric($args{latitude})) {
      carp "Value '$args{latitude}' for 'latitude' must "
         . "be a numeric value";
    }
    elsif ( $args{latitude} < -90 || $args{latitude} > 90 ) {
      carp "Value '$args{latitude}' for 'latitude' must "
         . "be between -90 and 90";
    }
    if (! $self->_is_numeric($args{longitude}) ) {
      carp "Value '$args{longitude}' for 'longitude' must "
         . "be a numeric value";
    }
    elsif ( $args{longitude} < -180 || $args{longitude} > 180) {
      carp "Value '$args{longitude}' for 'longitude' must "
         . "be between -180 and 180";
    }
    @{ $self->{data} } = grep {
      my $distance = $self->_distance($_->{Latitude},  $_->{Longitude},
                                      $args{latitude}, $args{longitude});
      $_->{Distance} = $distance; # if we're filtering on distance, add it as a field
      $distance <= $args{distance}
    } @{ $self->{data} };
  }

  return map { DataSF::MobileFoodFacility::Permit->new($_) } @{ $self->{data} };
}

sub _is_numeric {
  my($self, $value) = @_;
  return $value =~ /^-?\d+(\.\d*)?$/;
}

sub _distance {
  # using https://www.movable-type.co.uk/scripts/latlong.html for formulas
  my($self, $lat1, $long1, $lat2, $long2) = @_;
  my $R = 6371e3; # metres
  my $phi1 = $lat1 * pi/180; # φ, λ in radians
  my $phi2 = $lat2 * pi/180; # φ, λ in radians
  my $delta_phi    = ($lat2  - $lat1)  * pi/180;
  my $delta_lambda = ($long2 - $long1) * pi/180;

  my $a = sin($delta_phi/2) * sin($delta_phi/2) +
          cos($phi1) * cos($phi2) *
          sin($delta_lambda/2) * sin($delta_lambda/2);
  my $c = 2 * atan2(sqrt($a), sqrt(1 - $a));
  return abs($R * $c);
}

1;

__END__

=head1 DESCRIPTION

Provide a class that reads the dataset and provides a method for filtering
the data based on the fields. Currently supported are distance from a location,
status of the permit, and contents of the FoodItems field. Results are returned
as a list of B<DataSF::MobileFoodFacility::Permit> objects.



=cut