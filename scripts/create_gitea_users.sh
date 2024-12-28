#!/bin/bash

# Copyright (C) 2024 Vipin Dabas
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program. If not, see <https://www.gnu.org/licenses/>.



GITEA_URL="http://localhost:4000"
ADMIN_USER="user1"
ADMIN_PASSWORD="admin_password"
ORG_NAME="nagarro"

# Token name
TOKEN_NAME="admin_token"

# Encode username and password in base64 for Basic Auth
AUTH_HEADER=$(echo -n "$ADMIN_USER:$ADMIN_PASSWORD" | base64)
echo "auth header : $AUTH_HEADER"

# Check if org exists and delete it
ORG_ID=$(curl -s -X GET "$GITEA_URL/api/v1/orgs/$ORG_NAME" \
    -H "authorization: Basic $AUTH_HEADER" \
    -H "Content-Type: application/json" | jq -r '.id')

if [ "$ORG_ID" != "null" ]; then
    echo "Org exists. Deleting org..."
    DELETE_RESPONSE=$(curl -s -X DELETE "$GITEA_URL/api/v1/orgs/$ORG_NAME" \
        -H "authorization: Basic $AUTH_HEADER" \
        -H "Content-Type: application/json")
    echo "Existing org deleted. $DELETE_RESPONSE"
else
  echo "Org does not exist."
  # create org
  RESPONSE=$(curl -s -X POST "$GITEA_URL/api/v1/orgs" \
      -H "authorization: Basic $AUTH_HEADER" \
      -H "Content-Type: application/json" \
      -d "{\"username\": \"$ORG_NAME\",\"description\": \"
      $ORG_NAME organization\",\"full_name\": \"$ORG_NAME\"}")
  # Extract the org ID from the response
  ORG_ID=$(echo "$RESPONSE" | jq -r '.id')
  if [ "$ORG_ID" != "null" ]; then
      echo "Org created successfully. Org_ID: $ORG_ID"
  else
      echo "Failed to create org. Response: $RESPONSE"
  fi
fi

# Check if the token exists and delete it
TOKEN_ID=$(curl -s -X GET "$GITEA_URL/api/v1/users/$ADMIN_USER/tokens" \
    -H "authorization: Basic $AUTH_HEADER" \
    -H "Content-Type: application/json" | jq -r 'select(length > 0) | .[] | .id')

if [ "$TOKEN" != "null" ]; then
    echo "Token exists. Token_ID: $TOKEN_ID"
    echo "Token exists. Deleting token..."
    DELETE_RESPONSE=$(curl -s -X DELETE "$GITEA_URL/api/v1/users/$ADMIN_USER/tokens/$TOKEN_ID" \
        -H "authorization: Basic $AUTH_HEADER" \
        -H "Content-Type: application/json")
    echo "Existing token deleted. $DELETE_RESPONSE"
fi

# Make the POST request to create a new token
RESPONSE=$(curl -s -X POST "$GITEA_URL/api/v1/users/$ADMIN_USER/tokens" \
    -H "authorization: Basic $AUTH_HEADER"\
    -H "Content-Type: application/json" \
    -d "{\"name\": \"$TOKEN_NAME\",\"scopes\":[\"write:admin\",\"write:repository\"]}")

# Extract the token from the response
TOKEN=$(echo "$RESPONSE" | jq -r '.sha1')

if [ "$TOKEN" != "null" ]; then
    echo "Token created successfully: $TOKEN"
else
    echo "Failed to create token. Response: $RESPONSE"
fi
# delete users if exists
for i in {2..10}
do
  USERNAME="user$i"
  PASSWORD="password$i"
  EMAIL="user$i@example.com"
  RESPONSE=$(curl -s -X DELETE "$GITEA_URL/api/v1/admin/users/$USERNAME?purge=true" -H "authorization: Basic $AUTH_HEADER" -H "Content-Type: application/json")
  
  echo "Delete user query Response: $RESPONSE"

done
# Create initial 10 users
for i in {2..10}
do
  USERNAME="user$i"
  PASSWORD="password$i"
  EMAIL="user$i@example.com"
  RESPONSE=$(curl -s -X POST "$GITEA_URL/api/v1/admin/users" -H "authorization: Basic $AUTH_HEADER" -H "Content-Type: application/json" -d '{"username":"'$USERNAME'","password":"'$PASSWORD'","email":"'$EMAIL'"}')
  # Check if user was created successfully
  SUCCESS=$(echo "$RESPONSE" | jq -r '.username')

  if [ "$SUCCESS" == "$USERNAME" ]; then
    echo "User $USERNAME created successfully."
  else
    echo "Failed to create user $USERNAME. Response: $RESPONSE"
  fi
done

echo "Gitea setup complete and users created."