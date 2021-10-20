#!/usr/bin/bash

# doc
# https://aladhan.com/prayer-times-api

curl --location --request GET 'http://api.aladhan.com/v1/timingsByAddress?method=11&address=tangerang' | json_pp -json_opt pretty,canonical
