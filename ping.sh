#!/bin/bash

set -e

# ping.sh 1200 to ping endpoint every 20 minutes
# Heroku shuts down Hobby dynos after 30 minutes with no usage

ping -i"$1" https://fa-playlist.herokuapp.com
