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

In the `config/pds.yaml` configuration file, set the `database` key.

```yaml
# Use mock for a quick test
---
database:
  adapter: mock
```

```yaml
# Use postgresql for a real deployment
---
database:
  adapter: postgresql
  encoding: unicode
  pool: 5
  host: <%= ENV['DATABASE_HOST'] %>
  database: <%= ENV['DATABASE_NAME'] %>
  username: <%= ENV['DATABASE_USER'] %>
  password: <%= ENV['DATABASE_PASSWORD'] %>
```

#### PostgreSQL

Create the database

```
rake db:create
rake db:migrate
```

### Create the admin token

A rake tasks exists to let you create an "admin" user and set its token to a supplied string, in order to gain initial access to the application.

```
rake app:set_admin_token[tokenstring]
```

Note: If you have zsh installed in your local environment, [you will have troubles running this rake task](https://thoughtbot.com/blog/how-to-use-arguments-in-a-rake-task), the quick solution is to run the task by wrapping the task name in quotes: `rake 'app:set_admin_token[tokenstring]'`

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
