#!/bin/bash
#This script will return the users which have read acces in your repo

# GitHub API URL
API_URL="https://api.github.com"

# GitHub username and personal access token for authrntication
USERNAME=$username # your Git Username
TOKEN=$token # your Git Token

# User and Repository information
# while running the script run following command
# ./list-users.sh ShekharLokare16 ShekharLokare16 (org_name repo_name)
REPO_OWNER=$1 # org_name
REPO_NAME=$2  # repo_name

# Function to make a GET request to the GitHub API
function github_api_get {
    local endpoint="$1"
    local url="${API_URL}/${endpoint}"

    # Send a GET request to the GitHub API with authentication
    curl -s -u "${USERNAME}:${TOKEN}" "$url"
}

# Function to list users with read access to the repository
function list_users_with_read_access {
    local endpoint="repos/${REPO_OWNER}/${REPO_NAME}/collaborators"

    # Fetch the list of collaborators on the repository
    collaborators="$(github_api_get "$endpoint" | jq -r '.[] | select(.permissions.pull == true) | .login')" # as script uses jq u have to install jq using  sudo apt install jq -y

    # Display the list of collaborators with read access
    if [[ -z "$collaborators" ]]; then
        echo "No users with read access found for ${REPO_OWNER}/${REPO_NAME}."
    else
        echo "Users with read access to ${REPO_OWNER}/${REPO_NAME}:"
        echo "$collaborators"
    fi
}

# Main script

echo "Listing users with read access to ${REPO_OWNER}/${REPO_NAME}..."
list_users_with_read_access
