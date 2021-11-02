# README

# Product Feedback App - The URL shortening application

## Setup

1. Pull down the app from version control
  - git clone git@github.com:notapatch/permit_postcode.git
2. `bin/setup`

## Tests and CI
 - Make sure tests pass before running anything!
1. `bin/ci` contains all the tests and checks for the app


## Running The App

1. `bin/run`


## Overview

### Controllers
- HomeController - home page
- PostcodeChecksController - the starting point to test if we provide a service 

### Services
- clients/PostcodesIo - Postcodes.io wrapper for the endpoint: `api.postcodes.io/postcodes/`
- PostcodeChecker - uses Postcode and Lsoa to decide if we service an address

### Models
- AllowedLsoa - list of lsoa names that we service
- AllowedPostcode - list of postcodes that we service
- Lsoa - simple wrapper around lsoa data
- Postcode - simple wrapper around Postcode data