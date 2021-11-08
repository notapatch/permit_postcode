# Permit Postcode Technical decisions

## Table of contents

- [Overview](#overview)
- [Database](#database)
- [Boiler plate structure](#boiler-plate-structure)
- [Testing](#testing)
- [What should the system do?](#what-should-the-system-do)
- [What are the requirements?](#what-are-the-requirements)
- [Data](#data)
  - [Postcode data](#postcode-data)
    - [Postcode validation](#postcode-validation)
    - [Postcode format used](#postcode-format-used)
  - [Lsoa](#lsoa)
- [Workflow](#workflow)
  - [Requirement 2, completed first](#requirement-2-completed-first)
    - [1) List of postcodes](#1-list-of-postcodes)
    - [2) Postcode comparison](#2-postcode-comparison)
    - [3) Returning to controller](#3-returning-to-controller)
  - [Requirement 1, completed second](#requirement-1-completed-second)
    - [1) List of allowed LSOA 'locations'](#1-list-of-allowed-lsoa-locations)
    - [2) LSOA comparison](#2-lsoa-comparison)
    - [3) Getting the LSOA for a postcode through postcode.io](#3-getting-the-lsoa-for-a-postcode-through-postcodeio)
    - [4) Putting it all together](#4-putting-it-all-together)
  - [Completion of system tests](#completion-of-system-tests)
  - [Requirement 3](#requirement-3)
  - [Issues](#issues)
    - [More generic controller and service name](#more-generic-controller-and-service-name)
    - [API code will change to support more endpoints](#api-code-will-change-to-support-more-endpoints)

## Overview

Coding test to write a system that decides if a postcode address is covered by a service.

## Database

Sqlite is a good choice for a small project shared to other people and not going into production.
Postgresql would be my preferred choice on a project but convenience to the reviewer trumps that.

## Testing

Testing uses RSpec combined with Capybara for the system tests and VCR to record the API calls.
The style isn't standard, which would be to use `let` at the top of the file with nesting.
I find it confusing and prefer tests to have everything declared within the `it` block, preferring
duplication, with the aim that it's easier to come back to the test at a later date. If I get too
much nesting, I will break it out into separately named files rather than one 200 line test script; this wasn't an
issue on this project.

Obviously, I would write the `house` style of the company.

## Boiler plate structure

The base of the project - with scripts for setup, CI, Security, follow the design in
"Sustainable Web Development with Ruby on Rails" by David Bryant Copeland.

The requirement was to use a linter. I used Rubocop 

## What should the system do?

The actual project seemed to be something like the current website's home page.
Playing with the postcode input I found three states:

- Service person 
- Refuse service of person
- Bad postcode.

For the project these three states were turned into three system tests on `system/homes_spec`.
The requirements were not trivial and they would lead to a complicated controller and controllers are
hard to test. The aim was to keep the PostcodeChecksController as simple as possible and leave
the Service object, PostcodeChecker, to deal with the business logic detailed in the coding test requirements.
Service objects are easier to setup and to test making it better choice for detailed logic than n controller.




## What are the requirements?

The requirements are and I paraphrase:

1. Service postcodes which have an LSOA location name the same as location names we are allowing.  
2. Allow postcodes that match a list we are allowing regardless to requirement 1.  
3. Anything not covered by 1 or 2 will be refused service.  

## Data

The two data structures which would need addressing are Postcodes, a common structure in UK house addresses with a lot
of information available about it, and LSOA which was a new structure for me, corresponding to 1,500 houses, with little
to no information I could find about it.

### Postcode data

#### Postcode validation

The UK Government used to have a regex for matching postcodes, but [there were problems with it.](https://stackoverflow.com/questions/164979/regex-for-matching-uk-postcodes).
The various Regexes can roughly filter user input but it will need to test against an official list of Postcodes to be
sure; in this case we are asked to search using an API endpoint on postcodes.io.

#### Postcode format used

A postcode is made of numbers and capital letters and a space three characters from the end (see:
[UK postcodes](https://www.getthedata.com/postcode)). I decided to remove the space in the postcode
because it simple way to make strings more consistent, more normal. A space-less form of postcode won't
have to be processed before using in an API request.

You can also make the case for keeping the space in the postcode as it would be the most expected form
of a postcode. On reflection it wasn't much more difficult to have normalized to.

```ruby
def normalize
  @postcode.upcase.delete(" ").insert(-4, " ")
end
```

My main argument against spaces would be "spaces are always causing trouble".

### LSOA

What's a LSOA and what do we actually need? I still don't know what exactly the name of what I wanted is. Aa LSOA is a
location covering 1500 people. [The best link I found on it](https://ocsi.uk/2019/03/18/lsoas-leps-and-lookups-a-beginners-guide-to-statistical-geographies/).
It is made up of a text location name and a code, and the requirement was only interested in the text location name.
The name can be more than one word, and so I decided to remove the characters after the last space of the LSOA.

```
   Milton Kenes 014E
   ------------ ----
   Used         Not used 
```

The class wrapper was one of the last things I wrote. I was just going to leave `@lsoa.rpartiion(" ")[0]` in the code
simply because I didn't understand what it was, and I only used this in one place. Waiting till you understand more is
a reasonable choice. However, in this case, anyone coming across this in the code would not know the intention without
the function name around it and the comment above it.

```ruby
class Lsoa
  ...

  # lsoa is made out of a string and a number
  # Example: "Milton Keynes 014E"
  #   - we want the name but not the number
  # I can't find out what the name is actually
  # so chose the generic "name_part"
  def name_part
    @lsoa.rpartition(" ")[0]
  end
end
```



## Workflow

Requirement 1 was more complicated to understand and if you ordered it first in the service you
don't know if you can service or not until requirement 2 has also been tested. So all in all the
easiest thing to do was to start with requirement 2.

I worked through the test in the following order: Requirement 2, Requirement 1, Requirement 3.

## Requirement 2, completed first

For requirement 2:
1. List of postcodes
2. Postcode comparison
3. Returning to controller

### 1) List of postcodes 

AllowedPostcode was the name chosen and it contained only the one attribute `postcode`.

### 2) Postcode comparison

Comparison is aided by the Postcode object. It might confuse someone into thinking it was a database backed 
model, until you look at the code for the class. Basically it's a wrapper around a postcode text string to
avoid primitive obsession; in a few places in the code I was using functions to query or act on the postcode
string and it was cleaned up with the Postcode wrapper.

We need to compare a user entered postcode to the postcode kept in the AllowedPostcode table. Users
can enter lowercase and forget the space. To match a user's search to the AllowedPostcode rows we have
to allow for that. I used the word "normalize" from data normalization.

### 3) Returning to controller 

The hardest part of the requirement was done. It was a matter of adding some branching logic and return
what the controller needs. When you want to return more than one thing to the calling method you
have a few options, exceptions, structures or objects. 

Exceptions should be kept for exceptional cases and a postcode not matching a list of postcodes is not
exceptional. Structure would have worked, but I prefer a returning a Ruby object as they are boring 
and transparent. The only thing unusual is that it is nested but that's about it - the pattern is
described in references [1].

## Requirement 1, completed second

For requirement 1:
1) List of allowed LSOA 'locations'
2) LSOA comparison
3) Getting the LSOA for a postcode through postcodes.io
4) Putting it all together.

### 1) List of allowed LSOA 'locations'

AllowedLsoa was the name chosen, and it only contained the one attribute `lsoa`.

### 2) LSOA comparison

It's quite common to see case insensitive searches by lowercasing strings. It's reasonable code.

```ruby
class AllowedLsoa < ApplicationRecord
  def self.matching?(lsoa)
    where(lsoa: lsoa.strip.downcase).any?
  end
end
```

Other options for comparison matching:
- Arel which has case-insensitive matching, but it would be more complicated to understand.
- Database specific changes to the indexing. Not a consideration for this mini-project.
- creating a normalize method to match the one found on Postcode; not sure if it would be any clearer.


### 3) Getting the LSOA for a postcode through postcode.io

I chose to make a direct call to the API as I assumed, looking at the detailed information about the API, you couldn't
use someone else's wrapper; this was not the case, but I'd already done the work by the time I asked. Example: [Possible API wrapper](https://github.com/jamesruston/postcodes_io)

Not, an API expert, so this step took the most time. Finding examples on the Internet are either trivial or much more
complicated than you were intending to do for an API call on a small project. [Drifting Ruby had a wrapper for an API
call - which demonstrated the gateway pattern - see below](https://www.driftingruby.com/episodes/service-objects-for-api-interactions-with-twilio)
and a much larger [API Wrapper, Rubygems](https://gorails.com/episodes/api-requests-with-faraday?autoplay=1). Which gave
me the basics of trying to understand an API wrapper as well as example of using Faraday.

I choose Faraday as it was popular and [flexible](https://lostisland.github.io/faraday/adapters/), and I had a working
example.

I put all the postcodes.io related code under the `services/clients`. The idea was to follow the
[gateway pattern](https://martinfowler.com/articles/gateway-pattern.html) and have any code that needed to access
postcodes.io should do it through this client.


### 4) Putting it all together

Now the LSOA was available, we could update the postcode_checker and the associated tests to drive through and get the
requirement. 

## Requirement 3

Requirement 3 dropped out with the work of requirement 2. It was simply any postcode that had an LSOA but failed the
to find a matching AllowedLsoa.

## Completion of system tests

With all the requirements done. Everything was in place to finish the original 3 system tests written at the start
of the project.

## Issues

Nothing is perfect. The more obvious places where things might change.

### More generic controller and service name

The controller and Service were named after "Postcode Checker", it's probably too specific. If there's additional
requirements it will likely have to change. The desire of the business is to know if we are giving service
to a postcode. Currently it's a postcode but there could be restrictions in age or service they can give to
a location. Something more generic might be better description: `PermitService` / `OfferService` / `GiveService`

### API code will change to support more endpoints

The client `class PostcodesIo` would change if more endpoints needed supporting. Other wrappers I've looked
at tend to have simple base classes and shared objects - a common shared object allows you to access hash structures with
dot notation to make it more Rubyish. I'm not going to second guess other than to say it would be complicated to get the
second, or more, end points until a pattern emerged.


## References

[1] - [Sustainable Web Development with Ruby on Rails by David Bryant Copeland](https://sustainable-rails.com/)