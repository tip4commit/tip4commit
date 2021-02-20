#!/bin/bash

bundle exec rubocop
bundle exec rake spec
bundle exec rake cucumber