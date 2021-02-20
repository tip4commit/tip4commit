#!/bin/bash

RAILS_ENV=development bundle exec rake db:drop
RAILS_ENV=development bundle exec rake db:create
RAILS_ENV=development bundle exec rake db:migrate

RAILS_ENV=test bundle exec rake db:drop
RAILS_ENV=test bundle exec rake db:create
RAILS_ENV=test bundle exec rake db:migrate
