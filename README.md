# Boosket Shop

## System Info

- ruby 1.9.3
- eventmachine
- rails 3.2.0'
- mysql
- redis
- mongo

## Required Elements

- Mac OSX
  - `brew install qt --build-from-source`

- GNU/Linux
  - `sudo apt-get install libqt4-dev qt4-qmake`

- Windows
  - hein? ;)

## Setup Instructions (RVM is required)
- `gem install bundler`
- `bundle install`

## Run Test Suites

- `rake spec` for integration and unit tests
- `guard --group frontend`
- `guard --group backend` 

## Setup Guide

- clone the repo, obviously :)
- `gem install bundler`
- `bundle install`
- `rake db:create`
- `rake db:migrate`
- `rake db:seed`
- `rails s`

## Deployments

- Staging | staging.shop.boosket.com (stage branch)
  - `cap staging deploy`
- Production | shop.boosket.com (master branch)
  - `cap staging deploy`


## Note requirement
- bundler 1.2.0 (for specified ruby version)
  - `gem install bundler --pre`


## Paypal account (dev)
- Admin
  - https://developer.paypal.com/
  - dev@boosket.com
  - azeazeaze

- Test account
  - bsk01_1347289546_per@boosket.com
  - azeazeaze

## Tunnel for remote port fowarding
`ssh -vv -nNT -g -R *:{YOUR_PORT}:0.0.0.0:{PORT_APPLICATION}boosket@albundy.boosket.com`
