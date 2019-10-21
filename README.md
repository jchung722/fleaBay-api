[![Build Status](https://travis-ci.org/jchung722/fleaBay-api.svg?branch=master)](https://travis-ci.org/jchung722/fleaBay-api)
# fleaBay API

**Backend API for fleaBay built with Ruby on Rails**

## Dependencies
Ruby 2.6.2  
Rails 6.0.0  
PostgreSQL 11.2  
rvm 1.29.9  
Redis server 5.0.5

## Setup/Installation
To install all dependencies, enter the following in the command line:  
```$ bundle install```  

Make sure postgreSQL is installed and running on your machine:  
https://www.postgresql.org/download/

Create database schema:  
```$ rails db:migrate```
  
Regenerate credentials for jwt sessions:  
1. Run `rails credentials:show` in terminal and copy content of original credentials somewhere temporarily.
2. Remove `config/credentials.yml.enc`
3. Run `EDITOR=vim rails credentials:edit` in the terminal: This command will create a new `config/master.key` and `config/credentials.yml.enc` if they do not exist.
4. Paste the original credentials you copied (step 1) in the new credentials file.
5. Save + quit vim.
  
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

To deploy to heroku:  
```$ git push heroku master```  

Update heroku database schema:  
```$ heroku run rake db:migrate```

## Routes
The following routes are available from the above base urls:  
  

| HTTP Verb | Path | Params | Used For |
| --------- | ---- | ------ | -------- |
| GET | `/auctions` | - | get all auctions |
| POST | `/auctions` | name, description, picture, end_date, user_id | create an auction |
| GET | `/auctions/:id` | - | get auction by id |
| PUT | `/auctions/:id` | name, description, picture, end_date | update auction attribute |
| DELETE | `/auctions/:id` |  - | delete auction by id |
| POST | `/auctions/:id/bids` |  amount, user_id | create a bid for specified auction |
| POST | `/refresh` | - | refresh csrf token |
| POST | `/signup` | email, password | create user |
| POST | `/signin` | email, password | signin as user |
| DELETE | `/signin` | - | signout user |
