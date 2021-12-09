# Puppet Data Service API

## Overview

The Puppet Data Service (PDS) API uses the [Sinatra](http://www.sinatrarb.com/) framework to support a RESTful API.

The API documentation was made following the OpenAPIv3 specifications and can be found in the `../docs` folder

## Prerequisites

* Ruby 3.0.0
* PostgreSQL

## Getting started

### Install the dependencies

* Install the Gems listed in the Gemfile

    cd app/
    bundle install

* Create the DB (PostgreSQL)

    rake db:create

* Make sure you have the latest DB schema

    rake db:migrate

### Connect your DataAdapter

Inside the `pds_app.rb` file, make sure to change your `DataAdapter`

```
# Use mock for a quick test
set 'database', { 'type' => 'unconfigured' }
```

### Running the service

To run the generated server, please run the following:

```
cd code/
bundle config set path lib
bundle install 
bundle exec rackup -p 8080
```

You can access the application by the following URL:

```
http://localhost:8080/v2/store/inventory
```

## Docker
If you want to use a web server other than webrick, you need to edit the generated Dockerfile to prepare the compiler and the make command. Please check the comment of the Dockerfile.

To run the code on docker, you can use the Dockerfile as follows:

### Build the docker image
The "container_name" can be changed for your preferences.

```
docker build . --tag "container_name"
```

### Run the docker image

```
docker run -it --rm -p 8080:8080 "container_name"
```

Voila!
