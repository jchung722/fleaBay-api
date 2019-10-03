[![Build Status](https://travis-ci.org/jchung722/fleaBay-api.svg?branch=master)](https://travis-ci.org/jchung722/fleaBay-api)
# fleaBay API

**Backend API for fleaBay built with Ruby on Rails**

## Setup/Installation
To install all dependencies, enter the following in the command line:  
```$ bundle install```
  
Make sure to have redis installed on your local machine. The following installs redis via homebrew:  
```$ brew install redis```

## Running Tests
Enter the following command to run all unit tests:   
```$ rails spec```

## Running the Program
Run the redis server:  
```$ redis-server /usr/local/etc/redis.conf```
  
To run the server locally, enter the following command:   
```$ rails s```

The server can be accessed locally at http://localhost:3000/.

## Deployment
The API is deployed on Heroku. It can be accessed at the following url:  
https://fleabay-api.herokuapp.com

## Dependencies
Ruby 2.6.2  
Rails 6.0.0  
PostgreSQL 11.2  
rvm 1.29.9  
Redis server 5.0.5