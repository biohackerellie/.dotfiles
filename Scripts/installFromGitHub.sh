#!/bin/bash

# Exit on error
set -e

# Function to extract tag name from GitHub API URL
get_tag_name_from_api() {
  local apiURL="$1"
  curl -s "$apiURL" | grep -Po '"tag_name": "\K[^"]*'
}

# Get GitHub releases URL
echo "Enter the GitHub releases URL (ending in /releases/latest or the API URL):"
read -r githubURL

# Validate GitHub URL
if echo "$githubURL" | grep -qE "^https://github.com/.+/releases/latest$"; then
  # Convert regular GitHub URL to API URL
  apiURL="${githubURL/github.com/api.github.com/repos}"
  apiURL="${apiURL/releases/latest}"
elif echo "$githubURL" | grep -qE "^https://api.github.com/repos/.+/releases/latest$"; then
  apiURL="$githubURL"
else
  echo "Invalid GitHub releases URL."
  exit 1
fi

# Get the app name excluding tar.gz
echo "Enter the app name excluding .tar.gz (example 'appname.tar.gz' enter 'appname'):"
read -r appName

# Validate app name
if [ -z "$appName" ]; then
  echo "App name cannot be empty."
  exit 1
fi

# Get the latest tag name
APPVERSION=$(get_tag_name_from_api "$apiURL")

# Check if APPVERSION is retrieved
if [ -z "$APPVERSION" ]; then
  echo "Failed to retrieve the latest version."
  exit 1
fi

# Construct the download URL
downloadURL="https://github.com/${apiURL#https://api.github.com/repos/}/download/${appName}_${APPVERSION}_Linux_x86_64.tar.gz"

# Download the app
curl -Lo "${appName}.tar.gz" "$downloadURL"

# Extract the tar.gz file
if tar xf "${appName}.tar.gz" "$appName"; then
  echo "Extracted $appName successfully."
else
  echo "Failed to extract $appName. The downloaded file may not be a valid tar.gz archive."
  exit 1
fi

# Install the app
sudo install "$appName" /usr/local/bin

# Clean up
rm "${appName}.tar.gz"

echo "$appName version $APPVERSION installed successfully."

