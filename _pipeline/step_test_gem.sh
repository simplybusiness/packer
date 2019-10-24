#!/bin/bash
source "/opt/sb/sb-pipeline.sh"
set -e

cd example_app
bundle install
bundle exec rake
