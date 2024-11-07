#!/bin/bash

# Set the log file path
LOG_FILE="/var/log/user_logins.log"

# Get current date and time
TIMESTAMP=$(date "+%Y-%m-%d %H:%M:%S")

# Get username of the logged-in user
USERNAME=$(whoami)

# Get IP address of the login
IP_ADDRESS=$(who -u am i | awk '{print $NF}' | sed 's/[()]//g')

# Get hostname
HOSTNAME=$(hostname)

# Append login data to the log file
echo "$TIMESTAMP | User: $USERNAME | IP: $IP_ADDRESS | Host: $HOSTNAME" >> "$LOG_FILE"

# Print a message to confirm data collection
echo "Login data collected and saved to $LOG_FILE"