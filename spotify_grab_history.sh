#!/bin/bash

# spotify_grab_history.sh
#
# A script to pull and save the last 10 songs played on Spotify
# using a valid Spotify access token.


response=$(curl -X "GET" "https://api.spotify.com/v1/me/player/recently-played?limit=10" \
-H "Accept: application/json" \
-H "Content-Type: application/json" \
-H "Authorization: Bearer $(jq -r '.access' .config/spotify_client_creds.json)")

# Store the json data that is returned. Overwrite the last file.
echo $response >/home/bitnami/apps/wordpress/htdocs/static/history.json