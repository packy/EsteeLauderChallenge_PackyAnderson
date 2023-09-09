# NAME

**foodtruck** - list out food trucks in San Francisco

# SYNOPSIS

foodtruck \[options\]

    Options:
      --food_items  Specify a string to search for in the food item field

      --distance    Specify a distance in meters. Requires --latitude
                    and --longitude
      --latitude    Specify a latitude for a location to calculate distance
      --longitude   Specify a longitude for a location to calculate distance

      --any         Show food trucks regardless of permit status
      --active      (default) Show only trucks with approved permits
      --approved    Show only trucks with approved permits
      --expired     Show only trucks with expired permits
      --requested   Show only trucks with requested permits
      --suspended   Show only trucks with suspended permits

      --help        Show a brief help message
      --man         Show the entire man page

# OPTIONS

- **--food\_items**

    Filter the results by matching the given string against the FoodItems
    field in the dataset. The string will be matched as a regular expression.

- **--distance**
- **--latitude**
- **--longitude**

    Specify a limit for how far the food truck can be from a given location.
    All three parameters, **--distance**, **--latitude**, and **--longitude**
    must be specified.

- **--active** (default)
- **--approved**
- **--expired**
- **--requested**
- **--suspended**
- **--any**

    Filter the results based on the Status field in the dataset. The statuses are

    - APPROVED
    - EXPIRED
    - REQUESTED
    - SUSPENDED

    The option **--active** is provided as an alias to the status "APPROVED", and
    is the default if no status is specified. The option **--any** will disable
    filtering based on the Status field.

- **--help**

    Print a brief help message and exits.

- **--man**

    Prints the manual page and exits.

# DESCRIPTION

**foodtruck** is a quick and dirty script for listing out mobile food
facilities using the data from San Francisco's food truck open dataset.
