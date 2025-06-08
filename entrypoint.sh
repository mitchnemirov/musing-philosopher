#!/bin/bash

bundle check || bundle install --jobs 20 --retry 5

set -e

bundle exec ${@}
