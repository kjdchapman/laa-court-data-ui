# Court data UI (a.k.a View court data)
An interace to the [laa-court-data-adaptor](https://github.com/ministryofjustice/laa-court-data-adaptor) for displaying information available from the HMCTS "common platform" API.

[![Code Climate](https://codeclimate.com/github/ministryofjustice/laa-court-data-ui/badges/gpa.svg)](https://codeclimate.com/github/ministryofjustice/laa-court-data-ui)
[![Test Coverage](https://codeclimate.com/github/ministryofjustice/laa-court-data-ui/badges/coverage.svg)](https://codeclimate.com/github/ministryofjustice/laa-court-data-ui/coverage)

## System dependencies
- postgres
- ruby 2.7.0+
- rails 6.0.2.1+
- nvm
- node 12.4.1+
- yarn 1.21.1+


## Quick start (on macosx)
```
make install

# in separate terminal
make run

make open
```

## Setup

Clone:
```
# clone
git clone https://github.com/ministryofjustice/laa-court-data-ui
cd laa-court-data-ui
```

Install on MacOSX:
```
# check ./Makefile for individual installation steps
make install
```

Install app dependencies (step-by-step):
```
# install ruby if required
rvm install $(cat .ruby-version)

# install gems
bundle install

# install node (using projects version `.nvmrc`)
nvm install

# install node modules using yarn
yarn install --frozen-lockfile

# setup database
rails db:setup
rails db:migrate
rails db:seed
```

## Assets
The rails asset pipeline is disabled and all related config is commented out (it does not seem possible to remove sprockets entirely). We are using `webpacker` gem wrapper for `webpack`, and `yarn` for js dependency management.

To run app locally (development mode) you will therefore need to run both the `rails server` and the `webpack-dev-server` (for asset serving). see [Development](#Development)

## Development

To run the app locally you can generally use just `rails server`, however optional components can be run depending on your needs.

Run separate servers per terminal
```
# terminal-1
rails server

# terminal-2 (assets server - this may not be needed?!)
bin/webpack-dev-server

# terminal-3 (fake adaptor API - see below)
rackup lib/fake_court_data_adaptor/config.ru
```

or using a single terminal and foreman and includes fake API server
```
foreman start -f Procfile.dev

# alternative, runs above command
make run
```

## Testing

#### Ruby 2.7 deprecation warnings
There are a lot of warnings related to ruby 2.7 and rails 6.0.2.1. These are largely related to use of keyword arguments, such as below, and should be fixed
in rails patches in the future:
```
..action_dispatch/middleware/stack.rb:37: warning: Using the last argument as keyword parameters is deprecated; maybe ** should be added to the call
```

To suppress warnings now you can prefix any call that raises such warnings with `RUBYOPT=-W:no-deprecated`:
```
RUBYOPT=-W:no-deprecated rspec
RUBYOPT=-W:no-deprecated rails server
```


## Makefile
You can use the `make` command as follows:

```
# get help - check what make commands are available
make

# simple first install (assuming you have `rvm` and `nvm` installed)
make install

#run the app
make run

# run the entire test suite
make test
```

## Local Adaptor and mock API stack setup

- generate OAuth2 `client_credentials` for the UI, via the adaptor
```
cd .../laa-court-data-adaptor
git checkout master
git pull
bin/rails console
> application = Doorkeeper::Application.create(name: 'LAA Court data UI')
> application.yield_self { |r| [r.uid, r.secret] }
=> [6FYXUiqrR3Yuid2ispemVNPUT7-8W0LB1sSmB6c0f3k-example, K122aTsBeRj1GuP7u-Fdi3Vm6uSKaD8K2vq0pPRocIo-example]

# These should be put in the `.env.development.local` - see below
```

- start mock API locally

```
git clone git@github.com:ministryofjustice/hmcts-common-platform-mock-api.git
cd .../hmcts-common-platform-mock-api
```

```
# create some data
...todo
```

```
# start server
rackup -p 9293
```

- start adaptor locally
```
git clone git@github.com:ministryofjustice/laa-court-data-adaptor.git
cd .../laa-court-data-adaptor
```

```
# configure adaptor to use local mock API
# .env.development.local
COMMON_PLATFORM_URL=http://localhost:9293
SHARED_SECRET_KEY_LAA_REFERENCE=super-secret-search-laa-reference-key
SHARED_SECRET_KEY_REPRESENTATION_ORDER=super-secret-search-representation-order-key
SHARED_SECRET_KEY_SEARCH_PROSECUTION_CASE=super-secret-search-prosecution-case-key
SHARED_SECRET_KEY_HEARING=super-secret-hearing-key
```

```
# start server
rackup -p 9292
```

- start UI locally
```
# clone or cd into
git clone git@github.com:ministryofjustice/laa-court-data-ui.git
cd .../laa-court-data-ui
```
-  in `.env.development.local`
```
# configure UI authentication against local adaptor
# .env.development.local
# see 
COURT_DATA_ADAPTOR_API_URL: https://laa-court-data-adaptor-stage.apps.live-1.cloud-platform.service.justice.gov.uk/api/internal/v1
COURT_DATA_ADAPTOR_API_UID: 6FYXUiqrR3Yuid2ispemVNPUT7-8W0LB1sSmB6c0f3k-example
COURT_DATA_ADAPTOR_API_SECRET: K122aTsBeRj1GuP7u-Fdi3Vm6uSKaD8K2vq0pPRocIo-example
```

```
# configure UI to use local adaptor
# .env.development.local
COURT_DATA_ADAPTOR_API_URL: http://localhost:9292
```

```
# start server
rails s
```

## Fake API calling

For development purposes a fake "Court Data Adaptor" API has been provided. This can be used to view
search results in development. The fake API will need updating or removing in future iterations.

To enable the fake API you must:

- set/amend environment variable to point to it
```
# .env.development
COURT_DATA_ADAPTOR_HOST: http://localhost:9292
```

- run the fake API using either of the methods below


```
# run in its own console - uses puma
rackup lib/fake_court_data_adaptor/config.ru
```

```
# run along with app
make run
```

Note, running two puma servers requires that they use separate pid files. The fake api is therefore configured to use tmp/pids/fake_adaptor.pid via its `config.ru`. Bear this in mind if amending the `config/puma/development.rb` files `pidfile` entry, to prevent clashes.

## Notes

#### Initial app generation

This app was generated using the following initial `rails new` command, skipping all components we do not currently need.

```
# generate new rails app
rails new laa-court-data-ui \
--database=postgresql \
--skip-test \
--skip-action-mailer \
--skip-active-storage \
--skip-action-cable \
--skip-turbolinks \
--skip-sprockets
```

Note: The govuk styling was applied following the [GDS design system guide](https://github.com/alphagov/govuk-frontend/blob/master/docs/installation/installing-with-npm.md), using `npm install --save govuk-frontend`. `yarn`
was later used to manage js dependencies. It may have been possible to use
`yarn` from the outset

