#!/bin/bash
set -e

# Check bad smell
bin/rubocop

# Run specs
bin/rspec

# Generate swagger files
bin/rails rswag
