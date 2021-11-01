### Homes#index controller posting to a postcode_checks controller

- HomeController added
- PostcodeChecksController added
  - Wanted to display the form and wanted and wanted a RESTful action to do the actual test.
 
### Fet: Allow postcodes unknown by the API 

Noclementure:
  Prefer AllowedList over Whitelist

- wanted to start here, rather than API, because regardless to whatever the API decides any code in here will be allowed.
  This can shortcut the need for an API call and avoid needing to override the API if the postcode should end up being in the whitelist.

AllowedPostcode
- List of postcodes that we service regardless to LSOA.
- Postcodes can be stored without any formatting because we can easily add back the formatting; they are always end with 1 number and 2 letters.
- Before postcodes are compared with normalise the string by removing spaces and upcase-ing letters

PostcodeChecks::PostcodeChecksIndex Service added
  - Index is the action that the service is associated with
  - I wrap most actions but this is definitely going to be complicated
  - Use the AllowedPostcode to find out if the postcode should be allowed or not.

### Fet: Allow postcodes from within lsoa region

Postcodes.io Error handling
  - 200 is success, everything else is error.
  - https://postcodes.io/docs  Error Handling