#!/bin/bash

STRAVA_CLIENT_ID=$(secret-tool lookup strava strava_client_id)
STRAVA_CLIENT_SECRET=$(secret-tool lookup strava strava_client_secret)
STRAVA_REFRESH_TOKEN=$(secret-tool lookup strava strava_refresh_token)
STRAVA_ATHLETE_ID=$(secret-tool lookup strava strava_athlete_id)

OTHERS=("Julien:43073412"
	"MarcA:41126762"
	"FriederP:136088435")

export ACCESS_TOKEN=$(curl -s -X POST https://www.strava.com/api/v3/oauth/token \
	-d client_id=${STRAVA_CLIENT_ID} \
	-d client_secret=${STRAVA_CLIENT_SECRET} \
	-d grant_type=refresh_token \
	-d refresh_token=${STRAVA_REFRESH_TOKEN} | jq -r '.access_token' | xargs)

year_km() {
	DISTANCE=$(curl -s -X GET https://www.strava.com/api/v3/athletes/${1}/stats -H "Authorization: Bearer ${ACCESS_TOKEN}" | jq -r ".ytd_ride_totals | .distance")
	echo -n $DISTANCE | awk '{print int($1/1000)}'
}

KM=$(year_km $STRAVA_ATHLETE_ID)

TOOLTIP=""

#for OTHER in "${OTHERS[@]}"; do
#	KEY=${OTHER%%:*}
#	VALUE=${OTHER#*:}
#	OKM=$(year_km $VALUE)
#	TOOLTIP="${TOOLTIP}${KEY} ${OKM}km\n"
#done

echo -n '{"text": "🚴'"$KM"km'","class":"charging", "tooltip": "'"$TOOLTIP"'"}'
