# foodtruck

This implements a quick and dirty script called `foodtruck` for listing out mobile food facilities using the data from [San Francisco's food truck open dataset](https://data.sfgov.org/Economy-and-Community/Mobile-Food-Facility-Permit/rqzj-sfat/data).

## Installation

* Clone this repository
* Install the following CPAN modules:
  * lib::relative
  * Class::Accessor::Fast
  * Text::CSV
  * Readonly
* cd to the repository and execute `prove`. You should see `Result: PASS` if all the tests work.
* Run the script under `scripts/foodtruck` (optionally, symlink `scripts/foodtruck` into your local `bin` directory)

## Sample Run

```
$ foodtruck --dist 1000 --lat 37.7550307267667 --long -122.384530734223 --food taco
 Name                                                    | Address              | Food Items                                                | Distance
---------------------------------------------------------+----------------------+-----------------------------------------------------------+----------
 Bay Area Mobile Catering, Inc. dba. Taqueria Angelica's | 1301 CESAR CHAVEZ ST | Tacos: Burritos: Tortas: Quesadillas: Sodas: Chips: Candy | 856m
 ```

## Manual

Usage information is provided in [the manual page](MANUAL.md).

## Improvements if I had more than 3 hours

* Currently, the data is stored in `<repository>/data/Mobile_Food_Facility_Permit.csv`.
  The module that interacts with the data file has the option to specify an alternate
  location for the data file (in fact, it uses this to point to a separate copy of the
  data under the `t/data` directory for testing), but it would be useful to add a `--data`
  parameter to the script to allow it to point to a different copy of the data.

* The data file is currently static. It would be nice to add an option to refresh the data
  [using the endpoint provided](https://data.sfgov.org/api/views/rqzj-sfat/rows.csv) and
  store the updated data for future use.

* Allow specifying what columns of data are displayed from the dataset. Currently,
  only the Applicant, Address, and FoodItems columns are displayed (and the distance if
  we are filtering by distance), but I can easlily see people using the script wanting
  to see different columns.

* Store the latitude and longitude for your distance search in a `$HOME/.foodtruckrc` file,
  making `--latitude` and `--longitude` optional.