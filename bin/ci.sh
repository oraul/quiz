#!/bin/bash
set -e

RAILS_ENV=test

# Check bad smell
bin/rubocop

# Run specs
bin/rspec

# Generate swagger files
bin/rails rswag
