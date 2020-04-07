#!/bin/bash

# spotify_platform_oauth.sh
#
# A script to quickly and easily refresh Spotify oauth tokens.

# spotify_client_creds.json should contain a spotify client id and secret pair
# base64 encoded as a json object with property `auth`. It should also include
# a spotify refresh token with property `refresh`.

refresh_token=$(jq -r '.refresh' .config/spotify_client_creds.json)
auth_token=$(jq -r '.auth' .config/spotify_client_creds.json)

response=$(curl -s https://accounts.spotify.com/api/token \
-H "Content-Type:application/x-www-form-urlencoded" \
-H "Authorization: Basic $(echo -n $auth_token)" \
-d "grant_type=refresh_token" \
-d "refresh_token=$(echo -n $refresh_token)")


# store the response just in case we need it to debug something
echo $response
echo $response > .config/auth_response

# update spotify_client_creds.json with the new access token 
jq '.access = $akey' --arg akey $(echo $response | jq -r '.access_token') .config/spotify_client_creds.json > .config/creds.tmp
mv .config/creds.tmp .config/spotify_client_creds.json