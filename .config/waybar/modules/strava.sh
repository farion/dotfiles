#!/bin/bash

STRAVA_CLIENT_ID=$(secret-tool lookup strava strava_client_id)
STRAVA_CLIENT_SECRET=$(secret-tool lookup strava strava_client_secret)
STRAVA_REFRESH_TOKEN=$(secret-tool lookup strava strava_refresh_token)
STRAVA_ATHLETE_ID=$(secret-tool lookup strava strava_athlete_id)

export ACCESS_TOKEN=$(curl -s -X POST https://www.strava.com/api/v3/oauth/token \
	  -d client_id=${STRAVA_CLIENT_ID} \
	  -d client_secret=${STRAVA_CLIENT_SECRET} \
	  -d grant_type=refresh_token \
	  -d refresh_token=${STRAVA_REFRESH_TOKEN} | jq -r '.access_token' | xargs)

DISTANCE=$(curl -s -X GET https://www.strava.com/api/v3/athletes/${STRAVA_ATHLETE_ID}/stats -H "Authorization: Bearer ${ACCESS_TOKEN}" | jq -r ".ytd_ride_totals | .distance")

KM=$(echo -n $DISTANCE | awk '{print int($1/1000)}')

echo -n '{"text": "🚴'"$KM"km'","class":"charging"}'
