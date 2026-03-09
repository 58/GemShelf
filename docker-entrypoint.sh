#!/bin/bash
set -e

rm -f /rails/tmp/pids/server.pid
bundle exec bin/rails db:prepare

exec "$@"
